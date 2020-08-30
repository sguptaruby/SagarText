


import Foundation
import Alamofire

struct Helpers {
    
    static func userToken() -> String {
        guard let token = UserDefaults.standard.value(forKey: "Authorization") else {
            return ""
        }
        return token as! String
    }
    
    static func saveUserToken(token:String){
        UserDefaults.standard.set(token, forKey: "Authorization")
        UserDefaults.standard.synchronize()
    }
    
    
    static func getDeviceToken() -> String {
        return UserDefaults.standard.value(forKey: "devicetoken") as? String ?? ""
    }
    
    static func removeUserToken() {
        UserDefaults.standard.removeObject(forKey: "Authorization")
    }
    
    static func validateResponse(_ statusCode: Int) -> Bool {
        if case 200...300 = statusCode {
            return true
        }
        return false
    }
}

