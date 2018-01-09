//
//  ListContactsInteractor.swift
//  words
//
//  Created by Neo Ighodaro on 09/12/2017.
//  Copyright (c) 2017 CreativityKills Co.. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import PusherChatkit

protocol ListContactsBusinessLogic {
    var currentUser: PCCurrentUser? { get set }
    func fetchContacts(request: ListContacts.Fetch.Request)
    func addContact(request: ListContacts.Create.Request)
}

protocol ListContactsDataStore {
    var contacts: [Contact]? { get }
    var currentUser: PCCurrentUser? { get set }
}

class ListContactsInteractor: ListContactsBusinessLogic, ListContactsDataStore {
    
    // MARK: Properties
    
    var contacts: [Contact]?
    var currentUser: PCCurrentUser?
    var presenter: ListContactsPresentationLogic?
    var worker: UsersWorker = UsersWorker(usersStore: UsersAPI())

    // MARK: Fetch Contacts
  
    func fetchContacts(request: ListContacts.Fetch.Request) {
        worker.fetchContacts(currentUser: currentUser!) { contacts, error in
            guard error == nil else { return }

            self.contacts = contacts
            self.presenter?.presentContacts(contacts!)
        }
    }
    
    // MARK: Add contact
    
    func addContact(request: ListContacts.Create.Request) {
        worker.addContact(request: request) { contact, error in
            guard error == nil else { return }

            self.contacts?.append(contact!)
            self.presenter?.presentAddedContact(contact!)
        }
    }
}
