//
//  LocationManager.swift
//  weather-swiftui
//
//  Created by Martin Stojcev on 2023-02-05.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var location: CLLocation?
    
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getCurrentLocation(_ completion: @escaping (_ location: CLLocation) -> Void) {
        manager.requestWhenInUseAuthorization()
        
        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorizedWhenInUse {
            location = manager.location
            completion(location ?? CLLocation())
            print("location setted")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        print("location did updated")
    }
    
}
