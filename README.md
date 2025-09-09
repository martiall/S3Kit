# S3Kit (Swift/Vapor 4)

Lightweight S3 client and signer for Swift (works great with Vapor 4).

## Requirements

- Swift 5.9+
- macOS 12+

## What’s Included

- Signing headers (AWS SigV2 + SigV4)
- Bucket listing, creation, deletion, and region discovery
- Object list, upload (file/string), get, head (info), copy, move, delete
- Error parsing to a simple internal `ErrorMessage` model

## SwiftPM

```swift
dependencies: [
    .package(url: "https://github.com/LiveUI/S3.git", from: "4.0.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "S3Kit", package: "S3")
    ])
]
```

## Quick Start

```swift
import S3Kit

let config = S3Signer.Config(
    accessKey: "AKIA...",
    secretKey: "...",
    region: .euCentral1
)
let s3 = try S3(defaultBucket: "my-bucket", config: config)

// Upload string
_ = s3.put(string: "hello", destination: "hello.txt", on: req.eventLoop)

// Fetch file
_ = s3.get(file: "hello.txt", on: req.eventLoop)

// Delete
_ = s3.delete(file: "hello.txt", on: req.eventLoop)
```

To use a custom MinIO endpoint:

```swift
let config = S3Signer.Config(
    accessKey: "...",
    secretKey: "...",
    region: Region(name: .usEast1, hostName: "127.0.0.1:9000", useTLS: false)
)
```

## Public Surface (selected)

- S3Kit – Extensions
  - S3+ObjectInfo.swift
    - get(acl file:headers:on:)
    - get(fileInfo:headers:on:)
    - get(fileInfo:on:)
  - S3+Get.swift
    - url(fileInfo:)
    - get(file:headers:on:)
    - get(file:on:)
  - S3+Put.swift
    - put(file:headers:on:)
    - put(file:on:)
    - put(file url:destination:access:on:)
    - put(file path:destination:access:on:)
    - put(file url:destination:bucket:access:on:)
    - put(file path:destination:bucket:access:on:)
  - Region+Tools.swift
    - urlString(bucket:)
    - url(bucket:)
  - S3+Strings.swift
    - put(string:mime:destination:bucket:access:on:)
    - put(string:mime:destination:access:on:)
    - put(string:destination:access:on:)
    - put(string:mime:destination:on:)
    - put(string:destination:on:)
  - S3+Move.swift
    - move(file:to:headers:on:)
  - Error+S3.swift
    - s3Error(), s3ErrorMessage(), s3ErrorCode()
  - S3+Service.swift
    - buckets(on:)
  - S3+Delete.swift
    - delete(file:headers:on:), delete(file:on:)
  - S3+Bucket.swift
    - location(bucket:on:), delete(bucket:region:on:), create(bucket:region:on:)
  - S3+List.swift
    - list(bucket:region:headers:on:), list(bucket:region:on:)
  - S3+Copy.swift
    - copy(file:to:headers:on:)

- S3Kit – Protocols
  - `S3Client` protocol and extension (same method set as above)

- S3Kit – URL Builders
  - URLBuilder.swift, S3URLBuilder.swift

- S3Kit – Models
  - Bucket.New, BucketsInfo, File.Upload/Location/Response/Info, Object, Owner

## Notes on Errors

- Custom external error frameworks were removed. Errors now use internal enums and simple `ErrorMessage` decoding for S3 responses. Helper methods on `Error` (`s3Error*`) are preserved for convenience.

## Demo

A small Vapor 4 demo exists under `Sources/S3DemoRun`.

Run locally:

```
export S3_ACCESS_KEY=yourKey
export S3_SECRET=yourSecret
swift run S3DemoRun
```

## Build & Test

```
swift build
swift test
```

## License

See the LICENSE file for more info.
