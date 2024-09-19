//
//  ContentView.swift
//  vo double chart
//
//  Created by Chris Wu on 9/19/24.
//

import SwiftUI
import Charts

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

    
    var processedMonthlyInput : [MonthlyChartTempData] {
        var rc : [MonthlyChartTempData] = []
        
        rc.append(.init(theType: lowDescr, temperatures: getInput(tempType: .lowTemp)))
        rc.append(.init(theType: highDescr, temperatures: getInput(tempType: .highTemp)))
        
        return rc
    }
    
    // when swiping down on a month voiceover will only speak the high and low temperatures on the bottom chart.
    var body: some View {
        VStack {
            headerText("BAD")
            Chart {
                ForEach(processedMonthlyInput) { oneMonth in
                    ForEach(oneMonth.temperatures, id: \.month) { element in
                        LineMark(
                            x: .value("Month", element.month, unit: .month),
                            y: .value("Temperature", element.tempVal.converted(to: .fahrenheit).value)
                        )
                        .accessibilityLabel("\(element.month.formatted(.dateTime.month(.wide)))")
                        .accessibilityValue(Text("\(element.tempVal.converted(to: tempUnit).formatted(.measurement(width: .abbreviated, numberFormatStyle: .number.precision(.fractionLength(0)))))"))
                    }
                    .symbol(by: .value("Type", oneMonth.theType))
                    .foregroundStyle(by: .value("Type", oneMonth.theType))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(maxHeight: paddingAmount)
            .padding(.horizontal)
            
            headerText("GOOD")
            Chart {
                ForEach(processedMonthlyInput) { oneMonth in
                    ForEach(oneMonth.temperatures, id: \.month) { element in
                        LineMark(
                            x: .value("Month", element.month, unit: .month),
                            y: .value("Temperature", element.tempVal.converted(to: .fahrenheit).value)
                        )
                        .accessibilityLabel("\(oneMonth.theType) \(element.month.formatted(.dateTime.month(.wide)))")
                        .accessibilityValue(Text("\(oneMonth.theType) \(element.tempVal.converted(to: tempUnit).formatted(.measurement(width: .abbreviated, numberFormatStyle: .number.precision(.fractionLength(0)))))"))
                    }
                    .symbol(by: .value("Type", oneMonth.theType))
                    .foregroundStyle(by: .value("Type", oneMonth.theType))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(maxHeight: paddingAmount)
            .padding(.horizontal)
        }
    }
    
    func headerText(_ value : String) -> some View {
        Text(value)
            .font(.largeTitle)
            .fontWeight(.heavy)
    }
    
    func randomVal(tempType : TempTypes) -> Double {
        switch tempType {
            case .highTemp:
                return Double.random(in: 85...95)
            case .lowTemp:
                return Double.random(in: 65...75)
        }
    }
    
    func getInput(tempType : TempTypes) -> [(month: Date, tempVal : Measurement<UnitTemperature>)] {
        var highResult : [(month: Date, tempVal : Measurement<UnitTemperature>)] = []
        
        for oneMonth in months {
            highResult.append((month: oneMonth, tempVal: .init(value: randomVal(tempType: tempType), unit: tempUnit)))
        }
        
        return highResult
    }
}

#Preview {
    ContentView()
}
