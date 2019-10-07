//
//  SettingsMenuController.swift
//  MiniSpaceJourney Extension
//
//  Created by Daniil Popov on 6/18/19.
//  Copyright © 2019 Daniil Popov. All rights reserved.
//

import WatchKit


class SettingsMenuController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func pickedSelectedItem(_ value: Int) {
    }
}
