//
//  CoreDataHelp.swift
//  Pokemon go
//
//  Created by Radoslav Hlinka on 16/11/2017.
//  Copyright © 2017 Radoslav Hlinka. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemons() {
    
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Pikatchu", imageName: "pikatchu-2")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    createPokemon(name: "Rattata", imageName: "rattata")
    createPokemon(name: "Zubar", imageName: "zubat")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name : String, imageName : String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
    
}

func getAllPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemons()
            return getAllPokemons()
        }
        
        return pokemons
    }catch{}
    return []
}

func getAllCaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do{
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate.init(format: "caught == %@", true)
        
        let pokemons = try context.fetch(fetchRequest) as! [Pokemon]
        
        return pokemons
    } catch {}
    
    return []
}

func getAllUnCaughtPokemons() -> [Pokemon] {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do{
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate.init(format: "caught == %@", false)
        
        let pokemons = try context.fetch(fetchRequest) as! [Pokemon]
        
        return pokemons
    } catch {}
    
    return []
}
