// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUITray",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftUITray",
            targets: ["SwiftUITray"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", .upToNextMajor(from: .init(0, 4, 0))),
    ],
    targets: [
        .target(
            name: "SwiftUITray",
            dependencies: []),
        .testTarget(
            name: "SwiftUITrayTests",
            dependencies: ["SwiftUITray", "ViewInspector"]),
    ]
)
