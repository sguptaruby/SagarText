

import Foundation
struct APIError: Swift.Error {
    let code: String
    let desc: String
    
    static func failure(_ text: String) -> APIError {
        return APIError.init(code: "", desc: text)
    }
    static func noConnectivity() -> APIError {
        return APIError.init(code: "", desc: "Please check your internet connection.")
    }
    static func unknownError() -> APIError {
        return APIError.init(code: "1000", desc: "Unknown Error")
    }
}
extension APIError {
    init(_ json: JSONDictionary) {
        self.code = json["code"] as? String ?? ""
        self.desc = json["error"] as? String ?? json["message"] as? String ?? ""
    }
}
