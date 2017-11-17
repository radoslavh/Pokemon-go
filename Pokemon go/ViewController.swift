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
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUp()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    func setUp(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true
            , block: { (timer) in
                if let coord = self.manager.location?.coordinate {
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                    
                    anno.coordinate.latitude += self.randomCoordinate()
                    anno.coordinate.longitude += self.randomCoordinate()
                    
                    self.mapView.addAnnotation(anno)
                }
        })
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
    
    func randomCoordinate() -> Double {
        return (Double(arc4random_uniform(200)) - 100) / 50000.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else{
            manager.stopUpdatingLocation() 
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate{
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                if MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController.init(title: "Congratz", message: "You caught a \(pokemon.name!)", preferredStyle: .alert)
                    let OKaction = UIAlertAction.init(title: "ok", style: .default, handler: nil)
                    
                    let PokedexAction = UIAlertAction.init(title: "pokedex", style: .default, handler: {(action) in
                        self.performSegue(withIdentifier: "pokedexsegue", sender: nil)
                    })
                    
                    alertVC.addAction(PokedexAction)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    
                    let alertVC = UIAlertController.init(title: "Uh-Oh", message: "You are too far away to catch the \(pokemon.name!)", preferredStyle: .alert)
                    let OKaction = UIAlertAction.init(title: "ok", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: false)
        }
    }
}

