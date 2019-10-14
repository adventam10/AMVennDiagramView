// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  AMVennDiagramView, https://github.com/adventam10/AMVennDiagramView
//
//  Created by am10 on 2019/10/14.
//  Copyright © 2019年 am10. All rights reserved.
//

import PackageDescription

let package = Package(name: "AMVennDiagramView",
                      platforms: [.iOS(.v9)],
                      products: [.library(name: "AMVennDiagramView",
                                          targets: ["AMVennDiagramView"])],
                      targets: [.target(name: "AMVennDiagramView",
                                        path: "Source")],
                      swiftLanguageVersions: [.v5])
