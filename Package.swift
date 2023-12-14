// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProgressivePageControl",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "ProgressivePageControl",
            targets: ["ProgressivePageControl"]),
    ],
    targets: [
        .target(
            name: "ProgressivePageControl",
            linkerSettings: [.linkedFramework("UIKit")]),
        .testTarget(
            name: "ProgressivePageControlTests",
            dependencies: ["ProgressivePageControl"],
            linkerSettings: [.linkedFramework("UIKit")]),
    ]
)
