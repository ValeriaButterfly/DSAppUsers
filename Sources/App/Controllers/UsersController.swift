//
//  UsersController.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

struct UsersController: RouteCollection {

    // MARK: - Lifecycle

    func boot(routes: RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        usersGroup.get(use: getAllHandler)
        usersGroup.get(":userID", use: getHandler)
        
        usersGroup.post(use: createHandler)
    }

    // MARK: - Public Methods

    func getAllHandler(_ req: Request) -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).all().convertToPublic()
    }

    func getHandler(_ req: Request) -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).convertToPublic()
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
}
