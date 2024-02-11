//
//  MainMenu+Async.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 06/02/2022.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation

extension MainMenu {

    // MARK: - Nicer callbacks

    enum AsyncBehaviour {
        case setsBusyUI
        case reloadsPhpInstallation
        case updatesMenuBarContents
        case broadcastServicesUpdate
    }

    /**
     Attempts asynchronous execution of a callback that may throw an `Error`.
     While the callback is being executed, the UI will be marked as busy.
     
     (Preferably, if an `Error` is thrown, it should also be an `AlertableError`,
     which will make presenting errors easier.)
     
     - Parameter execute: Required callback of the work that needs to happen.
     
     - Parameter success: Optional callback that is fired when all was OK.
     - Parameter failure: Optional callback that is fired when an `Error` was thrown.
     - Parameter behaviours: Various behaviours that can be tweaked, but usually best left to the default.
                             The default will set the UI to busy, reload PHP info, update the menu bar,
                             and broadcast to the services view that the list has been updated.
     */
    func asyncExecution(
        _ execute: @escaping () throws -> Void,
        success: @MainActor @escaping () -> Void = {},
        failure: @MainActor @escaping (Error) -> Void = { _ in },
        behaviours: [AsyncBehaviour] = [
            .setsBusyUI,
            .reloadsPhpInstallation,
            .updatesMenuBarContents,
            .broadcastServicesUpdate
        ]
    ) {
        if behaviours.contains(.reloadsPhpInstallation) || behaviours.contains(.setsBusyUI) {
            PhpEnvironments.shared.isBusy = true
        }

        Task(priority: .userInitiated) { [unowned self] in
            var error: Error?

            do { try execute() } catch let e {
                error = e
                Log.err(e)
            }

            Task { @MainActor [self, error] in
                if behaviours.contains(.reloadsPhpInstallation) {
                    PhpEnvironments.shared.currentInstall = ActivePhpInstallation()
                }

                if behaviours.contains(.updatesMenuBarContents) {
                    refreshIcon()
                    rebuild()
                }

                if behaviours.contains(.broadcastServicesUpdate) {
                    Task { await ServicesManager.shared.reloadServicesStatus() }
                }

                if behaviours.contains(.setsBusyUI) {
                    PhpEnvironments.shared.isBusy = false
                }

                if error != nil {
                    return failure(error!)
                }

                success()
            }
        }
    }

    func asyncWithBusyUI(
        _ execute: @escaping () throws -> Void,
        completion: @escaping () -> Void = {}
    ) {
        asyncExecution({
            try! execute()
        }, success: {
            completion()
        }, behaviours: [.setsBusyUI])
    }

}
