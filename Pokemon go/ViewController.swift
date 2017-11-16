//
//  ViewController.swift
//  Pokemon go
//
//  Created by Radoslav Hlinka on 15/11/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemons()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        } else {
            
            mapView.delegate = self
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true
                , block: { (timer) in
                    if let coord = self.manager.location?.coordinate {
                        let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                        let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                        
                        anno.coordinate.latitude += self.randomCoordinates()
                        anno.coordinate.longitude += self.randomCoordinates()
                        
                        self.mapView.addAnnotation(anno)
                    }
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
        } else {
            annoView.image = UIImage(named: (annotation as! PokeAnnotation).pokemon.imageName!)
        }
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
        
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

