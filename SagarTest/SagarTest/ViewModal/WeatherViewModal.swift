


import Foundation
import CoreData

class WeatherViewModal {
    
    var searchCity = ""
    var predicate: NSPredicate?
    
    func weather(_ completion: @escaping ((Bool,WatherResult?,APIError?) -> ())) {
        APIController.makeRequestReturnJSON(.search(city:searchCity)) { (data,statuscode,error) in
            if data != nil {
                APIController.validateJason("\(statuscode)", completion: { (bool) in
                    guard let data1 =  try? JSONSerialization.data(withJSONObject: data ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted) else {
                        completion(bool, WatherResult.empty(), error)
                        return
                    }
                    if bool {
                        if let weather = try? JSONDecoder().decode(WatherResult.self, from: data1) {
                            completion(bool, weather, error)
                            self.save(name: self.searchCity.uppercased(), temp: weather.main.temp, humidity: weather.main.humidity)
                        }else{
                            completion(bool, WatherResult.empty(), error)
                        }
                    }else{
                        completion(bool, WatherResult.empty(), error)
                    }
                })
            }else{
                completion(false,WatherResult.empty(), error)
            }
        }
    }
    
    func save(name: String,temp: Double,humidity: Double) {
        
        let managedContext =
            AppDelegate.appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "City",
                                       in: managedContext)!
        
        let city = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        city.setValue(name, forKey: "name")
        city.setValue(temp, forKey: "temp")
        city.setValue(humidity, forKey: "humidity")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func checkCity(city:String) -> (exists:Bool,weather:Wather) {
        let filter = city
        predicate = NSPredicate(format: "name == %@", filter)
        let managedContext =
            AppDelegate.appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "City")
        fetchRequest.predicate = predicate
        do {
            let city = try managedContext.fetch(fetchRequest)
            if let aContact = city.first {
                //print(aContact.value(forKey: "name"))
                let temp = aContact.value(forKey: "temp") as? Double ?? 0.0
                let humidity = aContact.value(forKey: "humidity") as? Double ?? 0.0
                return(true,Wather(temp: temp, humidity: humidity))
            }else{
                return(false,Wather(temp: 0.0, humidity: 0.0))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return(false,Wather(temp: 0.0, humidity: 0.0))
        }
    }
    
    func removeObjects() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "City")
        fetchRequest.returnsObjectsAsFaults = false
        let managedContext =
        AppDelegate.appDelegate.persistentContainer.viewContext

        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in City error :", error)
        }
    }
    
}
