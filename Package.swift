// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Badgeable",
    platforms: [

        .iOS(.v11),
    ],
    products: [
        .library(
            name: "Badgeable",
            targets: ["Badgeable"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Badgeable",
            dependencies: []),
    ]
)
