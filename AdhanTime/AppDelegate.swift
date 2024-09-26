//
//  AppDelegate.swift
//  AdhanTime
//
//  Created by Raif Agovic on 25. 8. 2024..
//

import Cocoa
import SwiftUI
class AppDelegate: NSObject, NSApplicationDelegate {
    var settingsWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Add observer for wake notifications
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(macDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    @objc func macDidWake(notification: NSNotification) {
        StatusBarViewModel.shared.refresh()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Remove observers when the app is about to terminate
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
    func openSettingsWindow() {
        if let settingsWindow = settingsWindow {
            settingsWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            let settingsView = SettingsView().environmentObject(StatusBarViewModel.shared)
            let hostingController = NSHostingController(rootView: settingsView)
            
            let window = NSWindow(
                contentViewController: hostingController
            )
            window.title = "Postavke"
            window.setContentSize(NSSize(width: 300, height: 300))
            window.styleMask = [.titled, .closable]
            window.isReleasedWhenClosed = false
            
            settingsWindow = window
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func closeSettingsWindow() {
        settingsWindow?.close()
        settingsWindow = nil
    }
}
