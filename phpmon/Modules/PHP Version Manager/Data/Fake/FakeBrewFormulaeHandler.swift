//
//  FakeBrewFormulaeHandler.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 27/05/2023.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation

class FakeBrewFormulaeHandler: HandlesBrewPhpFormulae {
    // swiftlint:disable function_body_length
    public func loadPhpVersions(loadOutdated: Bool) async -> [BrewPhpFormula] {
        return [
            BrewPhpFormula(
                name: "php@9.9",
                displayName: "PHP 9.9",
                installedVersion: nil,
                upgradeVersion: "9.9.0",
                prerelease: true
            ),
            BrewPhpFormula(
                name: "php@8.4",
                displayName: "PHP 8.4",
                installedVersion: nil,
                upgradeVersion: "8.4.0",
                prerelease: true
            ),
            BrewPhpFormula(
                name: "php",
                displayName: "PHP 8.3",
                installedVersion: nil,
                upgradeVersion: "8.3.0",
                prerelease: true
            ),
            BrewPhpFormula(
                name: "php@8.2",
                displayName: "PHP 8.2",
                installedVersion: "8.2.3",
                upgradeVersion: "8.2.4"
            ),
            BrewPhpFormula(
                name: "php@8.1",
                displayName: "PHP 8.1",
                installedVersion: "8.1.17",
                upgradeVersion: nil
            ),
            BrewPhpFormula(
                name: "php@8.0",
                displayName: "PHP 8.0",
                installedVersion: nil,
                upgradeVersion: nil
            ),
            BrewPhpFormula(
                name: "php@7.4",
                displayName: "PHP 7.4",
                installedVersion: nil,
                upgradeVersion: nil
            ),
            BrewPhpFormula(
                name: "php@7.3",
                displayName: "PHP 7.3",
                installedVersion: nil,
                upgradeVersion: nil
            ),
            BrewPhpFormula(
                name: "php@7.2",
                displayName: "PHP 7.2",
                installedVersion: nil,
                upgradeVersion: nil
            ),
            BrewPhpFormula(
                name: "php@7.1",
                displayName: "PHP 7.1",
                installedVersion: nil,
                upgradeVersion: nil
            )
        ]
    }
}
