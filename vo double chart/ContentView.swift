//
//  ContentView.swift
//  vo double chart
//
//  Created by Chris Wu on 9/19/24.
//

import SwiftUI
import Charts

let calendar = Calendar.current
let lowDescr = "Low"
let highDescr = "High"
let myMax = 3
let tempUnit : UnitTemperature = .fahrenheit

enum TempTypes {
    case highTemp, lowTemp
}

struct ContentView: View {
    var startDate : Date {
        let currentYear = calendar.component(.year, from: Date())

        var components = DateComponents()
        components.year = currentYear
        components.month = 9
        components.day = 1

        if let found = calendar.date(from: components) {
            return calendar.startOfDay(for: found)
        } else {
            return calendar.startOfDay(for: .now)
        }
    }
    
    var months : [Date] {
        var rc = [Date]()
        
        for oneMonth in 0..<myMax {
            if let result = calendar.date(byAdding: .month, value: oneMonth, to: startDate) {
                rc.append(result)
            }
        }
        
        return rc
    }
    
    func randomVal(tempType : TempTypes) -> Double {
        switch tempType {
            case .highTemp:
                return Double.random(in: 85...95)
            case .lowTemp:
                return Double.random(in: 65...75)
        }
    }
    
    func getInput(tempType : TempTypes) -> [(month: Date, sales : Measurement<UnitTemperature>)] {
        var highResult : [(month: Date, sales : Measurement<UnitTemperature>)] = []
        
        for oneMonth in months {
            highResult.append((month: oneMonth, sales: .init(value: randomVal(tempType: tempType), unit: tempUnit)))
        }
        
        return highResult
    }
    
    var processedMonthlyInput : [MonthlyChartTempData] {
        var rc : [MonthlyChartTempData] = []
        
        rc.append(.init(theType: lowDescr, temperatures: getInput(tempType: .lowTemp)))
        rc.append(.init(theType: highDescr, temperatures: getInput(tempType: .highTemp)))
        
        return rc
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(processedMonthlyInput) { series in
                    ForEach(series.temperatures, id: \.month) { element in
                        LineMark(
                            x: .value("Month", element.month, unit: .month),
                            y: .value("Temperature", element.sales.converted(to: .fahrenheit).value)
                        )
                        //.accessibilityLabel("\(element.month.formatted(.dateTime.month(.wide)))")
                        //.accessibilityValue(Text("\(element.sales.converted(to: tempUnit).formatted())"))
                        .accessibilityLabel("\(series.theType) \(element.month.formatted(.dateTime.month(.wide)))")
                        .accessibilityValue(Text("\(series.theType) \(element.sales.converted(to: tempUnit).formatted())"))
                    }
                    .symbol(by: .value("Type", series.theType))
                    .foregroundStyle(by: .value("Type", series.theType))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
