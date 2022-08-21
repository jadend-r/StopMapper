//
//  RequestManager.swift
//  StopMapper
//
//  Created by Jaden Reid on 8/19/22.
//

import Foundation
import UIKit

class RequestManager {
    func makeRequest(url: String, completion: @escaping(_ data: Data?) -> ()) {
        let requesturl = URL(string: url)!
        var request = URLRequest(url: requesturl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var responsedata: Data?
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                responsedata = data
                completion(responsedata)
            } else if error != nil {
                completion(nil)
            }
        }
        task.resume()
    }
}
