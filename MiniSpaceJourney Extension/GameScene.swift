//
//  GameScene.swift
//  MiniSpaceJourney Extension
//
//  Created by Daniil Popov on 6/15/19.
//  Copyright © 2019 Daniil Popov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var spinnyNode : SKShapeNode?
    
    // just CGFloat null, no magic numbers
    var cgNull:CGFloat = 0.0;
    
    // score
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)";
        }
    }
    // spaceship
    var spaceship:SKSpriteNode = SKSpriteNode(imageNamed: "shuttle");
    // aliens
    var possibleAliens = ["alien", "alien2", "alien3"];
    
    // each object has own category for collisions
    let spaceshipCategory:UInt32     = 0x1 << 2;
    let alienCategory:UInt32         = 0x1 << 1;
    let photonTorpedoCategory:UInt32 = 0x1 << 0;
    
    override func sceneDidLoad() {
        // assign few properties to objects from GameScene
        for node in self.children {
            if (node.name == "spaceship") {
                if let ship:SKSpriteNode = node as? SKSpriteNode {
                    spaceship = ship;
                    spaceship.zPosition = 1;
                    
                    spaceship.physicsBody?.categoryBitMask    = spaceshipCategory;
                    spaceship.physicsBody?.contactTestBitMask = alienCategory;
                    spaceship.physicsBody?.collisionBitMask   = 0;
                }
            }
            
            if (node.name == "scoreLabel") {
                if let scoreLab:SKLabelNode = node as? SKLabelNode {
                    scoreLabel           = scoreLab;
                    scoreLabel.text      = "Score: 0";
                    scoreLabel.fontName  = "Helvetica-Bold";
                    scoreLabel.fontSize  = 26;
                    scoreLabel.zPosition = 1;
                    score = 0;
                }
            }
        }
        
        self.physicsWorld.gravity         = CGVector( dx: 0, dy: 0);
        self.physicsWorld.contactDelegate = self;
        
        // spawns alien
        _ = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        // fire torpedos
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTorpedo), userInfo: nil, repeats: true)
    }
    
    @objc func addAlien() {
        let possibleAlien = possibleAliens.randomElement()!;
        let alien         = SKSpriteNode(imageNamed: possibleAlien);
        let randomX       = Int.random(in: -Int(self.frame.size.width / 2 - alien.size.width) ..< Int(self.frame.size.width / 2 - alien.size.width));

        alien.position    = CGPoint(x: CGFloat(randomX), y: self.frame.size.height / 2 - alien.size.height);

        alien.physicsBody            = SKPhysicsBody(rectangleOf: alien.size);
        alien.physicsBody?.isDynamic = true;

        alien.physicsBody?.categoryBitMask    = alienCategory;
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory | spaceshipCategory;
        alien.physicsBody?.collisionBitMask   = 0;
        
        self.addChild(alien);
        
        let animationDuration:TimeInterval = 6;
        var actionArray = [SKAction]();
        
        actionArray.append(SKAction.move(to: CGPoint(x: alien.position.x, y: -self.frame.height), duration: animationDuration));
        actionArray.append(SKAction.removeFromParent());
        
        alien.run(SKAction.sequence(actionArray));
    }
    
    @objc func fireTorpedo() {
        // self.run(SKAction.playSoundFileNamed(".mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo");
        torpedoNode.position    = spaceship.position;
        torpedoNode.position.y += 5;
        
        torpedoNode.physicsBody            = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2);
        torpedoNode.physicsBody?.isDynamic = true;
        
        torpedoNode.physicsBody?.categoryBitMask    = photonTorpedoCategory;
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory;
        torpedoNode.physicsBody?.collisionBitMask   = 0;

        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true;
        
        self.addChild(torpedoNode);
        
        let animationDuration:TimeInterval = 0.3;
        
        var actionArray = [SKAction]();
        
        actionArray.append(SKAction.move(to: CGPoint(x: spaceship.position.x, y: self.frame.height + 10), duration: animationDuration));
        actionArray.append(SKAction.removeFromParent());
        
        torpedoNode.run(SKAction.sequence(actionArray));
    }
    
    func moveSpaceshipBy(amountX:CGFloat, amountY:CGFloat) {
        
        let move:SKAction = SKAction.moveBy(x: amountX, y: amountY, duration: 0);
        move.timingMode   = .easeOut;
        
        // check the boarders and movement direction
        if (-self.frame.size.width / 2 < spaceship.position.x - spaceship.size.width && amountX < cgNull) {
            spaceship.run (move);
        }
        
        if (spaceship.position.x < self.frame.size.width / 2 - spaceship.size.width && amountX > cgNull) {
            spaceship.run (move);
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody;
        var secondBody:SKPhysicsBody;
        
        if contact.bodyA.categoryBitMask < contact.bodyB.collisionBitMask {
            firstBody  = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody  = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0
            && (secondBody.categoryBitMask & alienCategory) != 0 {
            torpedoCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode);
        }
        
        if  (firstBody.categoryBitMask & alienCategory) != 0
            && (secondBody.categoryBitMask & spaceshipCategory) != 0 {
            alienCollidedWithSpaceship(alienNode: firstBody.node as! SKSpriteNode, spaceshipNode: secondBody.node as! SKSpriteNode);
        }
    }
    
    func torpedoCollideWithAlien( torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
        // add explosion
        let explosion = SKSpriteNode(fileNamed: "explosion")!;
        
        explosion.size     = CGSize(width: 5, height: 5);
        explosion.position = alienNode.position;
        
        self.addChild(explosion);
        
        // self.run(SKAction.playSoundFileNamed(".mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent();
        alienNode.removeFromParent();
        
        self.run(SKAction.wait(forDuration: 0.1)) {
            explosion.removeFromParent();
        }
        
        score += 1;
    }
    
    func alienCollidedWithSpaceship( alienNode:SKSpriteNode, spaceshipNode:SKSpriteNode) {
        alienNode.removeFromParent();
        
        score = 0;
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}
