//
//  traffic_node.swift
//  StopMapper
//
//  Created by Jaden Reid on 8/20/22.
//

import Foundation

struct traffic_node: Decodable, Identifiable {
    var id: Int
    var lat: Double
    var lon: Double
}
