// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "remind",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "remind",
            targets: ["remind"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .exact("0.0.6")),
    ],
    targets: [
        .target(
            name: "remind",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")],
            path: "remind/"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

