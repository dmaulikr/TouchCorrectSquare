//
//  GameScene.swift
//  TouchCorrectSquare
//
//  Created by Greg Willis on 3/15/16.
//  Copyright (c) 2016 Willis Programming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var leftSquare: SKSpriteNode?
    var rightSquare: SKSpriteNode?
    
    var mainLabel: UILabel!
    var scoreLabel: SKLabelNode!
    
    var customBlue = UIColor(red: 0, green: 0, blue: 0.9, alpha: 1.0)
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    var offBlackColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    
    
    var boxSize: CGFloat {
        return CGRectGetMaxX(frame) / 2 - 60
    }
    
    var currentScore = 0
    var timer = 12
    
    override func didMoveToView(view: SKView) {
        backgroundColor = customBlue
        spawnSquares()
        mainLabel = spawnMainLabel()
        scoreLabel = spawnScoreLabel()
        countDown()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if let touchedNode = nodeAtPoint(touchLocation) as? SKSpriteNode {
                if touchedNode.color.description == offWhiteColor.description {
                    addToScore()
                    spawnSquares()
                } else {
                    gameOver()
                    print("\(touchedNode.color)")
                    print("\(offWhiteColor)")
                }
            }
            
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

// MARK: - Spawn Functions
extension GameScene {
    
    func spawnSquares() {
        leftSquare?.removeFromParent()
        rightSquare?.removeFromParent()
        
        var one: UIColor
        var two: UIColor
        
        if randomizeColors() == 0 {
            one = offWhiteColor
            two = offBlackColor
        } else {
            one = offBlackColor
            two = offWhiteColor
        }
        leftSquare = createSquare(one, size: boxSize, position: CGPoint(x: CGRectGetMidX(frame)-20-boxSize/2, y: CGRectGetMidY(frame)))
        rightSquare = createSquare(two, size: boxSize, position: CGPoint(x: CGRectGetMidX(frame)+20+boxSize/2, y: CGRectGetMidY(frame)))
    }
    
    func spawnMainLabel() -> UILabel {
        mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: view!.frame.height * 0.4))
        if let mainLabel = mainLabel {
            mainLabel.textColor = offWhiteColor
            mainLabel.font = UIFont(name: "Futura", size: CGRectGetWidth(frame) * 0.14)
            mainLabel.textAlignment = .Center
            mainLabel.numberOfLines = 0
            mainLabel.text = "Choose the WHITE Square"
            view!.addSubview(mainLabel)
        }
        
        
        return mainLabel
    }
    
    func spawnScoreLabel() -> SKLabelNode {
        let score = SKLabelNode(fontNamed: "Futura")
        score.fontColor = offWhiteColor
        score.fontSize = CGRectGetWidth(frame) * 0.15
        score.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) * 0.2)
        score.text = "Score: \(currentScore)"
        
        addChild(score)
        
        
        return score
    }
}

// MARK: Timer Function
extension GameScene {
    
    func countDown() {
        
        let wait = SKAction.waitForDuration(1.0)
        let countDown = SKAction.runBlock {
            self.timer--

            if self.timer <= 10 && self.timer > 0 {
                self.mainLabel.text = "\(self.timer)"

            }
            if self.timer <= 0 {
                self.gameOver()
            }
        }
        let sequence = SKAction.sequence([wait, countDown])
        runAction(SKAction.repeatActionForever(sequence))
    }
}

// MARK: - Helper Functions
extension GameScene {
    
    func createSquare(color: UIColor, size: CGFloat, position: CGPoint) -> SKSpriteNode {
        let square = SKSpriteNode(color: color, size: CGSize(width: size, height: size))
        square.position = position
        
        addChild(square)
        
        return square
    }
    
    func addToScore() {
        currentScore++
        scoreLabel.text = "Score: \(currentScore)"
    }
    
    func randomizeColors() -> Int {
        let number = round(random())
        
        return Int(number)
    }
    
    func gameOver() {
        timer = 0
        scoreLabel.removeFromParent()
        mainLabel.text = "Loser!"
        
        // TODO: - Launch GameScene
        let wait = SKAction.waitForDuration(2.0)
        let transition = SKAction.runBlock {
            self.mainLabel.removeFromSuperview()
            if let gameScene = GameScene(fileNamed: "GameScene"), view = self.view {
                gameScene.scaleMode = .ResizeFill
                view.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        runAction(SKAction.sequence([wait, transition]))

    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
}