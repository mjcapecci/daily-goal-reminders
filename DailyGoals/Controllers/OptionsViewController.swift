//
//  OptionsViewController.swift
//  DailyGoals
//
//  Created by Mike Capecci on 7/17/20.
//  Copyright © 2020 Mike Capecci. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.frame.size
    }
    
    
    @IBAction func onBackButton(_ sender: NSButton) {
        self.dismiss(true)
    }
    
    @IBAction func onCloseApp(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}
