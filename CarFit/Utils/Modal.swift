//
//  Modal.swift
//  CarFit
//
//  Created by Ramesh Siddanavar on 07/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// MARK: - Response
struct Response: Codable {
    let success: Bool
    let message: String
    let data: [Owner]
    let code: Int
}

// MARK: - Datum
struct Owner: Codable {
    let visitID, homeBobEmployeeID, houseOwnerID: String
    let isBlocked: Bool
    let startTimeUTC, endTimeUTC, title: String
    let isReviewed, isFirstVisit, isManual: Bool
    let visitTimeUsed: Int
    let rememberToday: String?
    let houseOwnerFirstName, houseOwnerLastName, houseOwnerMobilePhone, houseOwnerAddress: String
    let houseOwnerZip, houseOwnerCity: String
    let houseOwnerLatitude, houseOwnerLongitude: Double
    let isSubscriber: Bool
    let rememberAlways: String?
    let professional, visitState: String
    let stateOrder: Int
    let expectedTime: String?
    let tasks: [Task]
//    let houseOwnerAssets, visitAssets, visitMessages: [String]?

    enum CodingKeys: String, CodingKey {
        case visitID = "visitId"
        case homeBobEmployeeID = "homeBobEmployeeId"
        case houseOwnerID = "houseOwnerId"
        case isBlocked
        case startTimeUTC = "startTimeUtc"
        case endTimeUTC = "endTimeUtc"
        case title, isReviewed, isFirstVisit, isManual, visitTimeUsed, rememberToday, houseOwnerFirstName, houseOwnerLastName, houseOwnerMobilePhone, houseOwnerAddress, houseOwnerZip, houseOwnerCity, houseOwnerLatitude, houseOwnerLongitude, isSubscriber, rememberAlways, professional, visitState, stateOrder, expectedTime, tasks //, houseOwnerAssets, visitAssets, visitMessages
    }
}

// MARK: - Task
struct Task: Codable {
    let taskID, title: String
    let isTemplate: Bool
    let timesInMinutes, price: Int
    let paymentTypeID, createDateUTC, lastUpdateDateUTC: String
    let paymentTypes: String?

    enum CodingKeys: String, CodingKey {
        case taskID = "taskId"
        case title, isTemplate, timesInMinutes, price
        case paymentTypeID = "paymentTypeId"
        case createDateUTC = "createDateUtc"
        case lastUpdateDateUTC = "lastUpdateDateUtc"
        case paymentTypes
    }
}
