//
//  PokeAnnotation.swift
//  Pokemon go
//
//  Created by Radoslav Hlinka on 16/11/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var pokemon : Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon : Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon
    }
    
}
