//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by RYAN GREENBURG on 1/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool {
        guard let alarmStatus = alarm?.enabled else { return true }
        return alarmStatus
    }
    
    @IBOutlet weak var datePickerWheel: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmToggleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        
        alarmNameTextField.text = alarm.name
        datePickerWheel.date = alarm.fireDate
        setUpButton()
       
    }
    
    func setUpButton() {
        if alarmIsOn {
            alarmToggleButton.setTitle("On", for: .normal)
        } else {
            alarmToggleButton.setTitle("Off", for: .normal)
        }
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
       setUpButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = alarmNameTextField.text else { return }
        let date = datePickerWheel.date
        let enabled = alarmIsOn
        
        if let alarm = alarm {
            AlarmController.shared.updateAlarm(alarm: alarm, fireDate: date, name: name, enabled: enabled)
        } else {
            AlarmController.shared.addAlarm(fireDate: date, name: name, enabled: enabled)
        }
    }
}
