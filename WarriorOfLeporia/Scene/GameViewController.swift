//
//  GameViewController.swift
//  WarriorOfLeporia
//
//  Created by Kirupa Nijastan on 2/28/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var h : Highscores!
    override func viewDidLoad() {
        super.viewDidLoad()
        h = Highscores()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Menu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            //h.sendScore(value: 1)
            h.getHighScores(completion: { (value) in
                if Thread.isMainThread {
                  print("high score value is: \(value)")
                    return
                }
                DispatchQueue.main.async {
                    print("high score value is: \(value)")
                }
            })

            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
