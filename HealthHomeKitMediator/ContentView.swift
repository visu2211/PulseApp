import SwiftUI

struct ContentView: View {
    @State private var temperature: Double?
    @State private var errorMessage: String?
    @State private var newHomeName: String = ""
    let healthKitManager = HealthKitManager()
    let homeKitManager = HomeKitManager()

    var body: some View {
        VStack {
            Text("Health Data Monitor")
                .font(.largeTitle)
                .padding()
            if let temperature = temperature {
                Text("Body Temperature: \(temperature, specifier: "%.2f")°C")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .padding()
                    .foregroundColor(.red)
            } else {
                Text("Fetching temperature...")
                    .padding()
            }
            Button(action: fetchTemperature) {
                Text("Refresh")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
                Text("Hello")
                    .padding()
                    .background(Color.red)
        }
        .onAppear(perform: requestAuthorization)
    }

    func requestAuthorization() {
        healthKitManager.requestAuthorization { success, error in
            if success {
                fetchTemperature()
            } else {
                errorMessage = "HealthKit authorization failed: \(String(describing: error?.localizedDescription))"
            }
        }
    }

    func fetchTemperature() {
        healthKitManager.readBodyTemperature { temperature, error in
            if let temperature = temperature {
                self.temperature = temperature
                self.errorMessage = nil
            } else {
                self.temperature = nil
                self.errorMessage = error
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
