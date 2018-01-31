//
//  MainWindowController.swift
//  MyContacts
//
//  Created by Lucas Derraugh on 1/4/16.
//  Copyright © 2016 Lucas Derraugh. All rights reserved.
//

import Cocoa
import ContactsUI

final class MainWindowController: NSWindowController {
    
    convenience init() {
        self.init(windowNibName: NSNib.Name(rawValue: "MainWindowController"))
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        
        let splitVC = NSSplitViewController()
        let contactVC = CNContactViewController()
        let contactsListVC = ContactsListViewController() { [weak contactVC] in
            // We want a weak reference to contactVC or else we're retaining this view unnecessarily
            contactVC?.contact = $0
        }
        
        splitVC.addSplitViewItem(NSSplitViewItem(contentListWithViewController: contactsListVC))
        splitVC.addSplitViewItem(NSSplitViewItem(viewController: contactVC))
        window?.contentViewController = splitVC
    }
}
