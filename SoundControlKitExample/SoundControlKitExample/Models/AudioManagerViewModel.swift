//
//  AudioManagerViewModel.swift
//  AudioRecorder
//
//  Created by Bilal Bakhrom on 2023-11-19.
//

import Foundation
import SoundControlKit
import AVFoundation

class AudioManagerViewModel: ObservableObject {
    private(set) var audioManager: SCKAudioManager!
    
    @Published var recordingURL: URL?
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var avgPowers: [Float] = []
    @Published var isPermissionAlertPresented: Bool = false
    
    init() {
        audioManager = SCKAudioManager(delegate: self)        
        Task { try? await audioManager.updateOrientation(interfaceOrientation: .portrait) }
    }
    
    func prepare() {
        do {
            try audioManager.configureRecorder()
            audioManager.resetPlayback()
        } catch {
            askRecordingPermission()
        }
    }
        
    func recordAndStop() {
        isRecording ? audioManager.stopRecording() : audioManager.record()
    }
    
    func playAndStop() {
        isPlaying ? audioManager.pausePlayback() : audioManager.play()
    }
    
    func forwardPlayback() {
        audioManager.forwardPlayback(by: 5)
    }
    
    func rewindPlayback() {
        audioManager.rewindPlayback(by: 5)
    }
    
    func deleteRecording() {
        audioManager.deleteRecording()
        audioManager.resetPlayback()
        recordingURL = nil
    }
    
    private func askRecordingPermission() {
        if AVAudioSession.sharedInstance().recordPermission == .undetermined {
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { [weak self] _ in
                    self?.prepare()
                }
            } else {
                let audioSession = AVAudioSession.sharedInstance()
                audioSession.requestRecordPermission { [weak self] _ in
                    self?.prepare()
                }
            }
        } else {
            isPermissionAlertPresented = true
        }
    }
}

extension AudioManagerViewModel: SCKAudioManagerDelegate {
    func audioManagerDidChangeRecordingState(_ audioManager: SCKAudioManager, state: SCKAudioRecorderManager.RecordingState) {
        Task {
            await MainActor.run {
                isRecording = state == .recording
            }
        }
    }
    
    func audioManagerDidChangePlaybackState(_ audioManager: SCKAudioManager, state: SCKAudioManager.PlaybackState) {
        Task {
            await MainActor.run {
                isPlaying = state == .playing
            }
        }
    }
    
    func audioManagerDidFinishRecording(_ audioManager: SCKAudioManager, at location: URL) {
        recordingURL = location
        avgPowers = []
    }
    
    func audioManagerDidFinishPlaying(_ audioManager: SCKAudioManager) {}
    
    func audioManagerLastRecordingLocation(_ audioManager: SCKAudioManager, location: URL) {
        recordingURL = location
    }
}
