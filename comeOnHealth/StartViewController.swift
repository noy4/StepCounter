//
//  StartViewController.swift
//  comeOnHealth
//
//  Created by 桑村直弥 on 2019/12/04.
//  Copyright © 2019年 noy4. All rights reserved.
//

import UIKit
import HealthKit

class StartViewController: UIViewController {

    @IBOutlet weak var guestSwitch: UISwitch!
    
    let healthStore = HKHealthStore()
    var guest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guest = guestSwitch.isOn
        authoriseHealthKitAccess()
    }
    
    func authoriseHealthKitAccess() {
        let healthKitTypes: Set = [
            // access step count
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (_, _) in
            print("authrised???")
        }
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if let e = error {
                print("oops something went wrong during authorisation \(e.localizedDescription)")
            } else {
                print("User has completed the authorization flow")
            }
        }
    }

    @IBAction func switchTapped(_ sender: UISwitch) {
        guest = sender.isOn
        print("tapped switch")
    }
    
}
