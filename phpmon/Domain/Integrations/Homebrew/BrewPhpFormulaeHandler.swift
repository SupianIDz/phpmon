//
//  BrewFormulaeHandler.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 21/03/2023.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation

protocol HandlesBrewPhpFormulae {
    func loadPhpVersions(loadOutdated: Bool) async -> [BrewPhpFormula]
    func refreshPhpVersions(loadOutdated: Bool) async
}

extension HandlesBrewPhpFormulae {
    public func refreshPhpVersions(loadOutdated: Bool) async {
        let items = await loadPhpVersions(loadOutdated: loadOutdated)
        Task { @MainActor in
            await PhpEnvironments.shared.determinePhpAlias()
            Brew.shared.formulae.phpVersions = items
        }
    }
}

class BrewPhpFormulaeHandler: HandlesBrewPhpFormulae {
    public func loadPhpVersions(loadOutdated: Bool) async -> [BrewPhpFormula] {
        var outdated: [OutdatedFormula]?

        if loadOutdated {
            let command = """
            \(Paths.brew) update >/dev/null && \
            \(Paths.brew) outdated --json --formulae
            """

            let rawJsonText = await Shell.pipe(command).out
                .data(using: .utf8)!
            outdated = try? JSONDecoder().decode(
                OutdatedFormulae.self,
                from: rawJsonText
            ).formulae.filter({ formula in
                formula.name.starts(with: "php")
            })
        }

        return Brew.phpVersionFormulae.map { (version, formula) in
            let fullVersion = PhpEnvironments.shared.cachedPhpInstallations[version]?
                .versionNumber.text

            var upgradeVersion: String?

            if let version = fullVersion {
                upgradeVersion = outdated?.first(where: { formula in
                    return formula.installed_versions.contains(version)
                })?.current_version
            }

            return BrewPhpFormula(
                name: formula,
                displayName: "PHP \(version)",
                installedVersion: fullVersion,
                upgradeVersion: upgradeVersion,
                prerelease: Constants.ExperimentalPhpVersions.contains(version)
            )
        }.sorted { $0.displayName > $1.displayName }
    }
}
