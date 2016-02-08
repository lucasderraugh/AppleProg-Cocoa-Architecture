//
//  MainWindowController.swift
//  MyContacts
//
//  Created by Lucas Derraugh on 1/4/16.
//  Copyright © 2016 Lucas Derraugh. All rights reserved.
//

import Cocoa
import ContactsUI

class MainWindowController: NSWindowController {
    
    convenience init() {
        self.init(windowNibName: "MainWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .Hidden
        
        let splitVC = NSSplitViewController()
        let contactVC = CNContactViewController()
        let contactsListVC = ContactsListViewController()
        contactsListVC.didSelectContact = {
            contactVC.contact = $0
        }
        
        splitVC.addSplitViewItem(NSSplitViewItem(contentListWithViewController: contactsListVC))
        splitVC.addSplitViewItem(NSSplitViewItem(viewController: contactVC))
        window?.contentViewController = splitVC
    }
    
}
