# AIFoodRecipe
### Apple Foundation Models & On-Device AI Recipe Generator

**AIFoodRecipe** is an advanced iOS application built natively with SwiftUI that leverages Apple’s **Foundation Models** (`SystemLanguageModel`) for on-device AI recipe generation. It features a seamless fallback mock generator, live voice search, and deep system integration via App Intents and Siri.

---

## 🚀 Key Features

* **On-Device AI Intelligence:** Automatically detects device capabilities using `SystemLanguageModel` to generate custom recipes locally, with a robust fallback mock generator for unsupported devices or simulators.
* **Voice Search Integration:** Uses `Speech` and `AVFoundation` frameworks to let users speak their dish queries instantly with real-time transcription.
* **App Intents & Siri / Shortcuts Integration:** Fully integrated with iOS App Intents, allowing users to trigger custom recipe generations through Siri and the Shortcuts app.

---

## 🛠️ App Intents & Siri / Shortcuts Integration

### Where You Can Test It?

#### 1. The Shortcuts App on iOS:
* Open the **Shortcuts** app on your iPhone or Simulator.
* Tap to create a new shortcut, look for your app's name (`FoundationModelTesterApp` or your target name), and you will see the **Generate Recipe** shortcut block ready to use.

#### 2. Testing with Siri:
* Invoke Siri and say: *"Generate a recipe in AI Recipe Generator."*
* Siri reads the `RecipeShortcuts` phrases list, matches your command to `GenerateRecipeIntent`, runs the code in the background, and speaks back the result.

---

## 📱 Requirements & Setup

* **Xcode:** Version 16.0 or newer
* **iOS:** iOS 18.0+ / iPadOS 18.0+
* **Permissions (Info.plist):**
  * `NSSpeechRecognitionUsageDescription` (*"We use speech recognition to let you search for recipes using your voice."*)
  * `NSMicrophoneUsageDescription` (*"We need microphone access to capture your voice query."*)
