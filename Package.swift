// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppConfig",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "AppConfig",
            targets: ["AppConfig"]),
    ],
    targets: [
        .target(
            name: "AppConfig",
            dependencies: []),
        .testTarget(
            name: "AppConfigTests",
            dependencies: ["AppConfig"])
    ]
)
