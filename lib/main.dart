import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DyslexiaReadingTutorApp());
}

class DyslexiaReadingTutorApp extends StatelessWidget {
  const DyslexiaReadingTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyslexia Reading Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6558C9),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WordCard {
  final String word;
  final String meaning;
  final List<String> sounds;

  const WordCard(this.word, this.meaning, this.sounds);
}

const List<WordCard> wordBank = [
  WordCard('cat', 'A furry pet that says meow.', ['c', 'a', 't']),
  WordCard('map', 'A picture that helps us find places.', ['m', 'a', 'p']),
  WordCard('sun', 'The bright star that lights our day.', ['s', 'u', 'n']),
  WordCard('bed', 'A cozy place to sleep.', ['b', 'e', 'd']),
  WordCard('sit', 'To rest on a chair or seat.', ['s', 'i', 't']),
  WordCard('hop', 'To jump on one foot or both feet.', ['h', 'o', 'p']),
  WordCard('lip', 'The soft edge of your mouth.', ['l', 'i', 'p']),
  WordCard('mug', 'A cup you can drink from.', ['m', 'u', 'g']),
  WordCard('pet', 'An animal cared for at home.', ['p', 'e', 't']),
  WordCard('dot', 'A tiny round mark.', ['d', 'o', 't']),
];

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String learnerType = 'Child';
  String avatarStyle = 'Friendly cartoon';
  String tutorVoice = 'Bright and cheerful';

  void _start() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          learnerType: learnerType,
          avatarStyle: avatarStyle,
          tutorVoice: tutorVoice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isChild = learnerType == 'Child';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Icon(
                  Icons.menu_book_rounded,
                  size: 76,
                  color: Color(0xFF6558C9),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Dyslexia Reading Tutor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF302A58),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A little practice. A lot of progress.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Who is learning today?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Child',
                      label: Text('Child'),
                      icon: Icon(Icons.face_rounded),
                    ),
                    ButtonSegment(
                      value: 'Adult',
                      label: Text('Adult'),
                      icon: Icon(Icons.person_rounded),
                    ),
                  ],
                  selected: {learnerType},
                  onSelectionChanged: (value) {
                    setState(() => learnerType = value.first);
                  },
                ),
                const SizedBox(height: 22),
                const Text(
                  'Tutor personality',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: avatarStyle,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Friendly cartoon',
                      child: Text('Friendly cartoon'),
                    ),
                    DropdownMenuItem(
                      value: 'Calm reading coach',
                      child: Text('Calm reading coach'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => avatarStyle = value);
                    }
                  },
                ),
                const SizedBox(height: 18),
                const Text(
                  'Tutor voice style',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: tutorVoice,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Bright and cheerful',
                      child: Text('Bright and cheerful'),
                    ),
                    DropdownMenuItem(
                      value: 'Calm and encouraging',
                      child: Text('Calm and encouraging'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => tutorVoice = value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      isChild
                          ? 'We will learn one little word at a time. You can listen, try, and celebrate every effort!'
                          : 'Practice at your own pace with spoken word practice and supportive guidance. No pressure and no timers.',
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Let’s start learning!'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Reading Lounge replies are currently built-in responses, not live AI chat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class LessonScreen extends StatefulWidget {
  final String learnerType;
  final String avatarStyle;
  final String tutorVoice;

  const LessonScreen({
    super.key,
    required this.learnerType,
    required this.avatarStyle,
    required this.tutorVoice,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final stt.SpeechToText lessonSpeech = stt.SpeechToText();
  final FlutterTts lessonTts = FlutterTts();
  final Random random = Random();
  final TextEditingController emergencyController =
      TextEditingController();

  int stars = 0;
  int independentReads = 0;
  int supportedAttempts = 0;
  int wordsPracticed = 0;
  int currentStreak = 0;

  int wordIndex = 0;
  int guidedStep = 0;

  bool progressLoaded = false;
  bool isListening = false;
  bool speechAvailable = false;
  bool showEmergencyTyping = false;
  bool wordRewarded = false;
  bool lessonSessionHandled = false;
  bool isSpeaking = false;
  bool guidedPracticeStarted = false;

  String recognizedWords = '';
  String statusMessage = 'Tap the microphone when you are ready.';
  String tutorMessage = 'Ready to practice a word? Let’s do it!';
  String rewardMessage = '';
  String emergencyText = '';

  Timer? evaluationTimer;

  WordCard get currentWord => wordBank[wordIndex];

  bool get isChild => widget.learnerType == 'Child';

  @override
  void initState() {
    super.initState();
    _initializeLesson();
  }

  Future<void> _initializeLesson() async {
    await _loadProgress();
    if (!mounted) return;

    await _initializeSpeech();
    await _configureVoice();

    if (!mounted) return;

    setState(() {
      statusMessage = speechAvailable
          ? 'Your microphone is ready. Tap it and read the word aloud.'
          : 'Speech recognition is unavailable. Check microphone permission.';
      if (!speechAvailable) showEmergencyTyping = true;
    });

    _speak(
      isChild
          ? 'Welcome back, superstar reader! Let’s practice a word together.'
          : 'Welcome. Let’s work through a reading exercise at your own pace.',
    );
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      stars = prefs.getInt('reading_stars') ?? 0;
      independentReads = prefs.getInt('independent_reads') ?? 0;
      supportedAttempts = prefs.getInt('supported_attempts') ?? 0;
      wordsPracticed = prefs.getInt('words_practiced') ?? 0;
      progressLoaded = true;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reading_stars', stars);
    await prefs.setInt('independent_reads', independentReads);
    await prefs.setInt('supported_attempts', supportedAttempts);
    await prefs.setInt('words_practiced', wordsPracticed);
  }

  Future<void> _initializeSpeech() async {
    try {
      speechAvailable = await lessonSpeech.initialize(
        onStatus: (status) {
          if (!mounted) return;

          if (status == 'notListening' && isListening) {
            setState(() {
              isListening = false;
              statusMessage = recognizedWords.isEmpty
                  ? 'I stopped listening. You can try again.'
                  : 'I heard you. Checking your word...';
            });

            if (recognizedWords.isNotEmpty) {
              _scheduleLessonEvaluation();
            }
          }
        },
        onError: (error) {
          if (!mounted) return;

          setState(() {
            isListening = false;
            statusMessage = 'Microphone issue: ${error.errorMsg}';
            if (recognizedWords.isEmpty) {
              showEmergencyTyping = true;
            }
          });

          if (recognizedWords.isNotEmpty) {
            _scheduleLessonEvaluation();
          }
        },
      );
    } catch (_) {
      speechAvailable = false;
    }

    if (mounted) setState(() {});
  }

  Future<void> _configureVoice() async {
    try {
      await lessonTts.setLanguage('en-US');
      await lessonTts.setSpeechRate(isChild ? 0.43 : 0.48);
      await lessonTts.setPitch(isChild ? 1.12 : 1.0);
      await lessonTts.setVolume(1.0);
      await lessonTts.awaitSpeakCompletion(true);
    } catch (_) {
      // Written instructions remain available if speech setup fails.
    }
  }

  Future<void> _speak(String message) async {
    try {
      await lessonTts.stop();
      if (!mounted) return;

      setState(() => isSpeaking = true);
      await lessonTts.speak(message);
    } catch (_) {
      // Keep the on-screen instructions available if speech fails.
    } finally {
      if (mounted) setState(() => isSpeaking = false);
    }
  }

  Future<void> _stopSpeaking() async {
    await lessonTts.stop();
    if (mounted) setState(() => isSpeaking = false);
  }

  Future<void> _toggleLessonMicrophone() async {
    if (!progressLoaded || wordRewarded) return;

    if (isListening) {
      await lessonSpeech.stop();

      if (mounted) {
        setState(() {
          isListening = false;
          statusMessage = recognizedWords.isEmpty
              ? 'Listening stopped. Tap the microphone to try again.'
              : 'Checking what I heard...';
        });
      }

      if (recognizedWords.isNotEmpty) {
        _scheduleLessonEvaluation();
      }
      return;
    }

    if (!speechAvailable) {
      await _initializeSpeech();
    }

    if (!speechAvailable) {
      setState(() {
        showEmergencyTyping = true;
        statusMessage =
            'Speech recognition is unavailable. Check microphone permission or use the backup option.';
      });
      return;
    }

    evaluationTimer?.cancel();
    lessonSessionHandled = false;
    recognizedWords = '';

    setState(() {
      showEmergencyTyping = false;
      isListening = true;
      statusMessage = 'Listening... read the whole word aloud.';
    });

    try {
      await lessonSpeech.listen(
        onResult: (result) {
          if (!mounted) return;

          recognizedWords = result.recognizedWords;

          setState(() {
            statusMessage = recognizedWords.isEmpty
                ? 'Listening...'
                : 'I heard: "$recognizedWords"';
          });

          if (result.finalResult) {
            setState(() => isListening = false);
            _scheduleLessonEvaluation();
          }
        },
        listenFor: const Duration(seconds: 90),
        pauseFor: const Duration(seconds: 15),
        partialResults: true,
        cancelOnError: false,
        localeId: 'en_US',
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isListening = false;
        showEmergencyTyping = true;
        statusMessage =
            'I could not start the microphone. Check permission or use the backup option.';
      });
    }
  }

  void _scheduleLessonEvaluation() {
    evaluationTimer?.cancel();

    evaluationTimer = Timer(
      const Duration(milliseconds: 900),
      () {
        if (mounted) _evaluateLessonSpeech();
      },
    );
  }

  void _evaluateLessonSpeech() {
    if (lessonSessionHandled || wordRewarded) return;

    lessonSessionHandled = true;

    final heard = recognizedWords.toLowerCase().replaceAll(
          RegExp(r'[^a-z ]'),
          '',
        );

    final target = currentWord.word.toLowerCase();
    final heardList = heard.split(RegExp(r'\s+'));

    if (heardList.contains(target)) {
      setState(() {
        statusMessage = 'I heard the word "$target"!';
        tutorMessage = isChild
            ? 'You said $target! That is worth celebrating!'
            : 'I recognized the target word, $target. Let’s record your attempt.';
      });

      _askForSelfConfirmation();
    } else {
      setState(() {
        statusMessage = heard.isEmpty
            ? 'I did not catch that. Try again when you are ready.'
            : 'I heard "$heard". Let’s practice the word together.';

        tutorMessage = isChild
            ? 'That’s okay! Reading takes practice. Let’s break it into sounds.'
            : 'That attempt was not clearly recognized. We can try again or use the sound guide.';
      });

      _speak(tutorMessage);
    }
  }

  Future<void> _askForSelfConfirmation() async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('How did you read it?'),
          content: const Text(
            'Did you work out the word on your own, or did you use the sound guide?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('I used the sound guide'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('I read it on my own'),
            ),
          ],
        );
      },
    );

    if (!mounted || answer == null) {
      if (mounted) {
        setState(() {
          lessonSessionHandled = false;
          statusMessage = 'Choose how you would like to continue.';
        });
      }
      return;
    }

    _awardWord(independent: answer);
  }

  Future<void> _awardWord({required bool independent}) async {
    if (wordRewarded) return;

    final List<String> praise = independent
        ? (isChild
            ? [
                'Fantastic reading! You figured that one out!',
                'Word wizard! You read it on your own!',
                'Look at you go! That was independent reading!',
                'Brilliant effort! Your reading brain is growing!',
              ]
            : [
                'Well done. You decoded that word independently.',
                'Strong work. You read that word without the guide.',
                'Good progress. That was an independent reading attempt.',
              ])
        : (isChild
            ? [
                'Great effort! Practicing the sounds is how readers grow!',
                'You stuck with it! That deserves a star!',
                'Nice work using your reading tools!',
              ]
            : [
                'Good work using the sound guide.',
                'You completed a supported practice attempt.',
                'That is useful practice. Keep building on it.',
              ]);

    setState(() {
      wordRewarded = true;
      wordsPracticed++;

      rewardMessage = praise[random.nextInt(praise.length)];

      if (independent) {
        independentReads++;
        currentStreak++;
        stars += 3;

        if (currentStreak % 3 == 0) {
          stars += 2;
          rewardMessage += isChild
              ? ' Three independent reads in a row! Bonus stars!'
              : ' Three independent reads in a row. A bonus has been added.';
        }
      } else {
        supportedAttempts++;
        currentStreak = 0;
        stars += 1;
      }

      statusMessage = rewardMessage;
    });

    await _saveProgress();
    await _speak(rewardMessage);
  }

  Future<void> _startGuidedHelp() async {
    if (wordRewarded) return;

    setState(() {
      guidedStep = 0;
      guidedPracticeStarted = true;
      tutorMessage = 'Let’s take this word one sound at a time.';
      statusMessage = 'Sound 1 of ${currentWord.sounds.length}';
      lessonSessionHandled = true;
    });

    await _speak(tutorMessage);
    if (!mounted) return;

    await _speakCurrentSound();
  }

  String _soundHint(String letter) {
    switch (letter.toLowerCase()) {
      case 'a':
        return 'Short a, as in apple.';
      case 'e':
        return 'Short e, as in egg.';
      case 'i':
        return 'Short i, as in insect.';
      case 'o':
        return 'Short o, as in octopus.';
      case 'u':
        return 'Short u, as in umbrella.';
      case 'c':
        return 'The c in cat makes a k sound.';
      case 'g':
        return 'The g in this word makes a hard g sound.';
      case 's':
        return 'The s sound is a quiet snake sound.';
      case 'm':
        return 'The m sound starts with your lips together.';
      case 't':
        return 'The t sound is a quick tap sound.';
      case 'p':
        return 'The p sound is a little puff of air.';
      case 'b':
        return 'The b sound starts with your lips together.';
      case 'd':
        return 'The d sound is a quick tongue tap.';
      case 'h':
        return 'The h sound is a gentle breath.';
      case 'l':
        return 'The l sound starts with your tongue near your top teeth.';
      case 'n':
        return 'The n sound is made with your tongue near your top teeth.';
      default:
        return 'Listen to the sound and try saying it.';
    }
  }

  Future<void> _speakCurrentSound() async {
    if (!mounted || wordRewarded) return;

    if (guidedStep >= currentWord.sounds.length) {
      setState(() {
        tutorMessage = 'Now blend the sounds together to make the whole word.';
        statusMessage = 'Blend: ${currentWord.sounds.join('  ')}';
      });

      await _speak(
        'Now blend the sounds together. ${currentWord.sounds.join(', ')}. '
        'What word do they make?',
      );
      return;
    }

    final letter = currentWord.sounds[guidedStep];
    final hint = _soundHint(letter);

    setState(() {
      tutorMessage = hint;
      statusMessage =
          'Sound ${guidedStep + 1} of ${currentWord.sounds.length}: $letter';
    });

    await _speak('$letter. $hint');
  }

  Future<void> _advanceGuidedStep() async {
    if (wordRewarded) return;

    if (guidedStep < currentWord.sounds.length) {
      setState(() => guidedStep++);
      await _speakCurrentSound();
      return;
    }

    setState(() {
      tutorMessage = 'You practiced the sounds and blending. How did it go?';
      statusMessage = 'You completed the guided practice.';
    });

    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('How did that feel?'),
          content: const Text(
            'Did you try blending the sounds into the whole word?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('I want to practice again'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes, I tried it!'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (answer == true) {
      await _awardWord(independent: false);
    } else {
      setState(() {
        guidedStep = 0;
        statusMessage = 'No rush. Let’s try those sounds again.';
      });

      await _speak('No rush. We can practice those sounds again.');
    }
  }

  Future<void> _submitEmergencyTyping() async {
    final typed = emergencyController.text.trim();
    if (typed.isEmpty) return;

    recognizedWords = typed;
    lessonSessionHandled = false;
    FocusScope.of(context).unfocus();

    setState(() {
      emergencyText = typed;
      statusMessage = 'Checking your backup response...';
    });

    _evaluateLessonSpeech();
  }

  Future<void> _newWord() async {
    evaluationTimer?.cancel();

    if (isListening) {
      await lessonSpeech.stop();
    }

    setState(() {
      wordIndex = (wordIndex + 1) % wordBank.length;
      guidedStep = 0;
      guidedPracticeStarted = false;
      isListening = false;
      wordRewarded = false;
      lessonSessionHandled = false;
      recognizedWords = '';
      emergencyText = '';
      emergencyController.clear();
      rewardMessage = '';
      showEmergencyTyping = !speechAvailable;
      tutorMessage = 'Let’s meet a new word!';
      statusMessage = 'Tap the microphone and read the new word aloud.';
    });

    await _speak('Your next word is ${currentWord.word}.');
  }

  Future<void> _openReadingLounge() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TutorChatScreen(
          learnerType: widget.learnerType,
          tutorVoice: widget.tutorVoice,
        ),
      ),
    );
  }

  @override
  void dispose() {
    evaluationTimer?.cancel();
    lessonSpeech.stop();
    lessonTts.stop();
    emergencyController.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final word = currentWord;
    final soundPracticeFinished =
        guidedStep >= word.sounds.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Practice'),
        actions: [
          IconButton(
            tooltip: 'Reading Lounge',
            onPressed: _openReadingLounge,
            icon: const Icon(Icons.forum_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your reading progress',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$stars',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _StatLine(
                        label: 'Words practiced',
                        value: wordsPracticed,
                      ),
                      _StatLine(
                        label: 'Independent reads',
                        value: independentReads,
                      ),
                      _StatLine(
                        label: 'Guided practices',
                        value: supportedAttempts,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stars reflect your practice choices and self-reported reading, not an automatic reading test.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isChild
                    ? 'Today’s word adventure!'
                    : 'Today’s practice word',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF302A58),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        word.word,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 5,
                          color: Color(0xFF302A58),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        word.meaning,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        children: List.generate(
                          word.sounds.length,
                          (index) {
                            final sound = word.sounds[index];
                            final isVowel = 'aeiou'.contains(sound);
                            final isCurrent =
                                guidedPracticeStarted &&
                                guidedStep == index &&
                                !wordRewarded;

                            return Container(
                              width: 58,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? Colors.amber.shade100
                                    : isVowel
                                        ? Colors.lightBlue.shade100
                                        : Colors.red.shade100,
                                borderRadius:
                                    BorderRadius.circular(14),
                                border: Border.all(
                                  color: isCurrent
                                      ? Colors.orange
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                sound,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Consonants are red. Vowels are blue.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Your tutor says:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tutorMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: isSpeaking
                            ? _stopSpeaking
                            : () => _speak(tutorMessage),
                        icon: Icon(
                          isSpeaking
                              ? Icons.stop_rounded
                              : Icons.volume_up_rounded,
                        ),
                        label: Text(
                          isSpeaking
                              ? 'Stop tutor voice'
                              : 'Hear that again',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: progressLoaded && !wordRewarded
                    ? _toggleLessonMicrophone
                    : null,
                icon: Icon(
                  isListening
                      ? Icons.stop_circle
                      : Icons.mic_rounded,
                ),
                label: Text(
                  isListening
                      ? 'Stop listening'
                      : 'Tap to read aloud',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              if (isListening) ...[
                const SizedBox(height: 8),
                const Center(
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The microphone is listening. Tap Stop listening when you are finished.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
              if (showEmergencyTyping && !wordRewarded) ...[
                const SizedBox(height: 18),
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Microphone backup',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'This is only a backup if speech recognition is unavailable. You can retry the microphone after checking its permission.',
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: emergencyController,
                          onChanged: (value) {
                            emergencyText = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type the word as a backup',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.tonal(
                          onPressed: _submitEmergencyTyping,
                          child: const Text(
                            'Submit backup response',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _initializeSpeech();
                            if (!mounted) return;

                            setState(() {
                              showEmergencyTyping =
                                  !speechAvailable;
                              statusMessage = speechAvailable
                                  ? 'Microphone ready. Tap to try again.'
                                  : 'Speech recognition is still unavailable.';
                            });
                          },
                          child: const Text('Retry microphone'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: wordRewarded
                    ? null
                    : _startGuidedHelp,
                icon: const Icon(
                  Icons.lightbulb_outline_rounded,
                ),
                label: const Text('Help me sound it out'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              if (guidedPracticeStarted &&
                  !wordRewarded) ...[
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          soundPracticeFinished
                              ? 'Now blend the sounds!'
                              : 'Sound ${guidedStep + 1} of ${word.sounds.length}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          soundPracticeFinished
                              ? word.sounds.join('  +  ')
                              : '${word.sounds[guidedStep]}  •  ${_soundHint(word.sounds[guidedStep])}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _speakCurrentSound,
                          icon: const Icon(
                            Icons.volume_up_rounded,
                          ),
                          label: const Text(
                            'Hear this sound again',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: _advanceGuidedStep,
                          child: Text(
                            soundPracticeFinished
                                ? 'I tried blending the word!'
                                : 'I tried it! Next sound',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (wordRewarded) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.celebration_rounded,
                          size: 48,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          rewardMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _newWord,
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                          ),
                          label: const Text('Try another word'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: _openReadingLounge,
                icon: const Icon(Icons.forum_rounded),
                label: const Text('Visit the Reading Lounge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorChatScreen extends StatefulWidget {
  final String learnerType;
  final String tutorVoice;

  const TutorChatScreen({
    super.key,
    required this.learnerType,
    required this.tutorVoice,
  });

  @override
  State<TutorChatScreen> createState() =>
      _TutorChatScreenState();
}

class _TutorChatScreenState extends State<TutorChatScreen> {
  final stt.SpeechToText chatSpeech = stt.SpeechToText();
  final FlutterTts chatTts = FlutterTts();
  final TextEditingController messageController =
      TextEditingController();

  final List<Map<String, String>> messages = [
    {
      'speaker': 'Tutor',
      'message':
          'Welcome to the Reading Lounge! What would you like to talk about?',
    },
  ];

  bool chatSpeechAvailable = false;
  bool isListening = false;
  bool isSpeaking = false;
  bool chatSessionHandled = false;

  String heardWords = '';
  String statusMessage = 'Tap the microphone to talk.';

  bool get isChild => widget.learnerType == 'Child';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await chatTts.setLanguage('en-US');
      await chatTts.setSpeechRate(isChild ? 0.43 : 0.48);
      await chatTts.setPitch(isChild ? 1.12 : 1.0);
      await chatTts.setVolume(1.0);
      await chatTts.awaitSpeakCompletion(true);

      chatSpeechAvailable = await chatSpeech.initialize(
        onStatus: (status) {
          if (!mounted) return;

          if (status == 'notListening' && isListening) {
            setState(() => isListening = false);

            if (heardWords.trim().isNotEmpty) {
              _processSpokenMessage();
            }
          }
        },
        onError: (error) {
          if (!mounted) return;

          setState(() {
            isListening = false;
            statusMessage = 'Microphone issue: ${error.errorMsg}';
          });
        },
      );
    } catch (_) {
      chatSpeechAvailable = false;
    }

    if (mounted) {
      setState(() {
        if (!chatSpeechAvailable) {
          statusMessage =
              'Speech recognition is unavailable on this device.';
        }
      });
    }

    await _speak(
      isChild
          ? 'Hey there! Welcome to the Reading Lounge. Let’s chat!'
          : 'Welcome to the Reading Lounge. What would you like to discuss?',
    );
  }

  Future<void> _speak(String message) async {
    try {
      await chatTts.stop();
      if (!mounted) return;

      setState(() => isSpeaking = true);
      await chatTts.speak(message);
    } catch (_) {
      // Written replies remain visible if speech output is unavailable.
    } finally {
      if (mounted) setState(() => isSpeaking = false);
    }
  }

  Future<void> _toggleChatMicrophone() async {
    if (isListening) {
      await chatSpeech.stop();
      if (!mounted) return;

      setState(() => isListening = false);

      if (heardWords.trim().isNotEmpty) {
        _processSpokenMessage();
      }
      return;
    }

    if (!chatSpeechAvailable) {
      setState(() {
        statusMessage =
            'Speech recognition is unavailable. Check microphone permission.';
      });
      return;
    }

    chatSessionHandled = false;
    heardWords = '';

    setState(() {
      isListening = true;
      statusMessage = 'Listening...';
    });

    try {
      await chatSpeech.listen(
        onResult: (result) {
          if (!mounted) return;

          heardWords = result.recognizedWords;

          setState(() {
            statusMessage = heardWords.isEmpty
                ? 'Listening...'
                : 'I heard: "$heardWords"';
          });

          if (result.finalResult) {
            setState(() => isListening = false);
            _processSpokenMessage();
          }
        },
        listenFor: const Duration(seconds: 90),
        pauseFor: const Duration(seconds: 15),
        partialResults: true,
        cancelOnError: false,
        localeId: 'en_US',
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isListening = false;
        statusMessage =
            'I could not start the microphone. Try again.';
      });
    }
  }

  void _processSpokenMessage() {
    if (chatSessionHandled) return;

    chatSessionHandled = true;

    final message = heardWords.trim();
    if (message.isEmpty) return;

    _sendMessage(message);
  }

  void _sendTypedMessage() {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    messageController.clear();
    _sendMessage(message);
  }

  void _sendMessage(String message) {
    final reply = _makeReply(message);

    setState(() {
      messages.add({
        'speaker': 'You',
        'message': message,
      });

      messages.add({
        'speaker': 'Tutor',
        'message': reply,
      });

      statusMessage =
          'You can tap the microphone to say something else.';
    });

    _speak(reply);
  }

  String _makeReply(String message) {
    final text = message.toLowerCase();

    if (text.contains('help') || text.contains('hard')) {
      return isChild
          ? 'That’s okay! We can slow down and take it one little step at a time. Which word are you working on?'
          : 'That is understandable. We can slow down, break the word into smaller parts, and work through it together.';
    }

    if (text.contains('book') || text.contains('story')) {
      return isChild
          ? 'Stories are full of adventures! We can talk about characters, places, and what might happen next. What kind of story do you like?'
          : 'Stories are a great way to build reading confidence. What genres or topics do you enjoy?';
    }

    if (text.contains('hello') || text.contains('hi')) {
      return isChild
          ? 'Hello, reading superstar! What shall we explore today?'
          : 'Hello! It is good to have you here. What would you like to practice?';
    }

    if (text.contains('thank')) {
      return isChild
          ? 'You are very welcome! Every bit of practice counts.'
          : 'You are welcome. Keep going at a pace that works for you.';
    }

    return isChild
        ? 'That sounds interesting! Tell me a little more. I am listening!'
        : 'Thanks for sharing that. Tell me a little more, and we can explore it together.';
  }

  @override
  void dispose() {
    chatSpeech.stop();
    chatTts.stop();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Lounge'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final item = messages[index];
                  final isUser = item['speaker'] == 'You';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 310,
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color(0xFFE6E1FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['speaker'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['message'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  Text(
                    statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendTypedMessage(),
                          decoration: const InputDecoration(
                            hintText: 'Write a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _sendTypedMessage,
                        icon: const Icon(Icons.send_rounded),
                        tooltip: 'Send message',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: chatSpeechAvailable
                          ? _toggleChatMicrophone
                          : null,
                      icon: Icon(
                        isListening
                            ? Icons.stop_circle
                            : Icons.mic_rounded,
                      ),
                      label: Text(
                        isListening
                            ? 'Stop listening'
                            : 'Talk to your tutor',
                      ),
                    ),
                  ),
                  if (isSpeaking)
                    TextButton.icon(
                      onPressed: () async {
                        await chatTts.stop();

                        if (mounted) {
                          setState(() => isSpeaking = false);
                        }
                      },
                      icon: const Icon(Icons.stop_rounded),
                      label: const Text('Stop tutor voice'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final int value;

  const _StatLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '$value',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
