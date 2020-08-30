


import Moya
import Result
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
let APIProvider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

enum API {
    
    case search(city:String)

}
extension API: TargetType {
    
    public var headers: [String : String]? {
       return ["Authorization": ""]
    }
    
    var baseURL : URL { return URL(string: Constants.API.baseURL)! }
    
    var path: String {
        switch self {
            
         // weather.search
        case .search(let city):
            return "data/2.5/weather?q=\(city),uk&appid=\(Constants.API.Key)"
        }//
    }
    public var method: Moya.Method {
        switch self {
       
        case .search:
            return .get
        }
    }
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .search:
           return .requestPlain
        }
    }
    struct JsonArrayEncoding: Moya.ParameterEncoding {
        public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }
        public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var req = try urlRequest.asURLRequest()
            let json = try JSONSerialization.data(withJSONObject: parameters!["jsonArray"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
            req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            req.httpBody = json
            return req
        }
    }
}

