//
//  EntityManager.swift
//  WarriorOfLeporia
//
//  Created by Nijastan Kirupa on 3/19/18.
//  Copyright © 2018 Kirupa Nijastan. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            print("deleeeting!")
            spriteNode.removeAllActions()
            spriteNode.removeFromParent()
        }
        entities.remove(entity)
    }
    
    func remove(_ node: SKNode) {
        for ent in entities {
            let spriteNode = ent.component(ofType: SpriteComponent.self)?.node
            if (spriteNode == node) {
                self.remove(ent)
            }
        }
        print(entities.count)
    }
    
    func spawnBullet(shootRight: Bool, shooter: CharacterEntity) {
        let bullet = BulletEntity(shootRight: shootRight)
        
        if let spriteComponent = bullet.component(ofType: SpriteComponent.self) {
            if (shootRight) {
            spriteComponent.node.position = CGPoint(x: shooter.spriteComponent!.node.position.x + 30, y: shooter.spriteComponent!.node.position.y)
            } else {
                spriteComponent.node.position = CGPoint(x: shooter.spriteComponent!.node.position.x - 30, y: shooter.spriteComponent!.node.position.y)
            }
        }
     //   scene.addChild((bullet.component(ofType: SpriteComponent.self)?.node)!)
        add(bullet)
    }
    
    func spawnEnemy(ptarget: PlayerEntity)
    {
        let blob = BlobEntity(imageName: "slime1-s", scale: 1, target: ptarget)
        if let spriteComponent = blob.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGFloat.random(min: -450.0, max: 450.0), y: 100.0)
        }
        add(blob)
    }
    
    func deathExplode(intensity: CGFloat) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "bullet-s")
        emitter.zPosition = 2
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 4000 * intensity
        emitter.numParticlesToEmit = Int(400 * intensity)
        emitter.particleLifetime = 2.0
        emitter.emissionAngle = CGFloat(90.0 * Double.pi/180.0)
        emitter.emissionAngleRange = CGFloat(360.0 * Double.pi/180.0)
        emitter.particleSpeed = 600 * intensity
        emitter.particleSpeedRange = 1000 * intensity
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.25
        emitter.particleScale = 1.5
        emitter.particleScaleRange = 2.5
        emitter.particleScaleSpeed = -1.5
        emitter.particleColor = SKColor.cyan
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.add
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
        emitter.run(sequence)
        
        return emitter
    }
    
    func playerDeathExplode(intensity: CGFloat) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "idle1-s")
        emitter.zPosition = 2
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 4000 * intensity
        emitter.numParticlesToEmit = Int(400 * intensity)
        emitter.particleLifetime = 2.0
        emitter.emissionAngle = CGFloat(90.0 * Double.pi/180.0)
        emitter.emissionAngleRange = CGFloat(360.0 * Double.pi/180.0)
        emitter.particleSpeed = 600 * intensity
        emitter.particleSpeedRange = 1000 * intensity
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.25
        emitter.particleScale = 1.2
        emitter.particleScaleRange = 2.0
        emitter.particleScaleSpeed = -1.5
        emitter.particleColor = SKColor.red
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.add
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
        emitter.run(sequence)
        
        return emitter
    }
    
}
