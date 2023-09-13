//
//  PMWindowController.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 05/12/2021.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Cocoa

/**
 This window class keeps track of which windows are currently visible, and reports this info back to the App class.
 For more information, check the `windows` property on `App`.
 
 - Note: This class does make a simple assumption: each window controller corresponds to a single view.
 */
class PMWindowController: NSWindowController, NSWindowDelegate {

    public var windowName: String {
        fatalError("Please specify a window name")
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        App.shared.register(window: windowName)
    }

    func windowWillClose(_ notification: Notification) {
        App.shared.remove(window: windowName)
    }

    deinit {
        Log.perf("deinit: \(String(describing: self)).\(#function)")
    }

}

extension NSWindowController {

    public func positionWindowInTopRightCorner(offsetY: CGFloat = 0, offsetX: CGFloat = 0) {
        guard let frame = NSScreen.main?.frame else { return }
        guard let window = self.window else { return }

        window.setFrame(NSRect(
            x: frame.size.width - window.frame.size.width - 20 + offsetX,
            y: frame.size.height - window.frame.size.height - 40 + offsetY,
            width: window.frame.width,
            height: window.frame.height
        ), display: true)
    }

}
