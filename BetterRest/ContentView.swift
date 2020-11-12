//
//  ContentView.swift
//  BetterRest
//
//  Created by Juan Francisco Dorado Torres on 11/11/20.
//

import SwiftUI

struct ContentView: View {
  @State private var wakeUp = Date()

  var body: some View {
    Form {
      DatePicker("Please enter a date", selection: $wakeUp)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
