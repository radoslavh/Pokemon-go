//
//  ViewController.swift
//  Pokemon go
//
//  Created by Radoslav Hlinka on 15/11/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        } else {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true
                , block: { (timer) in
                    if let coord = self.manager.location?.coordinate {
                        let anno = MKPointAnnotation()
                        anno.coordinate = coord
                        anno.coordinate.latitude += self.randomCoordinates()
                        anno.coordinate.longitude += self.randomCoordinates()
                        self.mapView.addAnnotation(anno)
                    }
            })
        }
    }
    
    func randomCoordinates() -> Double {
        return (Double(arc4random_uniform(200)) - 100) / 50000.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else{
            manager.stopUpdatingLocation() 
        }
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: false)
        }
    }
}

