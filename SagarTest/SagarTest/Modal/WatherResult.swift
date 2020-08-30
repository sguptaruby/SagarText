




import Foundation

struct WatherResult: Decodable {
    let main: Wather
    
}

extension WatherResult {
    static func empty() -> WatherResult {
        return WatherResult(main: Wather(temp: 0.0, humidity: 0.0))
    }
}

struct Wather: Decodable {
    let temp:Double
    let humidity:Double
}
