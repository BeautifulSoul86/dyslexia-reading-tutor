# Dyslexia Reading Tutor - Starter 0.1

This is the first Flutter starter build. It includes:
- Child/adult mode selection
- Cartoon/realistic tutor appearance selection (icon placeholder for now)
- Tutor voice-style preference selection
- Red consonants and blue vowels
- Randomized CVC word practice
- Help/retry flow with a different word
- Local practice counters saved with shared_preferences

## Important limitations
This is not yet a live AI tutor. The voice style is a preference setting only. There is no microphone capture, speech recognition, phoneme-level pronunciation scoring, AI conversation, or verified mastery. The "I decoded it independently" button is a self-report and is explicitly recorded separately from verified mastery.

## Run it
1. Install Flutter and Android Studio or VS Code with Flutter support.
2. Create a Flutter project:
   `flutter create dyslexia_reading_tutor`
3. Replace the generated `pubspec.yaml` with this folder's `pubspec.yaml`.
4. Replace `lib/main.dart` with this folder's `lib/main.dart`.
5. In the project folder run:
   `flutter pub get`
6. Connect an Android phone with USB debugging enabled, or start an Android emulator.
7. Run:
   `flutter run`

For iPhone builds, Flutter's iOS toolchain requires macOS and Xcode. You can develop the shared Flutter code on Windows, but you will need access to a Mac (local or hosted) to build/sign the iOS app.

## Next milestone
Add real audio playback and microphone capture, then integrate speech assessment that can report uncertainty instead of guessing. After that, connect the conversational AI tutor using a secure backend; never put private API keys inside the mobile app.
