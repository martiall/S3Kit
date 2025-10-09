// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "S3Kit",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(name: "S3Kit", targets: ["S3Kit"]),
        .library(name: "S3Signer", targets: ["S3Signer"]),
//        .library(name: "S3TestTools", targets: ["S3TestTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.58.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.19.0"),
        .package(url: "https://github.com/Einstore/HTTPMediaTypes.git", from: "0.0.1"),
        .package(url: "https://github.com/martiall/XMLCoding.git", branch: "main")
    ],
    targets: [
        .target(
            name: "S3Kit",
            dependencies: [
                "S3Signer",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                "HTTPMediaTypes",
                "XMLCoding"
            ]
        ),
        .target(
            name: "S3Provider",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "S3Kit"
            ]
        ),
        /*.executableTarget(
            name: "S3DemoRun",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "S3Provider"
            ]
        ),*/
        .target(
            name: "S3Signer",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                "HTTPMediaTypes",
            ]
        ),
//        .target(name: "S3TestTools", dependencies: [
//            "Vapor",
//            "S3Kit"
//            ]
//        ),
        .testTarget(name: "S3Tests", dependencies: [
            "S3Kit"
            ]
        )
    ]
)
