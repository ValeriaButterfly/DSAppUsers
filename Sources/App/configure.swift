//
//  configure.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {

    let port: Int
    if let environmentPort = Environment.get("PORT") {
        port = Int(environmentPort) ?? 8081
    } else {
        port = 8081
    }
    app.http.server.configuration.port = port

    let databaseName: String
    let databasePort: Int
    if (app.environment == .testing) {
        databaseName = "vapor-test"
        if let testPort = Environment.get("DATABASE_PORT") {
            databasePort = Int(testPort) ?? 5433
        } else {
            databasePort = 5433
        }
    } else {
        databaseName = "vapor_database"
        databasePort = 5432
    }

    if var config = Environment.get("DATABASE_URL")
        .flatMap(URL.init)
        .flatMap(PostgresConfiguration.init) {
        config.tlsConfiguration = .forClient(
            certificateVerification: .none)
        app.databases.use(.postgres(
            configuration: config
        ), as: .psql)
    } else {
        app.databases.use(
            .postgres(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: databasePort,
                username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
                password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
                database: Environment.get("DATABASE_NAME") ?? databaseName),
            as: .psql)
    }

    app.migrations.add(CreateUser())

    // register routes
    try routes(app)

    try app.autoMigrate().wait()
}
