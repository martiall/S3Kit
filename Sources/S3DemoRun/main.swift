import Vapor
import S3Provider

let DEFAULT_BUCKET = "s3-lib-test.einstore.mgw.cz"

func routes(_ app: Application) throws {
    guard let key = Environment.get("S3_ACCESS_KEY"), let secret = Environment.get("S3_SECRET") else {
        fatalError("Missing AWS API key/secret")
    }

    let config = S3Signer.Config(accessKey: key, secretKey: secret, region: Region.euCentral1)
    let s3: S3Client = try S3(defaultBucket: DEFAULT_BUCKET, config: config)

    app.get("buckets") { req -> EventLoopFuture<BucketsInfo> in
        s3.buckets(on: req.eventLoop)
    }

    app.put("bucket") { req -> EventLoopFuture<String> in
        s3.create(bucket: "api-created-bucket", region: .euCentral1, on: req.eventLoop).map { ":)" }
            .recover { error in
                if let error = error.s3ErrorMessage() { return error.message }
                return ":("
            }
    }

    app.delete("bucket") { req -> EventLoopFuture<String> in
        s3.delete(bucket: "api-created-bucket", region: .euCentral1, on: req.eventLoop).map { ":)" }
            .recover { error in
                if let error = error.s3ErrorMessage() { return error.message }
                return ":("
            }
    }

    app.get("files") { req -> EventLoopFuture<BucketResults> in
        s3.list(bucket: DEFAULT_BUCKET, region: .euCentral1, headers: [:], on: req.eventLoop)
            .flatMapErrorThrowing { error in
                if let error = error.s3ErrorMessage() { print(error.message) }
                throw error
            }
    }

    app.get("bucket", "location") { req -> EventLoopFuture<String> in
        s3.location(bucket: DEFAULT_BUCKET, on: req.eventLoop)
            .map { $0.hostUrlString() }
            .recover { error -> String in
                if let error = error as? S3.Error {
                    switch error {
                    case .errorResponse(_, let e):
                        return e.message
                    default:
                        return "S3 :("
                    }
                }
                return ":("
            }
    }

    app.get("files", "test") { req -> EventLoopFuture<String> in
        let string = "Content of my example file"
        let fileName = "file-hu.txt"
        return s3.put(string: string, destination: fileName, access: .publicRead, on: req.eventLoop)
            .flatMap { _ in s3.get(file: fileName, on: req.eventLoop) }
            .flatMap { getResponse in
                print(String(data: getResponse.data, encoding: .utf8) ?? "Unknown content!")
                return s3.get(fileInfo: fileName, on: req.eventLoop).flatMap { infoResponse in
                    s3.delete(file: fileName, on: req.eventLoop).flatMapThrowing { _ in
                        let json = try JSONEncoder().encode(infoResponse)
                        return String(data: json, encoding: .utf8) ?? "Unknown content!"
                    }
                }
            }
            .recover { error -> String in
                if let error = error.s3ErrorMessage() { return error.message }
                return ":("
            }
    }
}

@main
struct S3DemoRun {
    static func main() throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        try routes(app)
        try app.run()
    }
}
