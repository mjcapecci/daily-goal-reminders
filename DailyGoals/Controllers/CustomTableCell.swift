//
//  CustomTableCell.swift
//  DailyGoals
//
//  Created by Mike Capecci on 6/23/20.
//  Copyright © 2020 Mike Capecci. All rights reserved.
//

import Cocoa

class CustomTableCell: NSTableCellView {

    @IBOutlet weak var taskLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
