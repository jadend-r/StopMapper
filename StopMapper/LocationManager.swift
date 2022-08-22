//
//  LocationManager.swift
//  StopMapper
//
//  Created by Jaden Reid on 8/19/22.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
  private let locationManager = CLLocationManager()
  let objectWillChange = PassthroughSubject<Void, Never>()

  @Published var status: CLAuthorizationStatus? {
    willSet { objectWillChange.send() }
  }

  @Published var location: CLLocation? {
    willSet { objectWillChange.send() }
  }
    
    @Published var currentRegion: CLRegion? {
        willSet {objectWillChange.send()}
    }

  override init() {
      print("init running")
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestAlwaysAuthorization()
    //self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
  }
    
    func getBBox() -> String {
        let latconst = (1.0/69)
        let longconst = (1/54.6)
        let long1 = (self.location?.coordinate.longitude ?? -longconst) + longconst
        let lat1 = (self.location?.coordinate.latitude ?? -latconst) + latconst
        let long2 = (self.location?.coordinate.longitude ?? longconst) - longconst
        let lat2 = (self.location?.coordinate.latitude ?? latconst) - latconst
        
        return "\(lat2),\(long2),\(lat1),\(long1)"
    }
    
    func startNodeRegionMonitoring(nodes: [traffic_node]){
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            for node in nodes {
                let node_center = CLLocationCoordinate2D(latitude: node.lat, longitude: node.lon)
                let region = CLCircularRegion(center: node_center, radius: 50, identifier: String(node.id))
                region.notifyOnEntry = true
                region.notifyOnExit = true
                self.locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func clearNodeRegionMonitoring(){
        let monitored_nodes = self.locationManager.monitoredRegions
        for region in monitored_nodes {
            self.locationManager.stopMonitoring(for: region)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.currentRegion = region
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if self.currentRegion == region {
            self.currentRegion = nil
        }
    }
}
