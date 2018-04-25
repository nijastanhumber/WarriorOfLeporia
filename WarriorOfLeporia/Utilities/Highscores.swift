//
//  Highscores.swift
//  WarriorOfLeporia
//
//  Created by Kirupa Nijastan on 4/18/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Highscores {
    
    let refData: DatabaseReference
    init() {
        self.refData = Database.database().reference()
    }
    
    func getHighScores(completion: @escaping (Int)->Void ){
        
        refData.child("coins").observe(DataEventType.value) { (snapshot) in
            
            guard let data = snapshot.value as? [AnyHashable: Any] else {
                print("failed to gather")
                return
            }
            
            completion(data["value"] as! Int)
        }
    
    }
    
    func sendScore(value: Int) {
        refData.child("coins").updateChildValues(["value": value])
    }
    
    
}
