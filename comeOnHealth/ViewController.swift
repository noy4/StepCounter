//
//  ViewController.swift
//  comeOnHealth
//
//  Created by 桑村直弥 on 2019/12/04.
//  Copyright © 2019年 noy4. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var totalSteps: UILabel!

    let healthStore = HKHealthStore()
    var guest = false
    var bias = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(self)
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    func getTotalSteps() {
        getTodaysSteps { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                self.totalSteps.text = "\(Int(result))"
            }
        }
    }

    
    func startObserving(_ sender: Any) {
        
        let sampleType =
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let query = HKObserverQuery(sampleType: sampleType!, predicate: nil) {
            query, completionHandler, error in
            
            if error != nil {
                
                // Perform error handling.
                print("*** An error occured while setting up the stepCount observer. \(error?.localizedDescription) ***")
                abort()
            }
            
            print("steps detected")
            self.getTotalSteps()
        }
        
        healthStore.execute(query)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: false)
    }
}

