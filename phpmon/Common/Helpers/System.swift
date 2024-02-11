//
//  System.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 01/11/2022.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation

/**
 Run a simple blocking Shell command on the user's own system.
 */
public func system(_ command: String) -> String {
    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
}

/**
 Same as the `system` command, but does not return the output.
 */
public func system_quiet(_ command: String) {
    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    _ = pipe.fileHandleForReading.readDataToEndOfFile()
    return
}

/**
 Retrieves the username for the currently signed in user via `/usr/bin/id`.
 This cannot fail or the application will crash.
 */
public func identity() -> String {
    let task = Process()
    task.launchPath = "/usr/bin/id"
    task.arguments = ["-un"]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    guard let output = String(
        data: pipe.fileHandleForReading.readDataToEndOfFile(),
        encoding: String.Encoding.utf8
    ) else {
        fatalError("Could not retrieve username via `id -un`!")
    }

    return output.trimmingCharacters(in: .whitespacesAndNewlines)
}

/**
 Retrieves the user's preferred shell.
 */
public func preferred_shell() -> String {
    return system("dscl . -read ~/ UserShell | sed 's/UserShell: //'")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}
