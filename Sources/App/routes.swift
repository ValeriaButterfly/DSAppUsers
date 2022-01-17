//
//  routes.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UsersController())
}
