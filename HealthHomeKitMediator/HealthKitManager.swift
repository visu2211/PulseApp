import Foundation

import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    // Request authorization to access HealthKit data

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
        let healthDataToRead: Set = [heartRateType, bodyTemperatureType]

        healthStore.requestAuthorization(toShare: nil, read: healthDataToRead) { (success, error) in
            completion(success, error)
        }
    }

    // Fetch heart rate data
    func fetchHeartRate(completion: @escaping (Double?, Error?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: nil) { (_, results, error) in
            if let result = results?.first as? HKQuantitySample {
                let heartRate = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
                completion(heartRate, nil)
            } else {
                completion(nil, error)
            }
        }
        healthStore.execute(query)
    }

    // Fetch body temperature data
    func fetchBodyTemperature(completion: @escaping (Double?, Error?) -> Void) {
        let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
        let query = HKSampleQuery(sampleType: bodyTemperatureType, predicate: nil, limit: 1, sortDescriptors: nil) { (_, results, error) in

            if let result = results?.first as? HKQuantitySample {
                let temperature = result.quantity.doubleValue(for: HKUnit.degreeCelsius())
                completion(temperature, nil)
            } else {

                completion(nil, error)

            }
        }
        healthStore.execute(query)
    }
}
