import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
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
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String learnerType = 'Child';
  String avatarStyle = 'Cartoon';
  String tutorVoice = 'Warm and encouraging';

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
              value: tutorVoice,
              decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
              items: const [
                DropdownMenuItem(value: 'Warm and encouraging', child: Text('Warm and encouraging')),
                DropdownMenuItem(value: 'Calm and gentle', child: Text('Calm and gentle')),
                DropdownMenuItem(value: 'Bright and energetic', child: Text('Bright and energetic')),
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
              label: const Text('Meet my reading tutor', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Starter build: lesson flow and controls are interactive. Live AI conversation and microphone-based scoring are not connected yet.',
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
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
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

  void _newWord({bool first = false}) {
    if (queue.isEmpty) {
      queue = List<LessonWord>.from(wordBank)..shuffle(random);
    }
    final next = queue.removeAt(0);
    setState(() {
      current = next;
      status = 'start';
      showSoundBreakdown = false;
      tutorMessage = first
          ? 'Hi! I’m glad we’re learning together. Let’s read a word. Take your time. What sound does the first letter make?'
          : 'Here is a new word. This one is different, so look carefully at every letter. What sound do you hear at the beginning?';
    });
  }

  void _needHelp() {
    setState(() {
      status = 'help';
      showSoundBreakdown = true;
      supportedAttempts++;
      tutorMessage = 'That’s okay. We don’t guess. Let’s slow it down and work through the sounds together. I’ll show you the sound pattern, then you can try a fresh word.';
    });
    _saveProgress();
  }

  void _independentAttempt() {
    setState(() {
      status = 'self_reported';
      independentReads++;
      stars++;
      wordsPracticed++;
      tutorMessage = 'Thanks for telling me you decoded it independently. In the full version, I will verify the spoken sounds before recording mastery. For now, this is a practice-session self-report, not an assessed score.';
    });
    _saveProgress();
  }

  void _nextWord() {
    _newWord();
  }

  Color _letterColor(String letter) {
    const vowels = 'aeiou';
    return vowels.contains(letter.toLowerCase()) ? blue : coral;
  }

  @override
  Widget build(BuildContext context) {
    final word = current;
    if (word == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final letters = word.word.split('');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cream,
        title: const Text('Reading practice', style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(children: [
              const Icon(Icons.star_rounded, color: Color(0xFFE0A526)),
              Text('$stars', style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
            ]),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Row(
              children: [
                Expanded(child: Text('${widget.learnerType} mode · CVC words', style: const TextStyle(fontWeight: FontWeight.w700, color: ink))),
                Text('${wordsPracticed} practiced', style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
              ],
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 62, height: 62,
                      decoration: BoxDecoration(color: const Color(0xFFEAF0FB), borderRadius: BorderRadius.circular(20)),
                      child: Icon(widget.avatarStyle == 'Cartoon' ? Icons.smart_toy_rounded : Icons.person_rounded, size: 36, color: blue),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${widget.avatarStyle} tutor · ${widget.tutorVoice}', style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
                        const SizedBox(height: 5),
                        Text(tutorMessage, style: const TextStyle(color: Color(0xFF4D596B), height: 1.4)),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    const Text('READ THIS WORD', style: TextStyle(fontSize: 12, letterSpacing: 1.3, fontWeight: FontWeight.bold, color: Color(0xFF778195))),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(letters.length, (i) {
                        final letter = letters[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(letter, style: TextStyle(fontSize: 62, fontWeight: FontWeight.w900, color: _letterColor(letter))),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    const Text('Red = consonants     Blue = vowels', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                    if (showSoundBreakdown) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: const Color(0xFFF3F6FC), borderRadius: BorderRadius.circular(14)),
                        child: Column(children: [
                          const Text('Sound it out, one sound at a time', style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
                          const SizedBox(height: 10),
                          Text(letters.join('   ·   '), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: ink, letterSpacing: 2)),
                          const SizedBox(height: 6),
                          Text(word.hint, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF667085))),
                        ]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Your turn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 6),
            const Text('In this starter build, choose how the practice went. These buttons do not listen to or verify speech yet.', style: TextStyle(color: Color(0xFF667085), height: 1.4)),
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: mint, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: status == 'self_reported' ? null : _independentAttempt,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('I decoded it independently'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54), foregroundColor: ink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: _needHelp,
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('I need help with this word'),
            ),
            if (status == 'help' || status == 'self_reported') ...[
              const SizedBox(height: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: ink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _nextWord,
                icon: const Icon(Icons.shuffle_rounded),
                label: const Text('Practice a different word'),
              ),
            ],
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Practice record on this device', style: TextStyle(fontWeight: FontWeight.bold, color: ink)),
                  const SizedBox(height: 10),
                  _StatLine(label: 'Practice attempts needing help', value: '$supportedAttempts'),
                  _StatLine(label: 'Self-reported independent reads', value: '$independentReads'),
                  _StatLine(label: 'Stars earned', value: '$stars'),
                  const SizedBox(height: 8),
                  const Text('Important: independent reading mastery will only be awarded after real speech assessment is connected. Self-reported attempts are kept separate.', style: TextStyle(fontSize: 12, color: Color(0xFF667085), height: 1.4)),
                ]),
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
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: ink));
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  const _StatLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF667085)))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
      ]),
    );
  }
}
