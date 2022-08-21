//
//  ContentView.swift
//  StopMapper
//
//  Created by Jaden Reid on 8/19/22.
//

import SwiftUI

struct traffic_node_row: View {
    var trafficnode: traffic_node
    
    var body: some View {
        Text(verbatim: "id: \(trafficnode.id), lat: \(trafficnode.lat), lon:\(trafficnode.lon)")
    }
}

struct ContentView: View {
    
    @ObservedObject var AppLogic = Logic()
    @ObservedObject var lm  = LocationManager()
    
    var latitude: String  { return("\(lm.location?.coordinate.latitude ?? 0)") }
    var longitude: String { return("\(lm.location?.coordinate.longitude ?? 0)") }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Latitude: \(self.latitude)")
            Text("Longitude: \(self.longitude)")
            Spacer()
            Text("Bbox: \(AppLogic.bbox)")
            Spacer()
            //Text("data from overpass: \(AppLogic.data)")
            //Spacer()
        }
        .padding()
        if let node_data = AppLogic.data {
            List(node_data) { trafficnode in
                traffic_node_row(trafficnode: trafficnode)
            }
            Spacer()
        }
        
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       // ContentView()
    }
}*/
