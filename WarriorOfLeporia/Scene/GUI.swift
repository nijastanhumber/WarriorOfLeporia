//
//  GUI.swift
//  WarriorOfLeporia
//
//  Created by Kirupa Nijastan on 4/4/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GUI : Observer
{
    func onNotify(event: NotifyEvent) {
        switch event {
        case NotifyEvent.SCORE:
            score = score + 1
        case NotifyEvent.HURT:
            removeLife()
        }
    }

    // Button variables
    var leftButton: ButtonNode!
    var rightButton: ButtonNode!
    var jumpButton: ButtonNode!
    var shootButton: ButtonNode!
    var backToMenu: ButtonNode!
    
    let scene: GameScene
    let player: PlayerEntity
    let camera: SKCameraNode
    
    // Score label
    let Score = SKSpriteNode(imageNamed: "coin")
    let scoreLabel = SKLabelNode(fontNamed: "Courier-Bold")
    let scoreToBeatLabel = SKLabelNode(fontNamed: "Courier-Bold")
    var score = 0
    
    let highscoreLabel = SKLabelNode(fontNamed: "Courier-Bold")
    
    var lifeSprites: [SKSpriteNode] = [SKSpriteNode]()
    var lives = 5
    
    init(scene: GameScene, player: PlayerEntity, camera: SKCameraNode) {
        self.scene = scene
        self.player = player
        self.camera = camera
        populateButtons()
        
        for index in 1...lives {
            let li : SKSpriteNode!
            li = SKSpriteNode(imageNamed: "carrot")
            li.position = CGPoint(x: 230 + index * 20, y: 160)
            lifeSprites.append(li)
        }
        
        Score.xScale = 0.5
        Score.yScale = 0.5
        Score.position = CGPoint(x: -340, y: 160)
        camera.addChild(Score)
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.position = CGPoint(x: -320, y: 160)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.text = "0"
        camera.addChild(scoreLabel)
        scoreToBeatLabel.fontSize = 28
        scoreToBeatLabel.fontColor = SKColor.yellow
        scoreToBeatLabel.position = CGPoint(x: -340, y: 130)
        scoreToBeatLabel.horizontalAlignmentMode = .left
        scoreToBeatLabel.verticalAlignmentMode = .center
        scoreToBeatLabel.text = ""
        camera.addChild(scoreToBeatLabel)
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = SKColor.yellow
        highscoreLabel.position = CGPoint(x: 0, y: 50)
        highscoreLabel.horizontalAlignmentMode = .center
        highscoreLabel.verticalAlignmentMode = .center
        highscoreLabel.text = ""
        camera.addChild(highscoreLabel)
        
        for lifeSprite in lifeSprites {
            camera.addChild(lifeSprite)
        }
        
        displayScoreToBeat()
    }
    
    func getLives() -> Int {
        return lives
    }
    
    func populateButtons()
    {
        // Add left button
        leftButton = ButtonNode(iconName: "grey-squareblock-tile1", text: "left", onButtonPress: leftPressed, pressOnly: false)
        leftButton.position = CGPoint(x: -300, y: 0)
        camera.addChild(leftButton)
        
        // Add right button
        rightButton = ButtonNode(iconName: "grey-squareblock-tile1", text: "right", onButtonPress: rightPressed, pressOnly: false)
        rightButton.position = CGPoint(x: -200, y: 0)
        camera.addChild(rightButton)
        
        // Add jump button
        jumpButton = ButtonNode(iconName: "grey-squareblock-tile1", text: "jump", onButtonPress: jumpPressed, pressOnly: true)
        jumpButton.position = CGPoint(x: 300, y: 50)
        camera.addChild(jumpButton)
        
        // Add shoot button
        shootButton = ButtonNode(iconName: "grey-squareblock-tile1", text: "Shoot", onButtonPress: shootPressed, pressOnly: true)
        shootButton.position = CGPoint(x: 300, y: 0)
        camera.addChild(shootButton)
    }
    
    func leftPressed() {
        player.moveLeft()
    }
    
    func rightPressed() {
        player.moveRight()
    }
    
    func jumpPressed() {
        player.jump()
    }
    
    func shootPressed() {
        player.shoot()
    }
    
    func backPressed() {
        let newscene:SKScene = SKScene(fileNamed: "Menu")!
        newscene.scaleMode = .resizeFill
        scene.view?.presentScene(newscene)
    }
    
    func removeLife() {
        if (lifeSprites.count > 0) {
            let li = lifeSprites[lifeSprites.count-1]
            lifeSprites.remove(at: lifeSprites.count-1)
            li.removeFromParent()
        }
        lives = lives - 1
    }
    
    func displayScoreToBeat() {
        let h = Highscores()
        h.getHighScores(completion: { (value) in
            if Thread.isMainThread {
                self.scoreToBeatLabel.text = "Current record: \(value)"
                return
            }
            DispatchQueue.main.async {
                self.scoreToBeatLabel.text = "Current record: \(value)"
                return
            }
        })
    }
    
    func checkIfHighscore() {
        let h = Highscores()
        h.getHighScores(completion: { (value) in
            if Thread.isMainThread {
                if (self.score > value) {
                    print("new highscore of: \(self.score)")
                    self.highscoreLabel.text = "New Highscore!"
                    self.scene.run(SKAction.playSoundFileNamed("win.wav", waitForCompletion: true))
                    h.sendScore(value: self.score)
                }
                return
            }
            DispatchQueue.main.async {
                if (self.score > value) {
                    print("new highscore of: \(self.score)")
                    self.highscoreLabel.text = "New Highscore!"
                    h.sendScore(value: self.score)
                }
                return
            }
        })
    }
    
    func update() {
        // Controls stuff
        if (leftButton.pressed) {
            leftPressed()
        } else if (rightButton.pressed) {
            rightPressed()
        }
        
        scoreLabel.text = "\(score)"
        
        if (scene.gameOver) {
            backToMenu = ButtonNode(iconName: "grey-squareblock-tile1", text: "Back", onButtonPress: backPressed, pressOnly: true)
            backToMenu.position = CGPoint(x: 0, y: 100)
            camera.addChild(backToMenu)
            
            checkIfHighscore()
        }
    }
}
