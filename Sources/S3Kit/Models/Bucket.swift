import Foundation


/// Bucket model
public struct Bucket: Codable, Sendable {
    
    /// Creating new bucket
    public struct New: Codable, Sendable {
        
        /// Name of the new bucket
        public let name: String
        
        /// New bucket initializer
        public init(name: String) {
            self.name = name
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
        }
        
    }
    
    /// Bucket location object
    public struct Location: Codable, Sendable {
        
        /// Location of the bucket
        public let region: String
        
        enum CodingKeys: String, CodingKey {
            case region = "LocationConstraint"
        }
        
    }
    
    /// Name of a bucket
    public let name: String

    /// Bucket creation date
    public let created: Date

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case created = "CreationDate"
    }
    
}
