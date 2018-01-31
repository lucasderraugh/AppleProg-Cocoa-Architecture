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

final class ContactsListViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var didSelectContact: (CNContact) -> Void = { _ in }
    
    convenience init(didSelectContact: @escaping (CNContact) -> Void) {
        self.init()
        self.didSelectContact = didSelectContact
    }
    
    let contacts: [CNContact] = {
        let store = CNContactStore()
        let keysToFetch = [CNContactViewController.descriptorForRequiredKeys()]
        let containers = (try? store.containers(matching: nil)) ?? []
        var results: [CNContact] = []
        
        for container in containers {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                results.append(contentsOf: containerResults.filter { $0.contactType == .person })
            } catch let error {
                print("Error with container: \(error)")
            }
        }
        results.sort {
            let comparator = CNContact.comparator(forNameSortOrder: .userDefault)
            return comparator($0, $1) == .orderedAscending
        }
        return results
    }()
}

extension ContactsListViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: self) as! NSTableCellView
        let contact = contacts[row]
        cell.textField?.stringValue = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let contact: CNContact? = tableView.selectedRow == -1 ? nil : contacts[tableView.selectedRow]
        if let contact = contact {
            didSelectContact(contact)
        }
    }
}
