import Foundation

struct Map: Hashable, Codable, Identifiable {
    var id: Int
    var building: String
    var floor: String
    var filename: String
}

