//
//  Task.swift
//  DailyGoals
//
//  Created by Mike Capecci on 7/19/20.
//  Copyright © 2020 Mike Capecci. All rights reserved.
//

import Cocoa

struct Task: Codable {
    var taskName: String
    var notificationTime: String
    var rowId: String
    var sortOrder: Int32
}
