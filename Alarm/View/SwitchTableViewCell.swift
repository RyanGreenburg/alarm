//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by RYAN GREENBURG on 1/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // Step 2
    weak var delegate: SwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Step 3
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellValueChanged(self, selected: alarmSwitch.isOn)
    }
    
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
}

// Step 1
protocol SwitchTableViewCellDelegate: class {
    func switchCellValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}
