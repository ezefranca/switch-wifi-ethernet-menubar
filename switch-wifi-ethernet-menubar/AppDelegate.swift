//
//  AppDelegate.swift
//  switch-wifi-ethernet-menubar
//
//  Created by Ezequiel on 09/08/17.
//  Copyright © 2017 Ezequiel. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    //var server: KeySenderRecivingService?
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.image = NSImage(named: NSImage.Name(rawValue: "ethernet"))
        //        statusBar.menu = mainMenu
        //        statusBar.highlightMode = true
        statusItem.menu = statusMenu
        statusItem.highlightMode = true
    }
    
    @IBAction func statusMenuAction(_ sender: NSMenuItem) {
        Shell().outputOf(commandName: "sudo networksetup -setairportpower airport off")
        //print(shell("networksetup -setairportpower airport off").output)
    }
}

final class Shell
{
    func outputOf(commandName: String, arguments: [String] = ["pwd"]) -> String? {
        return bash(commandName: commandName, arguments:arguments)
    }
    
    // MARK: private
    
    private func bash(commandName: String, arguments: [String]) -> String? {
        guard var whichPathForCommand = executeShell(command: "/bin/bash" , arguments:[ "-l", "-c", "which \(commandName)" ]) else {
            return "\(commandName) not found"
        }
        whichPathForCommand = whichPathForCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return executeShell(command: whichPathForCommand, arguments: arguments)
    }
    
    private func executeShell(command: String, arguments: [String] = []) -> String? {
        let task = Process()
        task.launchPath = command
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String? = String(data: data, encoding: String.Encoding.utf8)
        
        return output
    }
    
}

