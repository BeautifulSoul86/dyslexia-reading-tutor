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

class DyslexiaTutorApp extends StatelessWidget {
  const DyslexiaTutorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Dyslexia Reading Tutor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: cream,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5476B8)),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(color: ink, fontWeight: FontWeight.w800),
            titleLarge: TextStyle(color: ink, fontWeight: FontWeight.w700),
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
              child: const Icon(Icons.menu_book_rounded, size: 48, color: blue),
            ),
            const SizedBox(height: 22),
            const Text('Dyslexia Reading Tutor',
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: ink)),
            const SizedBox(height: 8),
            const Text(
              'A patient reading coach that helps you learn one sound and one word at a time.',
              style: TextStyle(fontSize: 16, color: Color(0xFF667085), height: 1.45),
            ),
            const SizedBox(height: 26),
            const SectionTitle('Who is learning today?'),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Child', label: Text('Child'), icon: Icon(Icons.child_care)),
                ButtonSegment(value: 'Adult', label: Text('Adult'), icon: Icon(Icons.person)),
              ],
              selected: {learnerType},
              onSelectionChanged: (v) => setState(() => learnerType = v.first),
            ),
            const SizedBox(height: 22),
            const SectionTitle('Choose your tutor appearance'),
            const SizedBox(height: 10),
            Wrap(spacing: 10, children: [
              ChoiceChip(
                label: const Text('Cartoon teacher'),
                avatar: const Icon(Icons.smart_toy_outlined),
                selected: avatarStyle == 'Cartoon',
                onSelected: (_) => setState(() => avatarStyle = 'Cartoon'),
              ),
              ChoiceChip(
                label: const Text('Realistic teacher'),
                avatar: const Icon(Icons.face_retouching_natural),
                selected: avatarStyle == 'Realistic',
                onSelected: (_) => setState(() => avatarStyle = 'Realistic'),
              ),
            ]),
            const SizedBox(height: 22),
            const SectionTitle('Choose a tutor voice style'),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: tutorVoice,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
              items: const [
                DropdownMenuItem(value: 'Bright and energetic', child: Text('Bright and energetic')),
                DropdownMenuItem(value: 'Playful and enthusiastic', child: Text('Playful and enthusiastic')),
                DropdownMenuItem(value: 'Calm and gentle', child: Text('Calm and gentle')),
                DropdownMenuItem(value: 'Mature and conversational', child: Text('Mature and conversational')),
              ],
              onChanged: (v) => setState(() => tutorVoice = v ?? tutorVoice),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonScreen(
                    learnerType: learnerType,
                    avatarStyle: avatarStyle,
                    tutorVoice: tutorVoice,
                  ),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Meet my reading tutor',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Preview build: reading practice is interactive. Microphone speech input is being added; live AI conversation and speech-based reading assessment are not connected yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF7A8494)),
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
  int stars = 0;
  int independentReads = 0;
  int supportedAttempts = 0;
  int wordsPracticed = 0;
  bool showSoundBreakdown = false;
  final stt.SpeechToText _lessonSpeech = stt.SpeechToText();
  final FlutterTts _lessonTts = FlutterTts();
  bool _speechAvailable = false;
  bool _lessonVoiceReady = false;
  bool _isListening = false;
  bool _lessonSessionHandled = true;
  bool _lessonEvaluationScheduled = false;
  bool _showEmergencyTyping = false;
  String _recognizedWords = '';
  String _speechProblem = '';
  final TextEditingController _emergencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _configureLessonVoice();
    _newWord(first: true);
  }

  Future<void> _configureLessonVoice() async {
    try {
      await _lessonTts.setLanguage('en-US');
      await _lessonTts.setSpeechRate(widget.learnerType == 'Child' ? 0.43 : 0.48);
      await _lessonTts.setPitch(widget.learnerType == 'Child' ? 1.12 : 1.0);
      await _lessonTts.awaitSpeakCompletion(true);
      _lessonVoiceReady = true;
      final available = await _lessonSpeech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'notListening' || status == 'done') {
            if (_isListening) setState(() => _isListening = false);
            // The plugin can deliver its final recognition result just after
            // this status callback. Wait briefly before evaluating the answer.
            _scheduleLessonEvaluation();
          }
        },
        onError: (error) {
          if (!mounted) return;
          final hasWords = _recognizedWords.trim().isNotEmpty;
          setState(() {
            _isListening = false;
            _speechProblem = hasWords ? '' : error.errorMsg;
            _showEmergencyTyping = !hasWords;
          });
          // Android may report an error after delivering useful partial words.
          // Give any final result callback time to arrive before evaluating.
          if (!_lessonSessionHandled) _scheduleLessonEvaluation();
        },
      );
      if (!mounted) return;
      setState(() {
        _speechAvailable = available;
        if (!available) {
          _speechProblem = 'Speech recognition is not available on this device.';
          _showEmergencyTyping = true;
        }
      });
      if (tutorMessage.isNotEmpty) _speakLessonMessage(tutorMessage);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _speechProblem = 'The microphone or speech service could not start.';
        _showEmergencyTyping = true;
      });
    }
  }

  Future<void> _speakLessonMessage(String message) async {
    if (message.trim().isEmpty || !_lessonVoiceReady) return;
    try {
      if (_isListening) await _lessonSpeech.stop();
      await _lessonTts.stop();
      await _lessonTts.speak(message);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _speechProblem = 'Tutor audio is unavailable right now.';
      });
    }
  }

  Future<void> _toggleLessonMicrophone() async {
    if (_isListening) {
      // Do not evaluate immediately: stop() can trigger the final result
      // callback asynchronously. The scheduler waits for it to arrive.
      await _lessonSpeech.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
      _scheduleLessonEvaluation();
      return;
    }
    if (!_speechAvailable) {
      setState(() {
        _showEmergencyTyping = true;
        _speechProblem = 'The microphone is not available. You can type only as a temporary backup.';
      });
      return;
    }
    await _lessonTts.stop();
    setState(() {
      _recognizedWords = '';
      _speechProblem = '';
      _showEmergencyTyping = false;
      _lessonSessionHandled = false;
      _lessonEvaluationScheduled = false;
      _isListening = true;
    });
    try {
      await _lessonSpeech.listen(
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
        _isListening = false;
        _showEmergencyTyping = true;
        _speechProblem = 'The microphone could not start. Please use the temporary text backup.';
      });
    }
  }

  void _onLessonSpeechResult(stt_result.SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _recognizedWords = result.recognizedWords);
    if (result.finalResult && !_isListening) _scheduleLessonEvaluation();
  }

  void _scheduleLessonEvaluation() {
    if (_lessonSessionHandled || _lessonEvaluationScheduled) return;
    _lessonEvaluationScheduled = true;
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _lessonSessionHandled) return;
      _lessonSessionHandled = true;
      _lessonEvaluationScheduled = false;
      _evaluateSpokenAttempt();
    });
  }

  void _evaluateSpokenAttempt() {
    final heard = _recognizedWords.trim();
    if (heard.isEmpty) {
      setState(() {
        _speechProblem = 'I did not catch that. Tap the microphone and try again.';
        _showEmergencyTyping = false;
        tutorMessage = widget.learnerType == 'Child'
            ? 'I didn’t quite catch your voice. Let’s try that word again!'
            : 'I did not catch that attempt. Please try the word again.';
      });
      _speakLessonMessage(tutorMessage);
      return;
    }
    final cleaned = heard.toLowerCase().replaceAll(RegExp(r'[^a-z\s]'), ' ').trim();
    final target = current?.word.toLowerCase() ?? '';
    final heardTarget = cleaned.split(RegExp(r'\s+')).contains(target);
    setState(() {
      status = 'spoken_attempt';
      wordsPracticed++;
      tutorMessage = heardTarget
          ? (widget.learnerType == 'Child'
              ? 'I heard you say $target! Nice speaking practice. Now let’s look at how those sounds fit together.'
              : 'I heard the target word in your response. Good practice. Let’s review how its sounds connect.')
          : (widget.learnerType == 'Child'
              ? 'I heard “$heard.” That’s okay! Let’s slow down and work through $target together.'
              : 'I heard “$heard.” Let’s slow down and work through the target word, $target.');
    });
    _saveProgress();
    _speakLessonMessage(tutorMessage);
  }

  void _submitEmergencyText() {
    final text = _emergencyController.text.trim();
    if (text.isEmpty) return;
    setState(() => _recognizedWords = text);
    _emergencyController.clear();
    _evaluateSpokenAttempt();
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

  void _newWord({bool first = false}) {
    if (queue.isEmpty) {
      queue = List<LessonWord>.from(wordBank)..shuffle(random);
    }
    final next = queue.removeAt(0);
    setState(() {
      current = next;
      status = 'start';
      showSoundBreakdown = false;
      _recognizedWords = '';
      _showEmergencyTyping = false;
      tutorMessage = first
          ? (widget.learnerType == 'Child'
              ? 'Hey, superstar! 🌟 Let’s wake up those reading muscles. Read this word aloud when you’re ready!'
              : 'Welcome. Let’s work through a word carefully. Please read the word aloud when you are ready.')
          : 'Here is a fresh word. Take your time, look carefully at every letter, and read the whole word aloud when you are ready.';
    });
    _speakLessonMessage(tutorMessage);
  }

  void _needHelp() {
    setState(() {
      status = 'help';
      showSoundBreakdown = true;
      supportedAttempts++;
      tutorMessage = widget.learnerType == 'Child'
          ? 'No worries, word detective! 🔎 We can crack this word together. Let’s slow down and look at each sound.'
          : 'That is okay. Let’s slow down and work through the sounds one at a time.';
    });
    _saveProgress();
    _speakLessonMessage(tutorMessage);
  }


  @override
  void dispose() {
    _lessonSpeech.stop();
    _lessonTts.stop();
    _emergencyController.dispose();
    super.dispose();
  }

  Color _letterColor(String letter) =>
      'aeiou'.contains(letter.toLowerCase()) ? blue : coral;

  @override
  Widget build(BuildContext context) {
    final word = current;
    if (word == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final letters = word.word.split('');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cream,
        title: const Text('Reading practice',
            style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
        actions: [
          IconButton(
            tooltip: 'Chat with your tutor',
            icon: const Icon(Icons.chat_bubble_rounded, color: blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TutorChatScreen(
                    learnerType: widget.learnerType,
                    avatarStyle: widget.avatarStyle,
                    tutorVoice: widget.tutorVoice,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(children: [
              const Icon(Icons.star_rounded, color: Color(0xFFE0A526)),
              Text('$stars', style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
            ]),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Row(children: [
              Expanded(
                child: Text('${widget.learnerType} mode · CVC words',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
              ),
              Text('$wordsPracticed practiced',
                  style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
            ]),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF0FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      widget.avatarStyle == 'Cartoon'
                          ? Icons.smart_toy_rounded
                          : Icons.person_rounded,
                      size: 36,
                      color: blue,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.avatarStyle} tutor · ${widget.tutorVoice}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
                        const SizedBox(height: 5),
                        Text(tutorMessage,
                            style: const TextStyle(color: Color(0xFF4D596B), height: 1.4)),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(children: [
                  const Text('READ THIS WORD',
                      style: TextStyle(fontSize: 12, letterSpacing: 1.3,
                          fontWeight: FontWeight.bold, color: Color(0xFF778195))),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(letters.length, (i) {
                      final letter = letters[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Text(letter, style: TextStyle(
                            fontSize: 62, fontWeight: FontWeight.w900,
                            color: _letterColor(letter))),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  const Text('Red = consonants     Blue = vowels',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _lessonVoiceReady ? () => _speakLessonMessage(word.word) : null,
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Hear this word'),
                  ),
                  if (showSoundBreakdown) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6FC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(children: [
                        const Text('Sound it out, one sound at a time',
                            style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
                        const SizedBox(height: 10),
                        Text(letters.join('   ·   '),
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,
                                color: ink, letterSpacing: 2)),
                        const SizedBox(height: 6),
                        Text(word.hint, textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF667085))),
                      ]),
                    ),
                  ],
                ]),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Your turn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 6),
            const Text(
              'Say the word out loud. Your tutor will listen and talk you through the next step.',
              style: TextStyle(color: Color(0xFF667085), height: 1.4),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(62),
                backgroundColor: _isListening ? coral : mint,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _toggleLessonMicrophone,
              icon: Icon(_isListening ? Icons.stop_circle_outlined : Icons.mic),
              label: Text(_isListening ? 'Stop listening and send' : 'Tap to speak'),
            ),
            if (_isListening) ...[
              const SizedBox(height: 10),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.graphic_eq, color: mint),
                SizedBox(width: 8),
                Text('Listening... speak clearly, then tap Stop',
                    style: TextStyle(color: mint, fontWeight: FontWeight.w700)),
              ]),
            ],
            if (_recognizedWords.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('I heard:', style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
                  const SizedBox(height: 5),
                  Text(_recognizedWords, style: const TextStyle(fontSize: 17, color: ink)),
                ]),
              ),
            ],
            if (_speechProblem.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(_speechProblem,
                  style: const TextStyle(color: Color(0xFF9A5B12), fontSize: 13)),
            ],
            if (_showEmergencyTyping) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _emergencyController,
                decoration: InputDecoration(
                  labelText: 'Temporary response if the microphone fails',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  suffixIcon: IconButton(
                    tooltip: 'Send temporary response',
                    icon: const Icon(Icons.send),
                    onPressed: _submitEmergencyText,
                  ),
                ),
                onSubmitted: (_) => _submitEmergencyText(),
              ),
              TextButton.icon(
                onPressed: () async {
                  final available = await _lessonSpeech.initialize();
                  if (!mounted) return;
                  setState(() {
                    _speechAvailable = available;
                    _showEmergencyTyping = !available;
                    _speechProblem = available ? '' : 'Microphone is still unavailable.';
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try microphone again'),
              ),
            ],
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: _needHelp,
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Help me sound it out'),
            ),
            if (status == 'help' || status == 'spoken_attempt') ...[
              const SizedBox(height: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: ink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  _newWord();
                },
                icon: const Icon(Icons.shuffle_rounded),
                label: const Text('Practice a different word'),
              ),
            ],
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Practice record on this device',
                        style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
                    const SizedBox(height: 10),
                    _StatLine(label: 'Practice attempts needing help', value: '$supportedAttempts'),
                    _StatLine(label: 'Self-reported independent reads', value: '$independentReads'),
                    _StatLine(label: 'Stars earned', value: '$stars'),
                    const SizedBox(height: 8),
                    const Text(
                      'Speech recognition shows what the device heard. It does not yet measure individual phonemes or prove reading mastery.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667085), height: 1.4),
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
  final String avatarStyle;
  final String tutorVoice;

  const TutorChatScreen({
    super.key,
    required this.learnerType,
    required this.avatarStyle,
    required this.tutorVoice,
  });

  @override
  State<TutorChatScreen> createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends State<TutorChatScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _fallbackController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  bool _speechReady = false;
  bool _ttsReady = false;
  bool _isSpeaking = false;
  bool _showTypingFallback = false;
  bool _handledThisSession = false;
  bool _initializing = true;
  String _recognizedWords = '';
  String _statusMessage = 'Getting the microphone ready...';
  String _errorMessage = '';

  bool get _isChild => widget.learnerType == 'Child';

  @override
  void initState() {
    super.initState();
    _messages.add({
      'speaker': 'tutor',
      'text': _isChild
          ? "Hey, superstar reader! 🌟 I'm your reading buddy. Tap the big microphone and tell me what you want to explore!"
          : "Hello! I'm your reading partner. Tap the microphone to speak whenever you're ready.",
    });
    _initializeSpeech();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.46);
      await _tts.setVolume(1.0);
      await _tts.setPitch(_isChild ? 1.12 : 1.0);
      await _tts.awaitSpeakCompletion(true);
      _tts.setStartHandler(() {
        if (mounted) setState(() => _isSpeaking = true);
      });
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _isSpeaking = false);
      });
      _tts.setCancelHandler(() {
        if (mounted) setState(() => _isSpeaking = false);
      });
      _tts.setErrorHandler((_) {
        if (mounted) setState(() => _isSpeaking = false);
      });
      if (mounted) setState(() => _ttsReady = true);
      // Speak the welcome message once the voice engine is initialized.
      if (_messages.isNotEmpty) {
        await _speakTutorText(_messages.first['text'] ?? '');
      }
    } catch (_) {
      if (mounted) setState(() => _ttsReady = false);
    }
  }

  Future<void> _speakTutorText(String text) async {
    if (!_ttsReady || text.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _errorMessage = error.errorMsg;
            _showTypingFallback = true;
            _statusMessage = 'Microphone or speech recognition needs attention.';
          });
        },
      );
      if (!mounted) return;
      setState(() {
        _speechReady = available;
        _initializing = false;
        if (available) {
          _statusMessage = 'Ready when you are. Tap the microphone to talk.';
        } else {
          _statusMessage = 'Speech recognition is unavailable on this device.';
          _errorMessage = 'Your device could not start its speech recognition service.';
          _showTypingFallback = true;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initializing = false;
        _showTypingFallback = true;
        _errorMessage = 'The microphone could not be started.';
        _statusMessage = 'Microphone unavailable.';
      });
    }
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;
    if (status == 'done' || status == 'notListening') {
      setState(() {
        _statusMessage = _recognizedWords.isEmpty
            ? 'Listening stopped. Tap the microphone to try again.'
            : 'I heard you. One moment...';
      });
      _submitRecognizedWords();
    }
  }

  void _onSpeechResult(stt_result.SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _recognizedWords = result.recognizedWords);
    if (result.finalResult) _submitRecognizedWords();
  }

  Future<void> _toggleListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) setState(() => _statusMessage = 'Finishing what I heard...');
      _submitRecognizedWords();
      return;
    }

    if (!_speechReady) {
      await _initializeSpeech();
      if (!_speechReady) return;
    }

    await _tts.stop();
    if (mounted) setState(() => _isSpeaking = false);

    setState(() {
      _recognizedWords = '';
      _handledThisSession = false;
      _errorMessage = '';
      _statusMessage = 'Listening... Speak naturally, then tap to stop.';
    });

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 45),
        pauseFor: const Duration(seconds: 5),
        localeId: 'en_US',
      );
      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _showTypingFallback = true;
        _errorMessage = 'The microphone could not start. Please try again or type your response.';
        _statusMessage = 'Microphone unavailable.';
      });
    }
  }

  void _submitRecognizedWords() {
    if (_handledThisSession || _recognizedWords.trim().isEmpty) return;
    _handledThisSession = true;
    final message = _recognizedWords.trim();
    _addConversationTurn(message);
    if (mounted) {
      setState(() {
        _recognizedWords = '';
        _statusMessage = 'Ready for your next turn. Tap the microphone to talk.';
      });
    }
  }

  void _sendFallbackMessage() {
    final message = _fallbackController.text.trim();
    if (message.isEmpty) return;
    _addConversationTurn(message);
    _fallbackController.clear();
  }

  void _addConversationTurn(String message) {
    final tutorReply = _makeTutorReply(message);
    setState(() {
      _messages.add({'speaker': 'learner', 'text': message});
      _messages.add({'speaker': 'tutor', 'text': tutorReply});
    });
    _speakTutorText(tutorReply);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _makeTutorReply(String message) {
    final text = message.toLowerCase();
    if (text.contains('help') || text.contains('hard') ||
        text.contains('difficult') || text.contains("can't") || text.contains('stuck')) {
      return _isChild
          ? "No problem, word detective! 🔎 Let's slow down and tackle one little sound at a time."
          : "That's okay. Let's take it one step at a time and work through the sound that's causing trouble.";
    }
    if (text.contains('joke') || text.contains('funny')) {
      return _isChild
          ? "Why did the letter A go to the doctor? It wasn't feeling vowel! 😂"
          : "Why was the dictionary always calm? It had all the answers. 😄";
    }
    if (text.contains('tired') || text.contains('break')) {
      return _isChild
          ? "Break time! Even reading superheroes need to recharge. ⭐"
          : "A break is a good idea. We can continue whenever you're ready.";
    }
    if (text.contains('sound') || text.contains('letter')) {
      return _isChild
          ? "Let's be sound detectives! 🔎 We'll listen carefully and put those sounds together."
          : "Let's examine the sound carefully, then blend it into the word.";
    }
    if (text.contains('story') || text.contains('book')) {
      return _isChild
          ? "Story adventure! 📚 Would you like a mystery, a dragon, or a trip into space?"
          : "Stories are a great way to build reading confidence. Let's choose a topic that interests you.";
    }
    return _isChild
        ? "I love that you're telling me about it! 😄 Let's figure it out together, one step at a time."
        : "Thanks for sharing that. Let's explore it together, one step at a time.";
  }

  Widget _messageBubble(Map<String, String> message) {
    final isTutor = message['speaker'] == 'tutor';
    return Align(
      alignment: isTutor ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isTutor ? Colors.white : const Color(0xFFE9EFFB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isTutor ? const Color(0xFFE8EAF0) : const Color(0xFFD6E1F5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isTutor ? 'Your reading buddy' : 'You',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                    color: Color(0xFF778195))),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(message['text'] ?? '',
                      style: const TextStyle(fontSize: 15, color: ink, height: 1.4)),
                ),
                if (isTutor)
                  IconButton(
                    tooltip: 'Hear this message again',
                    visualDensity: VisualDensity.compact,
                    onPressed: _ttsReady
                        ? () => _speakTutorText(message['text'] ?? '')
                        : null,
                    icon: const Icon(Icons.volume_up_rounded, size: 20),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _fallbackController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listening = _speech.isListening;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cream,
        title: const Text('Tutor conversation',
            style: TextStyle(color: ink, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: const Color(0xFFE9EFFB),
              child: Row(children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(widget.avatarStyle == 'Cartoon'
                      ? Icons.smart_toy_rounded : Icons.person_rounded,
                      color: blue, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_isChild ? 'Your reading sidekick' : 'Your reading partner',
                        style: const TextStyle(color: ink, fontWeight: FontWeight.bold)),
                    Text('${widget.tutorVoice} · ${widget.learnerType} mode',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  ],
                )),
              ]),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  ..._messages.map(_messageBubble),
                  if (_recognizedWords.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('I heard: $_recognizedWords',
                          style: const TextStyle(color: ink, fontSize: 15)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
              child: Text(_isSpeaking ? 'Your tutor is speaking... Tap the microphone to interrupt.' : _statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: listening ? mint : const Color(0xFF667085),
                    fontWeight: listening ? FontWeight.bold : FontWeight.normal,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(children: [
                GestureDetector(
                  onTap: _initializing ? null : _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: listening ? coral : blue,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(
                        color: (listening ? coral : blue).withOpacity(0.25),
                        blurRadius: 18, spreadRadius: 3,
                      )],
                    ),
                    child: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white, size: 48),
                  ),
                ),
                const SizedBox(height: 9),
                Text(listening ? 'TAP TO STOP' : 'TAP TO TALK',
                    style: const TextStyle(color: ink, fontWeight: FontWeight.w800,
                        letterSpacing: 1.2)),
              ]),
            ),
            if (_showTypingFallback)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4E5),
                  border: Border(top: BorderSide(color: Color(0xFFF0D7B5))),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("I'm having trouble hearing you. You can type your response while we fix the microphone.",
                      style: TextStyle(color: ink, fontWeight: FontWeight.w600)),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(_errorMessage,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
                  ],
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: TextField(
                      controller: _fallbackController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendFallbackMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type only while the mic is unavailable',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    )),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _sendFallbackMessage,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ]),
                  TextButton.icon(
                    onPressed: _initializeSpeech,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try microphone again'),
                  ),
                ]),
              )
            else if (!_speechReady && !_initializing)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text('Speech recognition is not ready yet.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF8992A1))),
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
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: ink),
      );
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  const _StatLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF667085)))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
        ]),
      );
}
