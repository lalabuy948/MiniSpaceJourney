//
//  InterfaceController.swift
//  MiniSpaceJourney Extension
//
//  Created by Daniil Popov on 6/15/19.
//  Copyright © 2019 Daniil Popov. All rights reserved.
//

import WatchKit
import Foundation


class GameScreenController: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    public var crownSensivity:Double = 25.0
    
    var gameScene:GameScene!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // start listening to crown
        crownSequencer.delegate = self
        crownSequencer.focus()
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = GameScene(fileNamed: "GameScene") {
            
            gameScene = scene
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skInterface.presentScene(scene)
            
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 30
        }
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        // convert crown rotation to CGFloat
        let step   = NSNumber.init(value: rotationalDelta * crownSensivity).floatValue
        let cgStep = CGFloat(step)
        
        WKInterfaceDevice.current().play(.click)

        gameScene.moveSpaceshipBy(amountX: cgStep, amountY: 0)
    }
    
    // @todo: add pause/unpause by touches

    @IBAction func swipedRight(_ sender: Any) {
        
        WKInterfaceController.reloadRootPageControllers(
            withNames: ["MainMenu"], contexts: [], orientation: .horizontal, pageIndex: 0
        )
        
        self.pushController(withName: "MainMenu", context: nil)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
