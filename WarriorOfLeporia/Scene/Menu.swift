//
//  Menu.swift
//  WarriorOfLeporia
//
//  Created by Kirupa Nijastan on 4/17/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKScene {
    
    var startButton: ButtonNode!
    
    override func didMove(to view: SKView) {
        print("testing")
        
        // Add start button
        startButton = ButtonNode(iconName: "grey-squareblock-tile1", text: "Start", onButtonPress: startPressed, pressOnly: true)
        startButton.position = CGPoint(x: 0, y: 0)
        self.addChild(startButton)
    }
    
    func startPressed() {
 //       let trans:SKTransition = SKTransition.fade(withDuration: 1)
        let newscene:SKScene = SKScene(fileNamed: "GameScene")!
        newscene.scaleMode = .resizeFill
        self.view?.presentScene(newscene)
    }
    
}


