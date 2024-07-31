import Foundation //framework for collection
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    //completion handler as a paramter --> boolean value return
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let heartDataToRead: Set = [heartRateType]
        
        healthStore.requestAuthorization(toShare: nil, read: heartDataToRead) { (success, error) in
            completion(success, error)
        }
        
        let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
        let bodyDataToRead: Set = [bodyTemperatureType]

        healthStore.requestAuthorization(toShare: nil, read: bodyDataToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    //retrieving the data
    func readHeartBeat(completion: @escaping (Double?, String?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            if let result = results?.first as? HKQuantitySample {
                let temperature = result.quantity.doubleValue(for: HKUnit.degreeCelsius())
                completion(temperature, nil)
            } else {
                completion(nil, "No body temperature data available.")
            }
        }
        healthStore.execute(query)
    }
    
    func readBodyTemperature(completion: @escaping (Double?, String?) -> Void) {
        let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: bodyTemperatureType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            if let result = results?.first as? HKQuantitySample {
                let temperature = result.quantity.doubleValue(for: HKUnit.degreeCelsius())
                completion(temperature, nil)
            } else {
                completion(nil, "No body temperature data available.")
            }
        }
        healthStore.execute(query)
    }
}
