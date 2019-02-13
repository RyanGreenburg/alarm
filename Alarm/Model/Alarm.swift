//
//  Alarm.swift
//  Alarm
//
//  Created by RYAN GREENBURG on 1/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let newString = dateFormatter.string(from: fireDate)
        return newString
    }

    init(fireDate: Date, name: String, enabled: Bool, uuid: String = UUID().uuidString) {
            self.fireDate = fireDate
            self.name = name
            self.enabled = enabled
            self.uuid = uuid
    }
}


extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate && lhs.name == rhs.name && lhs.enabled == rhs.enabled
    }
}
