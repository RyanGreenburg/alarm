//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by RYAN GREENBURG on 1/28/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        AlarmController.shared.loadFromPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AlarmController.shared.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell()}

        let alarm = AlarmController.shared.alarms[indexPath.row]
        
        cell.alarm = alarm
        // Step 5
        cell.delegate = self
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as? AlarmDetailTableViewController
                let alarmToSend = AlarmController.shared.alarms[indexPath.row]
                destinationVC?.alarm = alarmToSend
            }
        }
    }
}

// Step 4
extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm, let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        AlarmController.shared.toggleEnabled(for: alarm)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
