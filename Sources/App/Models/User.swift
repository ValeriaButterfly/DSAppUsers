//
//  User.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Foundation
import Vapor
import Fluent

final class User: Model, Content {

    // MARK: - Public Properties

    static let schema = "users"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String

    // MARK: - Initializers

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }

    init() {}

    // MARK: -

    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String

        init(id: UUID?, name: String, username: String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
}

// MARK: -

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: name, username: username)
    }
}

// MARK: -

extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        return self.map { user in
            return user.convertToPublic()
        }
    }
}

// MARK: -

extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        return self.map { $0.convertToPublic() }
    }
}

// MARK: -

extension EventLoopFuture where Value == Array<User> {
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        return self.map { $0.convertToPublic() }
    }
}
