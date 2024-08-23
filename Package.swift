// swift-tools-version:5.10

import PackageDescription

let package = Package(
        name: "ComponentKit",
        platforms: [
            .iOS(.v13),
        ],
        products: [
            .library(
                    name: "ComponentKit",
                    targets: ["ComponentKit"]),
        ],
        dependencies: [
            .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.31.0"),
            .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
            .package(url: "https://github.com/sunimp/HUD.Swift.git", .upToNextMajor(from: "2.0.5")),
            .package(url: "https://github.com/sunimp/SectionsTableView.Swift.git", .upToNextMajor(from: "1.0.2")),
            .package(url: "https://github.com/sunimp/ThemeKit.Swift.git", .upToNextMajor(from: "2.0.9")),
            .package(url: "https://github.com/sunimp/UIExtensions.Swift.git", .upToNextMajor(from: "1.1.0")),
        ],
        targets: [
            .target(
                    name: "ComponentKit",
                    dependencies: [
                        "SkeletonView",
                        "SnapKit",
                        .product(name: "HUD", package: "HUD.Swift"),
                        .product(name: "SectionsTableView", package: "SectionsTableView.Swift"),
                        .product(name: "ThemeKit", package: "ThemeKit.Swift"),
                        .product(name: "UIExtensions", package: "UIExtensions.Swift"),
                    ]
            ),
        ]
)
