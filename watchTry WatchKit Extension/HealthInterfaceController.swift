//
//  HealthInterfaceController.swift
//  watchTry WatchKit Extension
//
//  Created by Muhammad Tafani Rabbani on 12/10/20.
//

import WatchKit
import Foundation
import HealthKit


class HealthInterfaceController: WKInterfaceController {

    @IBOutlet weak var text: WKInterfaceLabel!
    
    private let healthStore = HKHealthStore()

    private let heartRateUnit = HKUnit(from: "count/min")
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        print("background")
        super.didDeactivate()
    }
    
    func autorizeHealthKit() {
           let healthKitTypes: Set = [
           HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

           healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
          
          
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
          
          let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
              query, samples, deletedObjects, queryAnchor, error in
              
              guard let samples = samples as? [HKQuantitySample] else {
                  return
              }
                  
              self.process(samples, type: quantityTypeIdentifier)

          }
          
          
          let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
          
          query.updateHandler = updateHandler
          
          healthStore.execute(query)
      }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
          var lastHeartRate = 0.0
          
        print("tes",samples)
          for sample in samples {
              if type == .heartRate {
                  lastHeartRate = sample.quantity.doubleValue(for: heartRateUnit)
              }
              
            self.text.setText("\(Int(lastHeartRate)) count/min")
          }
      }
}
