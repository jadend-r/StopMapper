//
//  Logic.swift
//  StopMapper
//
//  Created by Jaden Reid on 8/19/22.
//

import Foundation
import SwiftUI
import CoreLocation

struct Root: Decodable {
    let elements : [traffic_node]
}

class Logic: ObservableObject{
    @ObservedObject var lm = LocationManager()
    @Published var bbox = ""
    @Published var data: [traffic_node]?
    let Request = RequestManager()
    let decoder = JSONDecoder()
    
    init(){
        self.mainLoop()
    }
    
    
    func mainLoop(){
        Timer.scheduledTimer(withTimeInterval: 20, repeats: true){ [self] timer in
            self.bbox = self.lm.getBBox()
            let requesturl = "https://www.overpass-api.de/api/interpreter?data=[out:json];node[highway=traffic_signals](" + self.lm.getBBox() + ");out%20meta;"
            self.Request.makeRequest(url: requesturl) { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.lm.clearNodeRegionMonitoring()
                        self.data = try! self.decoder.decode(Root.self, from: data).elements
                        if let nodes = self.data {
                            self.lm.startNodeRegionMonitoring(nodes: nodes)
                        }
                        print(self.data)
                    }
                }
            }
        }
    }
}
