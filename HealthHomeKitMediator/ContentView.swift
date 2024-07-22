//
//  ContentView.swift
//  HealthHomeKitMediator
//
//  Created by Ben Nguyen on 7/15/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "keyboard")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(Color.red)
        }
//        .padding()
    }
}

#Preview {
    ContentView()
}
