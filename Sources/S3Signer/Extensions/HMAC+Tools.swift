import Crypto


extension HMAC {
    
    static func signatureData(_ stringToSign: String, key: [UInt8]) -> Data {
        let mac = HMAC<H>.authenticationCode(
            for: Array(stringToSign.utf8),
            using: SymmetricKey(data: key)
        )
        return Data(mac)
    }
    
    static func signatureData(_ stringToSign: String, key: Data) -> Data {
        let mac = HMAC<H>.authenticationCode(
            for: Array(stringToSign.utf8),
            using: SymmetricKey(data: key)
        )
        return Data(mac)
    }
    
}
