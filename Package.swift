// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DailyCheckIn",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "DailyCheckIn", targets: ["DailyCheckIn"])
    ],
    targets: [
        .target(name: "DailyCheckIn", path: "Sources/DailyCheckIn")
    ]
)
