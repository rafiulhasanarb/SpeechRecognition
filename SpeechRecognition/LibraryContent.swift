//
//  LibraryContent.swift
//  SpeechRecognition
//
//  Created by rafiul hasan on 26/10/22.
//

import Foundation
import SwiftUI

struct LibraryContent: LibraryContentProvider {
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            RecordButton(),
            title: "Record Button"
        )
        
        LibraryItem(
            Demos.Basic(locale: .current),
            title: "Demo - Basic"
        )
        
        LibraryItem(
            Demos.Colors(),
            title: "Demo - Colors"
        )
        
        LibraryItem(
            Demos.List(locale: .current),
            title: "Demos - List"
        )
    }
    
    @LibraryContentBuilder
    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(
            base.onAppear {
                requestSpeechRecognitionAuthorization()
            },
            title: "Request Speech Recognition Authorization on Appear"
        )
    }
}
