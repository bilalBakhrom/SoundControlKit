# SoundControlKit (SCK)

SoundControlKit (SCK) is a Swift package designed to simplify audio management in iOS applications. It provides an easy-to-use AudioManager for handling audio recording and playback.

## Overview

The SCK package offers a convenient solution for managing audio-related tasks in your Swift projects. It includes functionalities for configuring the audio session, recording audio, playing audio, and controlling playback.

## Installation

### Swift Package Manager

You can add SoundControlKit as a dependency in your Swift Package Manager-enabled project. Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/bilalBakhrom/SoundControlKit.git", from: "2.0.0")
]
```

## Usage

To use SoundControlKit in your project, follow these steps:

```swift
import SoundControlKit

// Create an instance of `SCKAudioManager`.
let audioManager = SCKAudioManager()

// MARK: - Control Recording

// Start recording audio.
audioManager.configureRecorder()
audioManager.record()

// OR: Start recording audio with haptic vibration at the beginning.
Task { await audioManager.record() }

// Pause the recording.
audioManager.pauseRecording()
// Stop the recording.
audioManager.stopRecording()

// MARK: - Control Playback

// Play the recorded audio.
audioManager.play()
// Pause the playback.
audioManager.pausePlayback()
// Stop the playback.
audioManager.stopPlayback()
```

Control notifications:
```swift
// // Stop all ongoing audio playbacks.
NotificationCenter.default.post(sckNotification: .soundControlKitRequiredToStopAudioPlayback)

// Stop a specific audio playback with the specified `URL`.
NotificationCenter.default.post(sckNotification: .soundControlKitRequiredToStopAudioPlayback, object: recordingURL)
```

## Example

Explore the [sample project](https://github.com/bilalBakhrom/SoundControlKit/tree/master/SoundControlKitExample) that demonstrates how to use SoundControlKit.

## License

SoundControlKit is released under the [Apache License 2.0](https://github.com/bilalBakhrom/SoundControlKit/blob/master/LICENSE).

## Articles

Explore the intricacies of audio recording with these informative articles:
- [Enhancing Audio Recording Mastery: Part I — Mono Mode](https://medium.com/@bilalbakhrom/enhancing-audio-recording-mastery-part-ii-stereo-mode-a458ed18befb)
- [Enhancing Audio Recording Mastery: Part II — Stereo Mode](https://medium.com/@bilalbakhrom/enhancing-audio-recording-mastery-part-i-mono-mode-895f9d8747e1)

