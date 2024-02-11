//
//  SwiftUIHelper.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 08/06/2022.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation
import SwiftUI

var isRunningTests: Bool {
    let environment = ProcessInfo.processInfo.environment
    return environment["TEST_MODE"] != nil
        || environment["XCTestConfigurationFilePath"] != nil
}

var isRunningSwiftUIPreview: Bool {
    #if DEBUG
        // If running SwiftUI *and* when debugging
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
    #else
        // Release builds should always return false here
        return false
    #endif
}

extension Color {
    public static var appPrimary: Color = Color("AppColor")

    // This next one is generated automatically via asset catalogs now
    // public static var appSecondary: Color = Color("AppSecondary")

    public static var debug: Color = {
        if ProcessInfo.processInfo.environment["PAINT_PHPMON_SWIFTUI_VIEWS"] != nil {
            return Color.yellow
        }
        return Color.clear
    }()
}
