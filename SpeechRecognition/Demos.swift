//
//  Demos.swift
//  SpeechRecognition
//
//  Created by rafiul hasan on 26/10/22.
//

import SwiftUI
import Combine
import Speech

struct Demos {
    
    struct Basic : View {
        
        var sessionConfiguration: Session.Configuration
        
        @State private var text = "Tap to Speak"
        
        public init(sessionConfiguration: Session.Configuration) {
            self.sessionConfiguration = sessionConfiguration
        }
        
        public init(locale: Locale = .current) {
            self.init(sessionConfiguration: Session.Configuration(locale: locale))
        }
        
        public init(localeIdentifier: String) {
            self.init(locale: Locale(identifier: localeIdentifier))
        }
        
        public var body: some View {
            VStack(spacing: 35.0) {
                Text(text)
                    .font(.system(size: 25, weight: .bold, design: .default))
                RecordButton()
                    .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                    .onRecognizeLatest(update: $text)
                
            }.onAppear {
                requestSpeechRecognitionAuthorization()
            }
        }
        
    }
    
    struct Colors : View {

        @State private var text = "Hold and say a color!"

        static let colorDictionary: [String : Color] = [
            "black": .black,
            "white": .white,
            "blue": .blue,
            "gray": .gray,
            "green": .green,
            "orange": .orange,
            "pink": .pink,
            "purple": .purple,
            "red": .red,
            "yellow": .yellow
        ]

        var color: Color? {
            Colors.colorDictionary
                .first { pair in
                    text.lowercased().contains(pair.key)
                }?
                .value
        }

        public init() { }

        public var body: some View {
            VStack(spacing: 35.0) {
                Text(text)
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(color)
                RecordButton()
                    .accentColor(color)
                    .swiftSpeechRecordOnHold(locale: Locale(identifier: "en_US"), animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                    .onRecognizeLatest(update: $text)
            }.onAppear {
                requestSpeechRecognitionAuthorization()
            }
        }

    }

    struct List : View {

        var sessionConfiguration: Session.Configuration

        @State var list: [(session: Session, text: String)] = []
        
        public init(sessionConfiguration: Session.Configuration) {
            self.sessionConfiguration = sessionConfiguration
        }
        
        public init(locale: Locale = .current) {
            self.init(sessionConfiguration: Session.Configuration(locale: locale))
        }
        
        public init(localeIdentifier: String) {
            self.init(locale: Locale(identifier: localeIdentifier))
        }

        public var body: some View {
            NavigationView {
                SwiftUI.List {
                    ForEach(list, id: \.session.id) { pair in
                        Text(pair.text)
                    }
                }.overlay(
                    RecordButton()
                        .swiftSpeechRecordOnHold(
                            sessionConfiguration: sessionConfiguration,
                            animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0),
                            distanceToCancel: 100.0
                        ).onStartRecording { session in
                            list.append((session, ""))
                        }.onCancelRecording { session in
                            _ = list.firstIndex { $0.session.id == session.id }
                                .map { list.remove(at: $0) }
                        }.onRecognize(includePartialResults: true) { session, result in
                            list.firstIndex { $0.session.id == session.id }
                                .map { index in
                                    list[index].text = result.bestTranscription.formattedString + (result.isFinal ? "" : "...")
                                }
                        } handleError: { session, error in
                            list.firstIndex { $0.session.id == session.id }
                                .map { index in
                                    list[index].text = "Error \((error as NSError).code)"
                                }
                        }.padding(20),
                    alignment: .bottom
                ).navigationBarTitle(Text("SwiftSpeech"))

            }.onAppear {
                requestSpeechRecognitionAuthorization()
            }
        }
    }
}
