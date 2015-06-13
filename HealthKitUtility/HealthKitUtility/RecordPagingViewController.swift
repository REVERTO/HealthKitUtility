//
//  RecordPagingViewController.swift
//  HealthKitUtility
//
//  Created by Tomoyuki Ito on 5/29/15.
//  Copyright (c) 2015 REVERTO. All rights reserved.
//

import UIKit
import Alamofire
import HealthKit

enum ScanType: String {
    case Weight = "6021"
    case Fat = "6022"
    case BMI = "6023"
}

class RecordPagingViewController: UIViewController, DMLazyScrollViewDelegate {

    let hpClientId = "107.TJt0ARNfBP.apps.healthplanet.jp"
    let hpClientSecret = "1432874934332-caxs3xhIVUxBc52kLdbtRTfzO85Mqv9xD6rLMej5"
    
    let udkeyAuthCode = "auth_code"
    let udkeyAccessToken = "access_token"
    let udkeyExpireIn = "expires_in"
    let udkeyRefreshToken = "refresh_token"
    
    @IBOutlet var pagingView: DMLazyScrollView!
    var records: NSArray!
    var viewControllers: NSArray!
    var presentRecordIndex = 0
    var presentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs = [RecordViewController]()
        for loop in 0...2 {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
            vc.index = loop
            vcs.append(vc)
        }
        viewControllers = vcs
        
//        pagingView = DMLazyScrollView(frame: self.view.bounds)
        pagingView.autoresizingMask = UIViewAutoresizing.None
        pagingView.setEnableCircularScroll(true)
        pagingView.dataSource = { (index: UInt) -> UIViewController! in
            let num = Int(bitPattern: index)
            let vc = self.viewControllers[num] as! RecordViewController
            vc.objectId = num
            return vc
        }
        pagingView.controlDelegate = self
        pagingView.numberOfPages = 3
        self.view.addSubview(pagingView)
    }
    
    // MARK: DMLazyScrollViewDelegate
    
    func lazyScrollView(pagingView: DMLazyScrollView!, currentPageChanged currentPageIndex: Int) {
        if records != nil {
            let backvc:RecordViewController,nowvc:RecordViewController,nextvc:RecordViewController
            switch (currentPageIndex) {
            case 0:
                backvc = self.viewControllers[2] as! RecordViewController
                nowvc = self.viewControllers[0] as! RecordViewController
                nextvc = self.viewControllers[1] as! RecordViewController
                break
            case 1:
                backvc = self.viewControllers[0] as! RecordViewController
                nowvc = self.viewControllers[1] as! RecordViewController
                nextvc = self.viewControllers[2] as! RecordViewController
                break
            case 2:
                backvc = self.viewControllers[1] as! RecordViewController
                nowvc = self.viewControllers[2] as! RecordViewController
                nextvc = self.viewControllers[0] as! RecordViewController
                break
            default:
                return
            }
            
            backvc.index = nowvc.index-1
            if backvc.index >= 0 && backvc.index < records.count {
                backvc.record = records[backvc.index] as! ScanData
            } else {
                backvc.record = nil
            }
            nextvc.index = nowvc.index+1
            if nextvc.index >= 0 && nextvc.index < records.count {
                nextvc.record = records[nextvc.index] as! ScanData
            } else {
                nextvc.record = nil
            }
            backvc.reload()
            nextvc.reload()
        }
    }
    
    func reloadEachPages() {
        if records != nil {
            let backvc:RecordViewController,nowvc:RecordViewController,nextvc:RecordViewController
            switch (pagingView.currentPage) {
            case 0:
                backvc = self.viewControllers[2] as! RecordViewController
                nowvc = self.viewControllers[0] as! RecordViewController
                nextvc = self.viewControllers[1] as! RecordViewController
                break
            case 1:
                backvc = self.viewControllers[0] as! RecordViewController
                nowvc = self.viewControllers[1] as! RecordViewController
                nextvc = self.viewControllers[2] as! RecordViewController
                break
            case 2:
                backvc = self.viewControllers[1] as! RecordViewController
                nowvc = self.viewControllers[2] as! RecordViewController
                nextvc = self.viewControllers[0] as! RecordViewController
                break
            default:
                return
            }
            
            backvc.index = nowvc.index-1
            if backvc.index >= 0 && backvc.index < records.count {
                backvc.record = records[backvc.index] as! ScanData
            } else {
                backvc.record = nil
            }
            if nowvc.index >= 0 && nowvc.index < records.count {
                nowvc.record = records[nowvc.index] as! ScanData
            } else {
                nowvc.record = nil
            }
            nextvc.index = nowvc.index+1
            if nextvc.index >= 0 && nextvc.index < records.count {
                nextvc.record = records[nextvc.index] as! ScanData
            } else {
                nextvc.record = nil
            }
            backvc.reload()
            nowvc.reload()
            nextvc.reload()
        }
    }
    
    func lazyScrollViewWillBeginDragging(pagingView: DMLazyScrollView!) {
        
    }
    
    func lazyScrollViewDidEndDragging(pagingView: DMLazyScrollView!) {
        
    }
    
    // MARK: Action
    
    @IBAction func syncButtonTouched(button: UIButton) {
//        let authCode = NSUserDefaults.standardUserDefaults().stringForKey(udkeyAuthCode)
//        if authCode != nil {
//        } else {
//            let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(udkeyAccessToken)
//            if accessToken != nil {
//            }
//        }
        
//        https://www.healthplanet.jp/status/innerscan.json?access_token=1432875605792/5AZuQ7k16oLWBbIPI3AsiZNkEk7zvdm6tdb28JaW&tag=6021&date=1&from=20150527000000&to=20150528000000
        Alamofire.request(.GET, "https://www.healthplanet.jp/status/innerscan.json", parameters:
//            ["access_token":"1432875605792/5AZuQ7k16oLWBbIPI3AsiZNkEk7zvdm6tdb28JaW","tag":"6021,6022,6023,6024,6025,6026,6027,6028,6029","date":"0","from":"20150101000000","to":"20150601000000"]
            ["access_token":"1432875605792/5AZuQ7k16oLWBbIPI3AsiZNkEk7zvdm6tdb28JaW","tag":"6021,6022,6027","date":1,"from":"20150527000000","to":"20150620000000"]
            ).responseJSON { (_, _, JSON, _) in
                println(JSON)
                let jsonDict = JSON as! NSDictionary
                var tempDict = NSMutableDictionary()
                for data: NSDictionary in jsonDict["data"] as! [NSDictionary] {
                    let dateString = data["date"] as! String
                    var scanData = tempDict[dateString] as! ScanData!
                    if scanData == nil {
                        scanData = ScanData()
                        
                        let format = NSDateFormatter()
//                        format.locale = NSLocale(localeIdentifier: "ja_JP")
                        format.dateFormat = "yyyyMMddHHmm"
                        scanData.date = format.dateFromString(dateString)
                        tempDict[data["date"] as! String] = scanData
                    }
                    
                    var tag = data["tag"] as! String!
                    var keydata = data["keydata"] as! String
                    
                    
                    if tag == "6021" {scanData.weight = keydata}
                    else if tag == "6022" {scanData.fat = keydata}
                    else if tag == "6027" {scanData.restingCalory = keydata}
                }
                
                var array = tempDict.allValues
                array.sort({ (item1, item2) -> Bool in
                    let date1 = item1.date as NSDate
                    let date2 = item2.date as NSDate
                    return date1.compare(date2) == NSComparisonResult.OrderedAscending
                })
//                array.sort({ (item1:NSDictionary, item2:NSDictionary) -> Bool in
//                    let date1 = item1["lastModified"] as NSDate
//                    let date2 = item2["lastModified"] as NSDate
//                    return date1.compare(date2) == NSComparisonResult.OrderedDescending
//                })
                self.records = array
//                self.pagingView.reloadData()
                self.reloadEachPages()
        }
    }

    @IBAction func saveButtonTouched(button: UIButton) {
        
        for scandata in records as! [ScanData] {
//            // 体重の保存
//            if scandata.weight != nil {
//                let type: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
//                saveHealthValueWithUnit(HKUnit(fromString: "kg"), type: type, valueStr: scandata.weight, date: scandata.date, completion: {
//                    success, error in
//                    
//                    if error != nil {
//                        NSLog(error.description)
//                    } else if success {
//                        NSLog("体重データの永続化に成功しました。")
//                    }
//                })
//            }
//            // 体脂肪率の保存
//            if scandata.fat != nil {
//                var fat = String(format:"%e",scandata.fat.floatValue/100)
//                let type: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyFatPercentage)
//                saveHealthValueWithUnit(HKUnit(fromString: "%"), type: type, valueStr: fat, date: scandata.date, completion: {
//                    success, error in
//                    
//                    if error != nil {
//                        NSLog(error.description)
//                    } else if success {
//                        NSLog("体脂肪率データの永続化に成功しました。")
//                    }
//                })
//            }
//            // BMIの保存
//            if scandata.bmi != 0 {
//                let type: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
//                saveHealthValueWithUnit(HKUnit.countUnit(), type: type, valueStr: scandata.bmi, date: scandata.date, completion: {
//                    success, error in
//                    
//                    if error != nil {
//                        NSLog(error.description)
//                    } else if success {
//                        NSLog("BMIデータの永続化に成功しました。")
//                    }
//                })
//            }
//            // 除脂肪体重の保存
//            if scandata.lbm != 0 {
//                let type: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierLeanBodyMass)
//                saveHealthValueWithUnit(HKUnit(fromString: "kg"), type: type, valueStr: scandata.lbm, date: scandata.date, completion: {
//                    success, error in
//                    
//                    if error != nil {
//                        NSLog(error.description)
//                    } else if success {
//                        NSLog("LBMデータの永続化に成功しました。")
//                    }
//                })
//            }
            // 基礎代謝量の保存
            if scandata.restingCalory != 0 {
                let type: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBasalEnergyBurned)
                saveHealthValueWithUnit(HKUnit(fromString: "kcal"), type: type, valueStr: scandata.restingCalory, date: scandata.date, completion: {
                    success, error in
                    
                    if error != nil {
                        NSLog(error.description)
                    } else if success {
                        NSLog("LBMデータの永続化に成功しました。")
                    }
                })
            }
        }
    }
    
    func saveHealthValueWithUnit(unit: HKUnit! , type: HKQuantityType!, valueStr: NSString!, date: NSDate!, completion: ((success: Bool, error: NSError!) -> Void)) {
        let healthStore: HKHealthStore = HKHealthStore()
        let quantity: HKQuantity = HKQuantity(unit: unit, doubleValue: valueStr.doubleValue)
        let saveDate = date != nil ? date : NSDate()
        let sample: HKQuantitySample = HKQuantitySample(type: type, quantity: quantity, startDate: saveDate, endDate: saveDate)
        let types: NSSet = NSSet(object: type)
        let authStatus:HKAuthorizationStatus = healthStore.authorizationStatusForType(type)
        
        if authStatus == .SharingAuthorized {
            healthStore.saveObject(sample, withCompletion:completion)
        } else {
            healthStore.requestAuthorizationToShareTypes(types as Set<NSObject>, readTypes: types as Set<NSObject>) {
                success, error in
                
                if error != nil {
                    NSLog(error.description);
                    return
                }
                
                if success {
                    NSLog("保存可能");
                    healthStore.saveObject(sample, withCompletion:completion)
                }
            }
        }
    }
}
