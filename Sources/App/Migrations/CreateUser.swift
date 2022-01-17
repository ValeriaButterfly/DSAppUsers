//
//  CreateUser.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Fluent
import Foundation

struct CreateUser: Migration {

    // MARK: - Lifecycle
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .unique(on: "username")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
