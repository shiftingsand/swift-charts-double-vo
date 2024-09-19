//
//  Data Models.swift
//  vo double chart
//
//  Created by Chris Wu on 9/19/24.
//

import Foundation

let calendar = Calendar.current
let lowDescr = "Low"
let highDescr = "High"
let myMax = 3
let tempUnit : UnitTemperature = .fahrenheit
let paddingAmount : CGFloat = 200

enum TempTypes {
    case highTemp, lowTemp
}

struct MonthlyChartTempData: Identifiable {
    let theType : String

    let temperatures : [(month: Date, sales: Measurement<UnitTemperature>)]

    var id = UUID()
}


