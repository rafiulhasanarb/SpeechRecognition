//
//  Environments.swift
//  SpeechRecognition
//
//  Created by rafiul hasan on 26/10/22.
//

import SwiftUI
import Combine
import Speech

enum SpeechState {
    /// Indicating there is no recording in progress.
    /// - Note: It's the default value for `@Environment(\.swiftSpeechState)`.
    case pending
    /// Indicating there is a recording in progress and the user does not intend to cancel it.
    case recording
    /// Indicating there is a recording in progress and the user intends to cancel it.
    case cancelling
}

struct EnvironmentKeys {
    struct SwiftSpeechState: EnvironmentKey {
        static let defaultValue: SpeechState = .pending
    }
    
    struct ActionsOnStartRecording: EnvironmentKey {
        static let defaultValue: [(_ session: Session) -> Void] = []
    }
    
    struct ActionsOnStopRecording: EnvironmentKey {
        static let defaultValue: [(_ session: Session) -> Void] = []
    }
    
    struct ActionsOnCancelRecording: EnvironmentKey {
        static let defaultValue: [(_ session: Session) -> Void] = []
    }
}

public extension EnvironmentValues {
    
    internal var swiftSpeechState: SpeechState {
        get { self[EnvironmentKeys.SwiftSpeechState.self] }
        set { self[EnvironmentKeys.SwiftSpeechState.self] = newValue }
    }
    
    var actionsOnStartRecording: [(_ session: Session) -> Void] {
        get { self[EnvironmentKeys.ActionsOnStartRecording.self] }
        set { self[EnvironmentKeys.ActionsOnStartRecording.self] = newValue }
    }
    
    var actionsOnStopRecording: [(_ session: Session) -> Void] {
        get { self[EnvironmentKeys.ActionsOnStopRecording.self] }
        set { self[EnvironmentKeys.ActionsOnStopRecording.self] = newValue }
    }
    
    var actionsOnCancelRecording: [(_ session: Session) -> Void] {
        get { self[EnvironmentKeys.ActionsOnCancelRecording.self] }
        set { self[EnvironmentKeys.ActionsOnCancelRecording.self] = newValue }
    }
}

