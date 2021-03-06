//
//  RminderViewController.swift
//  DailyGoals
//
//  Created by Mike Capecci on 6/23/20.
//  Copyright © 2020 Mike Capecci. All rights reserved.
//

import Cocoa
import UserNotifications

class ReminderViewController: NSViewController {
    
    var dataManager = DataManager()
    let formatter = DateFormatter()
    let defaults = UserDefaults.standard

    @IBOutlet weak var taskInput: NSTextField!
    @IBOutlet weak var timeInput: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.frame.size
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications enabled")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func onSubmitPress(_ sender: NSButton) {
        formatter.dateFormat = "hh:mm a"
        let visibleTime = formatter.string(from: timeInput.dateValue)
        let identifier = UUID().uuidString
        
        var adjustedTime: String {
            if Array(visibleTime)[0] == "0" {
                return String(visibleTime.dropFirst())
            } else {
                return visibleTime
            }
        }
        
        let sort = { () -> Int32 in
            let chars = Array(visibleTime)
            if chars.contains("P") {
                return Int32(visibleTime.dropLast(6))! + 12
            } else {
                return Int32(visibleTime.dropLast(6))!
            }
        }
        
        dataManager.addTask(task: Task(taskName: taskInput.stringValue, notificationTime: adjustedTime, rowId: identifier, sortOrder: sort()))
        generateNotification(rowId: identifier)
        self.dismiss(true)
    }
    
    func generateNotification(rowId: String) {
        let content = UNMutableNotificationContent()
        content.title = taskInput.stringValue
        content.subtitle = "Digital Nomad Assistant"
        content.sound = UNNotificationSound.default
        
        let dateComps = Calendar.current.dateComponents([.hour, .minute], from: timeInput.dateValue)
        print(dateComps)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
        let request = UNNotificationRequest(identifier: rowId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    @IBAction func onCancelButtonPressed(_ sender: NSButton) {
        self.dismiss(true)
    }
}
