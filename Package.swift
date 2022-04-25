// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppConfig",
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
