//
//  GameScene.swift
//  WarriorOfLeporia
//
//  Created by Kirupa Nijastan on 2/28/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsMasks {
    static let None: UInt32 = 0 // 0
    static let Player: UInt32 = 0b1 // 1
    static let Enemy: UInt32 = 0b10 // 2
    static let Bullet: UInt32 = 0b100 // 4
    static let LevelBounds: UInt32 = 0b1000 // 8
}


class GameScene: SKScene, SKPhysicsContactDelegate {

    var gameOver = false
    var lastUpdateTime : TimeInterval = 0
    var observers: [Observer] = []
    
    // Game objects
    var background: SKNode?
    var entityManager: EntityManager?
    var player: PlayerEntity?
    
    // Score labels
    var UI: GUI?
    
    override func didMove(to view: SKView) {
        // Added bounding box around level
        background = childNode(withName: "background")
        physicsBody = SKPhysicsBody(edgeLoopFrom: (background?.frame)!)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsMasks.LevelBounds
        
        // Initialize player entity and manager
        entityManager = EntityManager(scene: self)
        
        player = PlayerEntity(imageName: "idle1-s", scale: 1, background: background!, camera: camera!, view: view, scene: scene! as! GameScene)
        if let spriteComponent = player?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width/2, y: size.height/2)
        }
        entityManager?.add(player!)
        
        // Add score stuff
        UI = GUI(scene: scene! as! GameScene, player: player!, camera: camera!)
        observers.append(UI!)
        
        // Spawn enemies over time. Factory pattern
        spawnEnemyOverTime(time: 4.0)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if gameOver {
            return
        }
        
        if ((UI?.getLives())! <= Int(0)) {
            let dieParticle = entityManager?.playerDeathExplode(intensity: 0.01)
            dieParticle?.position = (player?.spriteComponent?.node.position)!
            self.addChild(dieParticle!)
            
            player?.spriteComponent?.node.removeFromParent()
            player?.removeComponent(ofType: SpriteComponent.self)
            gameOver = true
        }
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        
        UI?.update()
        // Update score
        
        
        player?.update(deltaTime: dt)
        self.lastUpdateTime = currentTime
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if gameOver {
            return
        }
        
        if (collision == PhysicsMasks.Player | PhysicsMasks.Enemy) {
            print("You collided with enemy!")
            for obs in observers {
                obs.onNotify(event: NotifyEvent.HURT)
            }
        } else if (collision == PhysicsMasks.Enemy | PhysicsMasks.Bullet) {
            print("you shot an enemy!")
            // Remove from scene
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            let dieParticle = entityManager?.deathExplode(intensity: 0.01)
            dieParticle?.position = (contact.bodyB.node?.position)!
            self.addChild(dieParticle!)
            
            for obs in observers {
                obs.onNotify(event: NotifyEvent.SCORE)
            }
            // Remove from entity list
            entityManager?.remove(contact.bodyA.node!) // remove enemy which is also in entity list
            entityManager?.remove(contact.bodyB.node!)
        }
    }

    
    
    func spawnEnemyOverTime(time: Double) {
        let wait:SKAction = SKAction.wait(forDuration: time)
        let finishTimer:SKAction = SKAction.run {
            self.entityManager?.spawnEnemy(ptarget: self.player!) // factory
            
            if (!self.gameOver) {
                self.spawnEnemyOverTime(time: time)
            }
        }
        let seq:SKAction = SKAction.sequence([wait, finishTimer])
        self.run(seq)
    }
}
