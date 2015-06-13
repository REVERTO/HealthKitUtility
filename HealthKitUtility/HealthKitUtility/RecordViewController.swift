//
//  RecordViewController.swift
//  HealthKitUtility
//
//  Created by Tomoyuki Ito on 5/29/15.
//  Copyright (c) 2015 REVERTO. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var record: ScanData!
    var index = 0
    var objectId = 0
    let items = ["date","weight","fat","bmi","lbm","page","objeciId"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func reload() {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if record != nil {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.textColor = UIColor.redColor()
        cell.detailTextLabel?.textColor = UIColor.redColor()
//        cell.backgroundColor = UIColor.blueColor()
        
        let key = items[indexPath.row]
        cell.textLabel?.text = key
        
        switch(indexPath.row) {
        case 0:
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.detailTextLabel?.text = formatter.stringFromDate(record.date)
            break
        case 1:
            cell.detailTextLabel?.text = record.weight as String
            break
        case 2:
            cell.detailTextLabel?.text = record.fat as String
            break
        case 3:
            cell.detailTextLabel?.text = record.bmi as String
            break
        case 4:
            cell.detailTextLabel?.text = record.lbm as String
            break
        case 5:
            cell.detailTextLabel?.text = index.description
            break
        case 6:
            cell.detailTextLabel?.text = objectId.description
            break
        default:
            cell.detailTextLabel?.text = ""
            break
        }
        
        return cell
    }
}
