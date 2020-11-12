//
//  ContentView.swift
//  BetterRest
//
//  Created by Juan Francisco Dorado Torres on 11/11/20.
//

import SwiftUI

struct ContentView: View {
  @State private var wakeUp = defaultWakeTime
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 1
  @State private var idealTimeToSleep  = ""

  static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("When do you want to wake up?")) {
          DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
        }

        Section(header: Text("Desired amount of sleep")) {
          Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
            Text("\(sleepAmount, specifier: "%g") hours")
          }
        }

        Section(header: Text("Daily coffee intake")) {
          Picker("Daily coffee intake", selection: $coffeeAmount) {
            ForEach(1..<21) { value in
              if value == 1 {
                Text("1 cup")
              } else {
                Text("\(value) cups")
              }
            }
          }
          .pickerStyle(WheelPickerStyle())
        }

        Section(header: Text("Your ideal time")) {
          Text(idealTimeToSleep)
        }
      }
      .navigationBarTitle("BetterRest")
      .onAppear {
        calculateBedtime()
      }
      .onChange(of: wakeUp) { _ in
        calculateBedtime()
      }
      .onChange(of: sleepAmount) { _ in
        calculateBedtime()
      }
      .onChange(of: coffeeAmount) { _ in
        calculateBedtime()
      }
    }
  }

  func calculateBedtime() {
    let model = SleepCalculator()

    let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    let hour = (components.hour ?? 0) * 60 * 60
    let minute = (components.minute ?? 0) * 60

    do {
      let prediction = try model.prediction(
        wake: Double(hour + minute),
        estimatedSleep: sleepAmount,
        coffee: Double(coffeeAmount)
      )
      let sleepTime = wakeUp - prediction.actualSleep

      let formatter = DateFormatter()
      formatter.timeStyle = .short

      idealTimeToSleep = formatter.string(from: sleepTime)
    } catch {
      idealTimeToSleep = "Sorry, there was a problem calculating your bedtime."
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
