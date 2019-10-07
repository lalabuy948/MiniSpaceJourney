//
//  Database.swift
//  MiniSpaceJourney Extension
//
//  Created by Daniil Popov on 6/18/19.
//  Copyright © 2019 Daniil Popov. All rights reserved.
//

// @TODO: Add local db to support best result and settings

//import Foundation
//import SQLite
//
//public struct Settings {
//    let spaceshipImage   = Expression<String>("spaceshipImage")
//    let crownSensitivity = Expression<Int>("crownSensitivity")
//    let backgroundImage  = Expression<String?>("backgroundImage")
//}
//
//public class Database {
//
//    let settingsTable  = Table("settings")
//    let settingsFields = Settings()
//
//    var path = String()
//    var database: Connection!
//
//    func initDB() {
//        let path      = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let database  = try! Connection("\(path)/db.sqlite3")
//        self.database = database
//
//        let createTable = self.settingsTable.create(ifNotExists: true) { (table) in
//            table.column(self.settingsFields.spaceshipImage)
//            table.column(self.settingsFields.crownSensitivity)
//            table.column(self.settingsFields.backgroundImage)
//        }
//
//        do {
//            try self.database.run(createTable)
//            print("Database was created")
//        } catch {
//            print(error)
//        }
//    }
//
//}
