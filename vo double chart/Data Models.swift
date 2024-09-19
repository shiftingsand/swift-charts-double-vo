//
//  Data Models.swift
//  vo double chart
//
//  Created by Chris Wu on 9/19/24.
//

import Foundation

struct MonthlyChartTempData: Identifiable {
    let theType : String

    let temperatures : [(month: Date, sales: Measurement<UnitTemperature>)]

    var id = UUID()
}


