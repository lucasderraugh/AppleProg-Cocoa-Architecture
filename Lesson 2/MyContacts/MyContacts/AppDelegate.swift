//
//  AppDelegate.swift
//  MyContacts
//
//  Created by Lucas Derraugh on 1/4/16.
//  Copyright © 2016 Lucas Derraugh. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let mainWindowController = MainWindowController()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        mainWindowController.showWindow(nil)
    }
}

