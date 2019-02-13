//
//  AlarmController.swift
//  Alarm
//
//  Created by RYAN GREENBURG on 1/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
   // func scheduleUserNotifications(for alarm: Alarm)
    
   // func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound.default
        notificationContent.title = "Alarm title"
        notificationContent.body = "Alarm Body"
        notificationContent.badge = 1
        
        let fireDate = alarm.fireDate
        let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelLocalNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController: AlarmScheduler {
    
    // Shared instance
    static let shared = AlarmController()
    
    // Source of truth
    var alarms: [Alarm] = []
    
    // step 2
//    weak var delegate: AlarmScheduler?
    
    // MARK: - CRUDS
    
    // Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(alarm)
        self.scheduleUserNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    // Update
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        guard let index = alarms.index(of: alarm) else { return }
        
        alarms[index].fireDate = fireDate
        alarms[index].name = name
        alarms[index].enabled = enabled
        saveToPersistentStore()
        
    }
    
    func toggleEnabled(for alarm: Alarm) {
        // Step 3
        switch alarm.enabled {
        case true:
            alarm.enabled = false; self.cancelLocalNotification(for: alarm)
        case false:
            alarm.enabled = true; self.scheduleUserNotifications(for: alarm)
        }
        saveToPersistentStore()
    }
    
    // Delete
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    // Create file
    func fileURL() -> URL {
        // establish path to file
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // file path to app
        let documentDirectory = paths[0]
        // name of file for app
        let fileName = "alarm.json"
        // create save file for app
        let url = documentDirectory.appendingPathComponent(fileName)
        
        return url
    }
    
    // Save to file
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let alarmsAsData = try jsonEncoder.encode(AlarmController.shared.alarms)
            
            try alarmsAsData.write(to: fileURL())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Load from file
    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder ()
        
        do {
            let data = try Data(contentsOf: fileURL())
            
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: data)
            
            self.alarms = decodedAlarms
        } catch {
            print(error.localizedDescription)
        }
    }
}
