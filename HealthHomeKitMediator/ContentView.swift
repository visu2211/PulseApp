import SwiftUI
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    var session: WCSession?

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session inactivity
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle receiving data from Watch
        NotificationCenter.default.post(name: Notification.Name("didReceiveMessage"), object: message)
    }
}

struct ContentView: View {
    @State private var temperature: Double?
    @State private var heartRate: Double?
    @State private var errorMessage: String?
    let healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            Text("Health Data Monitor")
                .font(.largeTitle)
                .padding()
            if let temperature = temperature {
                Text("Body Temperature: \(temperature, specifier: "%.2f")°C")
                    .padding()
            }
            if let heartRate = heartRate {
                Text("Heart Rate: \(heartRate, specifier: "%.2f") BPM")
                    .padding()
            }
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .padding()
                    .foregroundColor(.red)
            } else {
                Text("Fetching health data...")
                    .padding()
            }
            Button(action: fetchHealthData) {
                Text("Refresh")
                    .padding()
            }
        }
        .onAppear {
            fetchHealthData()
            WatchConnectivityManager.shared // Initialize the manager
            setupNotificationObserver()
        }
    }

    func fetchHealthData() {
        healthKitManager.fetchBodyTemperature { (temperature, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch temperature: \(error.localizedDescription)"
            } else {
                self.temperature = temperature
            }
        }

        healthKitManager.fetchHeartRate { (heartRate, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch heart rate: \(error.localizedDescription)"
            } else {
                self.heartRate = heartRate
            }
        }
    }

    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name("didReceiveMessage"), object: nil, queue: .main) { notification in
            if let message = notification.object as? [String: Any] {
                if let watchHeartRate = message["heartRate"] as? Double {
                    self.heartRate = watchHeartRate
                }
                if let watchTemperature = message["temperature"] as? Double {
                    self.temperature = watchTemperature
                }
            }
        }
    }
}

//WatchConectivityManager --> handles all the WC tasks and follows with the delegation


