//
//  PokedexViewController.swift
//  Pokemon go
//
//  Created by Radoslav Hlinka on 16/11/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var unCaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPokemons = getAllCaughtPokemons()
        unCaughtPokemons = getAllUnCaughtPokemons()
        
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
