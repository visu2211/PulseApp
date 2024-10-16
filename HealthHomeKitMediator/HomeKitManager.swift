import HomeKit


class HomeKitManager: NSObject, HMHomeManagerDelegate {
    private var homeManager: HMHomeManager?

    override init() {
        super.init()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        guard let home = manager.homes.first else {
            print("No primary home found.")
            return
        }
    
        
        // Accessing rooms in the home
        for room in home.rooms {
            print("Room: \(room.name)")
            
            // Accessing accessories in the room
            for accessory in room.accessories {
                print("Accessory: \(accessory.name)")
                
                // Accessing services in the accessory
                for service in accessory.services {
                    print("Service: \(service.serviceType)")
                    
                    // Accessing characteristics of the service
                    for characteristic in service.characteristics {
                        print("Characteristic: \(characteristic.characteristicType)")
                    }
                }
            }
        }
    }
}
