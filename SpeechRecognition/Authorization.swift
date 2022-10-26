//
//  Authorization.swift
//  SpeechRecognition
//
//  Created by rafiul hasan on 26/10/22.
//

import SwiftUI
import Combine
import Speech

/// Change this when the app starts to configure the default animation used for all record on hold functional components.
public var defaultAnimation: Animation = .interactiveSpring()

public func requestSpeechRecognitionAuthorization() {
    AuthorizationCenter.shared.requestSpeechRecognitionAuthorization()
}

class AuthorizationCenter: ObservableObject {
    @Published var speechRecognitionAuthorizationStatus: SFSpeechRecognizerAuthorizationStatus = SFSpeechRecognizer.authorizationStatus()
    
    func requestSpeechRecognitionAuthorization() {
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if self.speechRecognitionAuthorizationStatus != authStatus {
                DispatchQueue.main.async {
                    self.speechRecognitionAuthorizationStatus = authStatus
                }
            }
        }
    }
    
    static let shared = AuthorizationCenter()
}

@propertyWrapper public struct SpeechRecognitionAuthStatus: DynamicProperty {
    @ObservedObject var authCenter = AuthorizationCenter.shared
    
    let trueValues: Set<SFSpeechRecognizerAuthorizationStatus>
    
    public var wrappedValue: SFSpeechRecognizerAuthorizationStatus {
        AuthorizationCenter.shared.speechRecognitionAuthorizationStatus
    }
    
    public init(trueValues: Set<SFSpeechRecognizerAuthorizationStatus> = [.authorized]) {
        self.trueValues = trueValues
    }
    
    public var projectedValue: Bool {
        self.trueValues.contains(AuthorizationCenter.shared.speechRecognitionAuthorizationStatus)
    }
}

extension SFSpeechRecognizerAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        "\(rawValue)"
    }
}
