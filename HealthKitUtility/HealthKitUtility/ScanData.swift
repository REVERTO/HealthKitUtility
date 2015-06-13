//
//  ScanData.swift
//  HealthKitUtility
//
//  Created by Tomoyuki Ito on 5/30/15.
//  Copyright (c) 2015 REVERTO. All rights reserved.
//

class ScanData: NSObject {

    var date: NSDate!
    var weight: NSString!
    var fat: NSString!
    var restingCalory: NSString!
    var bmi: NSString {
        get {
            let profile = Profile()
            let val = weight.doubleValue/(profile.height*profile.height)*10000
            return NSString(format: "%.2f", val)
        }
        set {
        }
    }
    var lbm: NSString {
        get {
            let profile = Profile()
            let val = weight.doubleValue*(1-(fat.doubleValue/100))
            return NSString(format: "%.2f", val)
        }
        set {
        }
    }
}
