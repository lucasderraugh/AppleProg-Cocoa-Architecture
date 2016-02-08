//
//  ContactsListViewController.swift
//  MyContacts
//
//  Created by Lucas Derraugh on 1/4/16.
//  Copyright © 2016 Lucas Derraugh. All rights reserved.
//

import Cocoa
import Contacts
import ContactsUI

class ContactsListViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var didSelectContact: (CNContact? -> Void)?
    
    let contacts: [CNContact] = {
        let store = CNContactStore()
        let keysToFetch = [CNContactViewController.descriptorForRequiredKeys()]
        let containers = (try? store.containersMatchingPredicate(nil)) ?? []
        var results: [CNContact] = []
        
        for container in containers {
            let predicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
            do {
                let containerResults = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
                results.appendContentsOf(containerResults.filter { $0.contactType == .Person })
            } catch let error {
                print("Error with container: \(error)")
            }
        }
        results.sortInPlace {
            let comparator = CNContact.comparatorForNameSortOrder(.UserDefault)
            return comparator($0, $1) == .OrderedAscending
        }
        return results
    }()
}

extension ContactsListViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("Cell", owner: self) as! NSTableCellView
        let contact = contacts[row]
        cell.textField?.stringValue = CNContactFormatter.stringFromContact(contact, style: .FullName) ?? ""
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let contact: CNContact? = tableView.selectedRow == -1 ? nil : contacts[tableView.selectedRow]
        didSelectContact?(contact)
    }
}
