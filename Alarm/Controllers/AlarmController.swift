//
//  AlarmController.swift
//  Alarm
//
//  Created by RYAN GREENBURG on 1/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation

class AlarmController {
    
    // Shared instance
    static let shared = AlarmController()
    
    // Source of truth
    var alarms: [Alarm] = []
    
    // MARK: - Mock Data
    var mockAlarms: [Alarm] {
        let alarmOne = Alarm(fireDate: Date(timeIntervalSinceNow: 90), name: "Alarm One", enabled: false)
        return [alarmOne]
    }
    
    init() {
        self.alarms = mockAlarms
    }
    // Func to initialize mock data then replace with non-mock data ?????
    
    
    // MARK: - CRUDS
    
    // Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(alarm)
    }
    
    // Update
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        guard let index = alarms.index(of: alarm) else { return }
        
        alarms[index].fireDate = fireDate
        alarms[index].name = name
        alarms[index].enabled = enabled
        
    }
    
    func toggleEnabled(for alarm: Alarm) {

        switch alarm.enabled {
        case true: alarm.enabled = false
        case false: alarm.enabled = true
        }
    }
    // Delete
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
    }
}
