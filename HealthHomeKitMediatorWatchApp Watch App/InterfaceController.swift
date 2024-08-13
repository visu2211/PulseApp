//
//  InterfaceController.swift
//  HealthHomeKitMediator
//
//  Created by Vishal Kanala on 8/10/24.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var session: WCSession?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupWatchConnectivity()
        sendDataToPhone()
    }

    // MARK: - WatchConnectivity Setup
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func sendDataToPhone() {
        if let session = session, session.isReachable {
            // Simulate data or fetch it using HealthKit on the Watch
            let heartRate = 75.0  // Example value
            let temperature = 36.5  // Example value

            let message = ["heartRate": heartRate, "temperature": temperature]
            session.sendMessage(message, replyHandler: nil, errorHandler: { (error) in
                print("Error sending message: \(error.localizedDescription)")
            })
        }
    }

    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle receiving messages from iPhone if necessary
    }
}
