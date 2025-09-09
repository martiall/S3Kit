import Foundation
import Crypto

extension Data {
    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
}

extension SHA256.Digest {
    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
}

