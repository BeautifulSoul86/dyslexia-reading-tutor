import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' as stt_result;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DyslexiaTutorApp());
}

const Color ink = Color(0xFF243247);
const Color coral = Color(0xFFE05252);
const Color blue = Color(0xFF3478D4);
const Color mint = Color(0xFF2F9B78);
const Color cream = Color(0xFFFFFBF4);
const Color gold = Color(0xFFE0A526);

class DyslexiaTutorApp extends StatelessWidget {
  const DyslexiaTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyslexia Reading Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: ink,
            fontWeight: FontWeight.w800,
          ),
          titleLarge: TextStyle(
            color: ink,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(color: ink, height: 1.4),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFE8EAF0)),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String learnerType = 'Child';
  String avatarStyle = 'Cartoon';
  String tutorVoice = 'Bright and energetic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 18),
            Container(
              height: 86,
              width: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFE9EFFB),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 48,
                color: blue,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Dyslexia Reading Tutor',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w900,
                color: ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A patient reading coach that helps you learn one sound and one word at a time.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF667085),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 26),
            const SectionTitle('Who is learning today?'),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Child',
                  label: Text('Child'),
                  icon: Icon(Icons.child_care),
                ),
                ButtonSegment(
                  value: 'Adult',
                  label: Text('Adult'),
                  icon: Icon(Icons.person),
                ),
              ],
              selected: {learnerType},
              onSelectionChanged: (values) {
                setState(() => learnerType = values.first);
              },
            ),
            const SizedBox(height: 22),
            const SectionTitle('Choose your tutor appearance'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('Cartoon teacher'),
                  avatar: const Icon(Icons.smart_toy_outlined),
                  selected: avatarStyle == 'Cartoon',
                  onSelected: (_) {
                    setState(() => avatarStyle = 'Cartoon');
                  },
                ),
                ChoiceChip(
                  label: const Text('Realistic teacher'),
                  avatar: const Icon(Icons.face_retouching_natural),
                  selected: avatarStyle == 'Realistic',
                  onSelected: (_) {
                    setState(() => avatarStyle = 'Realistic');
                  },
                ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionTitle('Choose a tutor voice style'),
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
                  value: 'Bright and energetic',
                  child: Text('Bright and energetic'),
                ),
                DropdownMenuItem(
                  value: 'Playful and enthusiastic',
                  child: Text('Playful and enthusiastic'),
                ),
                DropdownMenuItem(
                  value: 'Calm and gentle',
                  child: Text('Calm and gentle'),
                ),
                DropdownMenuItem(
                  value: 'Mature and conversational',
                  child: Text('Mature and conversational'),
                ),
              ],
              onChanged: (value) {
                setState(() => tutorVoice = value ?? tutorVoice);
              },
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      learnerType: learnerType,
                      avatarStyle: avatarStyle,
                      tutorVoice: tutorVoice,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Meet my reading tutor',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Practice with voice guidance, interactive sound lessons, and rewards. Live AI conversation and phoneme-level speech assessment are not connected yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7A8494),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonWord {
  final String word;
  final String focus;
  final String hint;

  const LessonWord(this.word, this.focus, this.hint);
}

const List<LessonWord> wordBank = [
  LessonWord('cat', 'short a', 'Listen for the middle vowel sound.'),
  LessonWord('map', 'short a', 'Say each sound, then blend them smoothly.'),
  LessonWord('sun', 'short u', 'Keep the vowel short and clear.'),
  LessonWord('bed', 'short e', 'Notice the middle vowel sound.'),
  LessonWord('sit', 'short i', 'Listen carefully to the vowel.'),
  LessonWord('hop', 'short o', 'Keep the vowel sound brief.'),
  LessonWord('lip', 'short i', 'Touch each sound, then blend.'),
  LessonWord('mug', 'short u', 'Say the first, middle, and final sounds.'),
  LessonWord('pet', 'short e', 'Listen for the vowel in the middle.'),
  LessonWord('dot', 'short o', 'Blend all three sounds together.'),
];

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
  final Random random = Random();

  List<LessonWord> queue = [];
  LessonWord? current;

  String tutorMessage = '';
  String status = 'start';
  String recognizedWords = '';
  String speechProblem = '';
  String rewardMessage = '';

  int stars = 0;
  int independentReads = 0;
  int supportedAttempts = 0;
  int wordsPracticed = 0;
  int currentStreak = 0;

  int guidedStep = 0;

  bool showSoundBreakdown = false;
  bool speechAvailable = false;
  bool lessonVoiceReady = false;
  bool isListening = false;
  bool lessonSessionHandled = true;
  bool showEmergencyTyping = false;
  bool wordRewarded = false;
  bool guidedMode = false;
  bool awaitingIndependentConfirmation = false;
  bool showCelebration = false;

  Timer? lessonEvaluationTimer;

  final stt.SpeechToText lessonSpeech = stt.SpeechToText();
  final FlutterTts lessonTts = FlutterTts();

  final TextEditingController emergencyController =
      TextEditingController();

  bool get isChild => widget.learnerType == 'Child';

  List<String> get sounds => (current?.word ?? '').split('');

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _configureLessonVoice();
    _newWord(first: true);
  }
    Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      stars = prefs.getInt('stars') ?? 0;
      independentReads = prefs.getInt('independentReads') ?? 0;
      supportedAttempts = prefs.getInt('supportedAttempts') ?? 0;
      wordsPracticed = prefs.getInt('wordsPracticed') ?? 0;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('stars', stars);
    await prefs.setInt('independentReads', independentReads);
    await prefs.setInt('supportedAttempts', supportedAttempts);
    await prefs.setInt('wordsPracticed', wordsPracticed);
  }

  Future<void> _configureLessonVoice() async {
    try {
      await lessonTts.setLanguage('en-US');
      await lessonTts.setSpeechRate(isChild ? 0.43 : 0.48);
      await lessonTts.setPitch(isChild ? 1.12 : 1.0);
      await lessonTts.awaitSpeakCompletion(true);

      if (mounted) {
        setState(() => lessonVoiceReady = true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => lessonVoiceReady = false);
      }
    }
  }

  Future<void> _speak(String message) async {
    try {
      await lessonTts.stop();
      await lessonTts.speak(message);
    } catch (_) {
      // The on-screen instructions remain available if speech fails.
    }
  }

  void _newWord({bool first = false}) {
    lessonEvaluationTimer?.cancel();

    if (queue.isEmpty) {
      queue = List<LessonWord>.from(wordBank)..shuffle(random);
    }

    final next = queue.removeAt(0);

    setState(() {
      current = next;
      status = 'start';
      recognizedWords = '';
      speechProblem = '';
      rewardMessage = '';
      guidedStep = 0;

      showSoundBreakdown = false;
      guidedMode = false;
      awaitingIndependentConfirmation = false;
      showCelebration = false;
      wordRewarded = false;
      showEmergencyTyping = false;

      lessonSessionHandled = true;
      isListening = false;

      tutorMessage = first
          ? 'Welcome! Let’s warm up with a word. You can take your time. I’m here to help!'
          : 'Here comes your next word! Let’s see what sounds you notice.';
    });

    _speak(tutorMessage);
  }

  Future<void> _initializeSpeech() async {
    try {
      speechAvailable = await lessonSpeech.initialize(
        onStatus: (value) {
          if (!mounted) return;

          if (value == 'notListening' && isListening) {
            setState(() => isListening = false);
            _scheduleLessonEvaluation();
          }
        },
        onError: (error) {
          if (!mounted) return;

          setState(() {
            isListening = false;
            speechProblem = 'I had trouble hearing that. Let’s try again.';
          });

          if (recognizedWords.trim().isNotEmpty) {
            _scheduleLessonEvaluation();
          }
        },
        debugLogging: false,
      );

      if (mounted) {
        setState(() {
          if (!speechAvailable) {
            speechProblem =
                'Speech recognition is not available right now. You can try again or use the backup option.';
          }
        });
      }
    } catch (_) {
      speechAvailable = false;

      if (mounted) {
        setState(() {
          speechProblem =
              'The microphone could not start. Please check microphone permission.';
        });
      }
    }
  }

  Future<void> _toggleLessonMicrophone() async {
    if (isListening) {
      await lessonSpeech.stop();

      if (!mounted) return;

      setState(() => isListening = false);

      if (recognizedWords.trim().isNotEmpty) {
        _scheduleLessonEvaluation();
      } else {
        setState(() {
          speechProblem =
              'I didn’t catch anything that time. Tap the microphone and try again.';
        });
      }

      return;
    }

    if (!speechAvailable) {
      await _initializeSpeech();
    }

    if (!speechAvailable) {
      if (!mounted) return;

      setState(() {
        speechProblem =
            'Your microphone is not ready. Check permission or try again.';
        showEmergencyTyping = true;
      });

      return;
    }

    lessonEvaluationTimer?.cancel();

    setState(() {
      recognizedWords = '';
      speechProblem = '';
      status = 'listening';
      isListening = true;
      lessonSessionHandled = false;
      showEmergencyTyping = false;
    });

    try {
      await lessonSpeech.listen(
        onResult: _onLessonSpeechResult,
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
        speechProblem =
            'The microphone stopped unexpectedly. Please try again.';
        showEmergencyTyping = true;
      });
    }
  }

  void _onLessonSpeechResult(stt_result.SpeechRecognitionResult result) {
    if (!mounted) return;

    setState(() {
      recognizedWords = result.recognizedWords;
    });

    if (result.finalResult) {
      setState(() => isListening = false);
      _scheduleLessonEvaluation();
    }
  }

  void _scheduleLessonEvaluation() {
    lessonEvaluationTimer?.cancel();

    if (recognizedWords.trim().isEmpty || lessonSessionHandled) {
      return;
    }

    lessonEvaluationTimer = Timer(
      const Duration(milliseconds: 700),
      _evaluateLessonSpeech,
    );
  }

  void _evaluateLessonSpeech() {
    if (!mounted || lessonSessionHandled) return;

    lessonSessionHandled = true;

    final heard = recognizedWords.toLowerCase().trim();
    final target = current?.word.toLowerCase() ?? '';

    final words = heard
        .replaceAll(RegExp(r'[^a-z\s]'), '')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    final heardTarget = words.contains(target);

    setState(() {
      isListening = false;
      wordsPracticed++;
      status = 'evaluated';
    });

    _saveProgress();

    if (heardTarget) {
      setState(() {
        awaitingIndependentConfirmation = true;
        tutorMessage =
            'I heard "$target"! That’s exciting. Did you read it all by yourself, or would you like me to help you work through the sounds?';
      });

      _speak(tutorMessage);
    } else {
      setState(() {
        speechProblem = '';
        tutorMessage =
            'Thanks for giving that a try! I heard "$heard". Let’s look at the sounds together. There’s no rush.';
      });

      _speak(tutorMessage);
    }
  }

  void _confirmIndependentReading() {
    if (wordRewarded) return;

    setState(() {
      independentReads++;
      currentStreak++;
      stars += 3;
      wordRewarded = true;
      awaitingIndependentConfirmation = false;
      showCelebration = true;
      status = 'complete';

      rewardMessage = isChild
          ? 'THREE STARS! You read that word independently! You are building a brilliant reading brain!'
          : 'Three stars earned. You read that word independently. That is real progress.';
      tutorMessage = rewardMessage;
    });

    _saveProgress();
    _speak(rewardMessage);
  }

  void _startGuidedHelp() {
    if (wordRewarded) return;

    setState(() {
      guidedMode = true;
      awaitingIndependentConfirmation = false;
      guidedStep = 0;
      showCelebration = false;
      status = 'guided';
      tutorMessage =
          'You got it. We’ll take this word apart together. First, let’s look at the beginning sound.';
    });

    _speak(tutorMessage);
    _speakCurrentSound();
  }

  String _soundDescription(String letter) {
    switch (letter.toLowerCase()) {
      case 'a':
        return 'the short a sound, like the middle sound in apple';
      case 'e':
        return 'the short e sound, like the middle sound in egg';
      case 'i':
        return 'the short i sound, like the middle sound in insect';
      case 'o':
        return 'the short o sound, like the middle sound in octopus';
      case 'u':
        return 'the short u sound, like the middle sound in umbrella';
      case 'c':
        return 'the k sound, like the beginning of cat';
      case 'g':
        return 'the hard g sound, like the beginning of goat';
      case 'm':
        return 'mmm, the sound you hear at the beginning of moon';
      case 's':
        return 'sss, the sound you hear at the beginning of sun';
      case 't':
        return 't, the quick sound at the beginning of top';
      case 'p':
        return 'p, the quick sound at the beginning of pig';
      case 'b':
        return 'b, the sound at the beginning of ball';
      case 'd':
        return 'd, the sound at the beginning of dog';
      case 'h':
        return 'h, the breathy sound at the beginning of hat';
      case 'n':
        return 'nnn, the sound at the beginning of nest';
      case 'l':
        return 'lll, the sound at the beginning of leaf';
      case 'r':
        return 'rrr, the sound at the beginning of rabbit';
      default:
        return 'the sound this letter makes';
    }
  }

  Future<void> _speakCurrentSound() async {
    if (current == null || guidedStep >= sounds.length) return;

    final letter = sounds[guidedStep];
    final description = _soundDescription(letter);

    final message =
        'Look at this letter: $letter. It makes $description. Listen: $letter. Now you try saying that sound out loud.';

    setState(() {
      tutorMessage = message;
    });

    await _speak(message);
  }

  void _repeatCurrentSound() {
    _speakCurrentSound();
  }

  void _advanceGuidedStep() {
    if (current == null) return;

    if (guidedStep < sounds.length - 1) {
      setState(() {
        guidedStep++;
        tutorMessage =
            'Great effort! Now let’s look at the next sound. Take your time.';
      });

      _speak(tutorMessage);
      _speakCurrentSound();
    } else {
      setState(() {
        guidedStep = sounds.length;
        tutorMessage =
            'You worked through every sound! Now let’s slide them together. Listen: ${sounds.join(' ... ')}. Now blend those sounds into one word: ${current!.word}.';
      });

      _speak(tutorMessage);
    }
  }

  void _completeGuidedWord() {
    if (wordRewarded || current == null) return;

    setState(() {
      supportedAttempts++;
      currentStreak = 0;
      stars += 1;
      wordRewarded = true;
      guidedMode = false;
      showCelebration = true;
      status = 'complete';

      rewardMessage = isChild
          ? 'ONE STAR! You worked through every sound and blended the word. That took determination!'
          : 'One star earned for completing the word with guided support. Every step counts.';
      tutorMessage = rewardMessage;
    });

    _saveProgress();
    _speak(rewardMessage);
  }

  void _submitEmergencyTyping() {
    final typed = emergencyController.text.trim();

    if (typed.isEmpty || current == null) return;

    setState(() {
      recognizedWords = typed;
      showEmergencyTyping = false;
      speechProblem = '';
      lessonSessionHandled = false;
    });

    emergencyController.clear();
    _evaluateLessonSpeech();
  }

  void _goToNextWord() {
    if (!wordRewarded) {
      _startGuidedHelp();
      return;
    }

    _newWord();
  }

  @override
  void dispose() {
    lessonEvaluationTimer?.cancel();
    lessonSpeech.stop();
    lessonTts.stop();
    emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = current?.word ?? 'cat';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Lesson'),
        backgroundColor: cream,
        actions: [
          IconButton(
            tooltip: 'Reading lounge',
            icon: const Icon(Icons.forum_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TutorChatScreen(
                    learnerType: widget.learnerType,
                    tutorVoice: widget.tutorVoice,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatLine(
                    icon: Icons.star_rounded,
                    label: '$stars stars',
                    color: gold,
                  ),
                ),
                Expanded(
                  child: _StatLine(
                    icon: Icons.local_fire_department_rounded,
                    label: '$currentStreak streak',
                    color: coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Today’s reading mission'),
                    const SizedBox(height: 8),
                    Text(
                      isChild
                          ? 'Let’s be sound detectives! We’ll find each sound and put them together.'
                          : 'Work through each sound at your own pace. You can practice independently or use guided support.',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: Text('$independentReads independent'),
                        ),
                        Chip(
                          avatar: const Icon(
                            Icons.lightbulb_outline,
                            size: 18,
                          ),
                          label: Text('$supportedAttempts guided'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'YOUR WORD',
                      style: TextStyle(
                        color: Colors.blueGrey.shade500,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < word.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              word[i].toUpperCase(),
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w900,
                                color: 'aeiou'.contains(word[i])
                                    ? blue
                                    : coral,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      current?.focus ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF667085),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      current?.hint ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE9EFFB),
                          child: Icon(
                            Icons.record_voice_over_rounded,
                            color: blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.avatarStyle == 'Cartoon'
                                ? 'Your reading buddy'
                                : 'Your reading coach',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Hear tutor again',
                          onPressed: () => _speak(tutorMessage),
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tutorMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    if (recognizedWords.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'I heard: "$recognizedWords"',
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (awaitingIndependentConfirmation) ...[
              Card(
                color: const Color(0xFFEAF6EF),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'How did you read it?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: mint,
                            minimumSize: const Size.fromHeight(52),
                          ),
                          onPressed: _confirmIndependentReading,
                          icon: const Icon(Icons.star_rounded),
                          label: const Text('I read it by myself!'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _startGuidedHelp,
                          icon: const Icon(Icons.lightbulb_outline),
                          label: const Text('Help me with the sounds'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (guidedMode) ...[
              Card(
                color: const Color(0xFFFFF6E4),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        guidedStep < sounds.length
                            ? 'Sound ${guidedStep + 1} of ${sounds.length}'
                            : 'Now blend the sounds!',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (guidedStep < sounds.length) ...[
                        Text(
                          sounds[guidedStep].toUpperCase(),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: 'aeiou'.contains(sounds[guidedStep])
                                ? blue
                                : coral,
                          ),
                        ),
                        Text(
                          _soundDescription(sounds[guidedStep]),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _repeatCurrentSound,
                            icon: const Icon(Icons.volume_up),
                            label: const Text('Hear this sound again'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _advanceGuidedStep,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('I tried it! Next sound'),
                          ),
                        ),
                      ] else ...[
                        Text(
                          sounds.join('  •  '),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Slide the sounds together to say "$word".',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _completeGuidedWord,
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('I blended the word!'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else if (showCelebration) ...[
              Card(
                color: const Color(0xFFFFF4D6),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        '🎉 ⭐ 🎉',
                        style: TextStyle(fontSize: 36),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rewardMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        wordRewarded
                            ? 'Your star total: $stars'
                            : '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _goToNextWord,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next word!'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    backgroundColor: isListening ? coral : blue,
                  ),
                  onPressed: _toggleLessonMicrophone,
                  icon: Icon(
                    isListening ? Icons.stop_circle : Icons.mic,
                  ),
                  label: Text(
                    isListening
                        ? 'Tap to stop listening'
                        : 'Tap to read the word aloud',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isListening) ...[
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.graphic_eq, color: coral),
                    SizedBox(width: 8),
                    Text('Listening... Take your time.'),
                  ],
                ),
              ],
              if (speechProblem.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  speechProblem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: coral),
                ),
              ],
              if (showEmergencyTyping) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: emergencyController,
                  decoration: const InputDecoration(
                    labelText: 'Backup answer',
                    hintText: 'Type the word only if voice is unavailable',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _submitEmergencyTyping(),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _submitEmergencyTyping,
                  child: const Text('Submit backup answer'),
                ),
              ],
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _startGuidedHelp,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('I need help with this word'),
              ),
            ],
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Your reading progress'),
                    const SizedBox(height: 12),
                    _StatLine(
                      icon: Icons.menu_book_rounded,
                      label: '$wordsPracticed practice attempts',
                      color: blue,
                    ),
                    _StatLine(
                      icon: Icons.emoji_events_outlined,
                      label: '$independentReads independent reads',
                      color: gold,
                    ),
                    _StatLine(
                      icon: Icons.lightbulb_outline,
                      label: '$supportedAttempts guided completions',
                      color: mint,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
  State<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends State<TutorChatScreen> {
  final stt.SpeechToText chatSpeech = stt.SpeechToText();
  final FlutterTts chatTts = FlutterTts();
  final TextEditingController backupController = TextEditingController();

  final List<Map<String, String>> messages = [];

  bool speechAvailable = false;
  bool isListening = false;
  bool showBackupTyping = false;
  bool voiceReady = false;

  String heardWords = '';
  String speechProblem = '';

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
      await chatTts.awaitSpeakCompletion(true);

      if (mounted) {
        setState(() => voiceReady = true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => voiceReady = false);
      }
    }

    await _initializeChatSpeech();

    if (!mounted) return;

    if (messages.isEmpty) {
      _addTutorMessage(
        isChild
            ? 'Welcome to the Reading Lounge! We can talk about books, make up silly stories, or practice reading together. What sounds fun?'
            : 'Welcome to the Reading Lounge. We can discuss books, explore new vocabulary, or practice reading at your pace. What would you like to talk about?',
      );
    }
  }

  Future<void> _initializeChatSpeech() async {
    try {
      speechAvailable = await chatSpeech.initialize(
        onStatus: (value) {
          if (!mounted) return;

          if (value == 'notListening' && isListening) {
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
            speechProblem =
                'I had trouble hearing you. Please try the microphone again.';
          });

          if (heardWords.trim().isNotEmpty) {
            _processSpokenMessage();
          }
        },
        debugLogging: false,
      );

      if (mounted && !speechAvailable) {
        setState(() {
          speechProblem =
              'Voice recognition is unavailable. You can try again or use the backup option.';
        });
      }
    } catch (_) {
      speechAvailable = false;

      if (mounted) {
        setState(() {
          speechProblem = 'I could not start the microphone.';
        });
      }
    }
  }

  Future<void> _speak(String text) async {
    try {
      await chatTts.stop();
      await chatTts.speak(text);
    } catch (_) {
      // Text remains visible if the device cannot speak.
    }
  }

  void _addTutorMessage(String text) {
    setState(() {
      messages.add({
        'speaker': 'tutor',
        'text': text,
      });
    });

    _speak(text);
  }

  void _addLearnerMessage(String text) {
    setState(() {
      messages.add({
        'speaker': 'learner',
        'text': text,
      });
    });
  }

  Future<void> _toggleChatMicrophone() async {
    if (isListening) {
      await chatSpeech.stop();

      if (!mounted) return;

      setState(() => isListening = false);

      if (heardWords.trim().isNotEmpty) {
        _processSpokenMessage();
      } else {
        setState(() {
          speechProblem = 'I didn’t catch that. Want to try again?';
        });
      }

      return;
    }

    if (!speechAvailable) {
      await _initializeChatSpeech();
    }

    if (!speechAvailable) {
      if (!mounted) return;

      setState(() {
        speechProblem =
            'Voice recognition is unavailable. You can use the backup option.';
        showBackupTyping = true;
      });

      return;
    }

    setState(() {
      heardWords = '';
      speechProblem = '';
      isListening = true;
      showBackupTyping = false;
    });

    try {
      await chatSpeech.listen(
        onResult: (result) {
          if (!mounted) return;

          setState(() {
            heardWords = result.recognizedWords;
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
        speechProblem = 'The microphone stopped. Please try again.';
        showBackupTyping = true;
      });
    }
  }

  void _processSpokenMessage() {
    final text = heardWords.trim();

    if (text.isEmpty) return;

    heardWords = '';
    _respondToLearner(text);
  }

  void _submitBackupMessage() {
    final text = backupController.text.trim();

    if (text.isEmpty) return;

    backupController.clear();

    setState(() {
      showBackupTyping = false;
      speechProblem = '';
    });

    _respondToLearner(text);
  }

  void _respondToLearner(String text) {
    _addLearnerMessage(text);

    final reply = _makeTutorReply(text);

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _addTutorMessage(reply);
    });
  }

  String _makeTutorReply(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('help') ||
        lower.contains('hard') ||
        lower.contains('stuck')) {
      return isChild
          ? 'I’ve got you! Let’s slow it down. Pick one word, and we’ll look at its sounds one at a time. No rush, sound detective!'
          : 'Let’s take it one step at a time. We can break a difficult word into smaller sound parts and work through it together.';
    }

    if (lower.contains('book') || lower.contains('read')) {
      return isChild
          ? 'Books are full of adventures! What kind of story should we explore: animals, space, mysteries, or something really silly?'
          : 'Reading opens up all kinds of worlds. What genres or subjects do you enjoy? We can explore vocabulary and ideas together.';
    }

    if (lower.contains('thank')) {
      return isChild
          ? 'You’re welcome! I’m glad we’re learning together. Ready for another little reading adventure?'
          : 'You’re welcome. Keep giving yourself credit for the work you’re putting in. Would you like to keep practicing?';
    }

    if (lower.contains('tired') || lower.contains('boring')) {
      return isChild
          ? 'Then let’s shake things up! We can make a silly story, invent a funny character, or take a little break.'
          : 'A change of pace can help. We can switch to a short story, vocabulary game, or a break from structured practice.';
    }

    if (lower.contains('hello') ||
        lower.contains('hi ') ||
        lower == 'hi' ||
        lower == 'hey') {
      return isChild
          ? 'Hey there, superstar! What should we do today: a silly story, a word challenge, or a book adventure?'
          : 'Hello! What would you like to work on today? We can practice reading or just have a conversation.';
    }

    if (lower.contains('story')) {
      return isChild
          ? 'Story time! Once there was a tiny dragon who sneezed bubbles instead of fire. Every time he sneezed, the bubbles made a different sound. What do you think happened next?'
          : 'Let’s build a story together. Imagine a character who discovers something unexpected. What do they find?';
    }

    return isChild
        ? 'That’s interesting! Tell me a little more. I’m listening, and we can turn your idea into a story or a reading adventure!'
        : 'I’m listening. Tell me a little more about that, and we can explore the idea together.';
  }

  @override
  void dispose() {
    chatSpeech.stop();
    chatTts.stop();
    backupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Lounge'),
        backgroundColor: cream,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isTutor = message['speaker'] == 'tutor';

                  return Align(
                    alignment: isTutor
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 310),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isTutor
                            ? Colors.white
                            : const Color(0xFFE9EFFB),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFE5E8EF),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isTutor ? 'Reading buddy' : 'You',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blue,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            message['text'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: ink,
                            ),
                          ),
                          if (isTutor)
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                tooltip: 'Hear this message',
                                visualDensity: VisualDensity.compact,
                                onPressed: () =>
                                    _speak(message['text'] ?? ''),
                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                  color: blue,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (speechProblem.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  speechProblem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: coral),
                ),
              ),
            if (isListening)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Listening... Tap the microphone when you are finished.',
                  style: TextStyle(color: blue),
                ),
              ),
            if (showBackupTyping)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: backupController,
                        decoration: const InputDecoration(
                          hintText: 'Backup message',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _submitBackupMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _submitBackupMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    backgroundColor: isListening ? coral : blue,
                  ),
                  onPressed: _toggleChatMicrophone,
                  icon: Icon(
                    isListening ? Icons.stop_circle : Icons.mic,
                  ),
                  label: Text(
                    isListening
                        ? 'Tap to stop and send'
                        : 'Talk to your reading buddy',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ink,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatLine({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
