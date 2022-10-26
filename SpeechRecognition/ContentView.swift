//
//  ContentView.swift
//  SpeechRecognition
//
//  Created by rafiul hasan on 26/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Demos.Basic()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
