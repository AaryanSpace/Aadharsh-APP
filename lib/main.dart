import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'dart:ui'; // Required for Glass Effect
import 'screens/grocery_game_screen.dart';
import 'package:confetti/confetti.dart'; 
import 'package:audioplayers/audioplayers.dart';


// --- 1. PREMIUM BACKGROUND (Required for Glass Effect) ---
class PremiumBackground extends StatelessWidget {
  final Widget child;
  const PremiumBackground({super.key, required this.child});~f

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Dark Premium Gradient (Teal/Blue/Black)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2027), // Deep Dark
            Color(0xFF203A43), // Slate
            Color(0xFF2C5364), // Teal
          ],
        ),
      ),
      child: child,
    );
  }
}

// --- 2. GLASS CONTAINER (The "Frosted" Look) ---
class GlassContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassContainer({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 20,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // BLUR
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              // Semi-transparent white
              color: Colors.white.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.2), // Thin border
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

void showCelebration(BuildContext context, String message) {
  speak(message);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent, 
        child: GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void main() {
  runApp(const LifeLearningApp());
}

final FlutterTts tts = FlutterTts();
String currentLanguage = "en-US"; 

Future<void> speak(String text) async {
  await tts.setLanguage(currentLanguage);
  await tts.setSpeechRate(0.45);
  await tts.speak(text);
}

class LifeLearningApp extends StatelessWidget {
  const LifeLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Life Learning',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent, // Must be transparent!
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        )
      ),
      home: const HomeScreen(),
    );
  }
}

/// ================= HOME SCREEN =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Daily Life Learning", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: (value) {
                currentLanguage = value;
                if (value == "en-US") speak("English selected");
                else if (value == "hi-IN") speak("हिंदी चुनी गई");
                else if (value == "ne-NP") speak("नेपाली भाषा चयन गरियो");
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: "en-US", child: Text("English")),
                PopupMenuItem(value: "hi-IN", child: Text("हिंदी")),
                PopupMenuItem(value: "ne-NP", child: Text("नेपाली")),
              ],
            ),
          ],
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(24),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            HomeCard(
              icon: Icons.restaurant,
              label: "Food",
              color: Colors.orangeAccent,
              onTap: () {
                speak("Food");
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemScreen(
                  title: "Food", color: Colors.orangeAccent, items: ["Rice", "Bread", "Water"], icons: [Icons.lunch_dining, Icons.bakery_dining, Icons.local_drink],
                )));
              },
            ),
            HomeCard(
              icon: Icons.directions_bus,
              label: "Travel",
              color: Colors.blueAccent,
              onTap: () {
                speak("Travel");
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemScreen(
                  title: "Travel", color: Colors.blueAccent, items: ["Bus", "Train", "Taxi"], icons: [Icons.directions_bus, Icons.train, Icons.local_taxi],
                )));
              },
            ),
            HomeCard(
              icon: Icons.shopping_cart,
              label: "Shopping",
              color: Colors.greenAccent,
              onTap: () {
                speak("Shopping");
                Navigator.push(context, MaterialPageRoute(builder: (_) => GroceryGameScreen(language: currentLanguage)));
              },
            ),
            HomeCard(
              icon: Icons.currency_rupee,
              label: "Money",
              color: Colors.tealAccent,
              onTap: () {
                speak("Money");
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MoneyScreen()));
              },
            ),
            HomeCard(
              icon: Icons.numbers,
              label: "Counting",
              color: Colors.purpleAccent,
              onTap: () {
                speak("Counting");
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CountingScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const HomeCard({super.key, required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2)),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

/// ================= ITEM SCREEN =================
class ItemScreen extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> items;
  final List<IconData> icons;

  const ItemScreen({super.key, required this.title, required this.color, required this.items, required this.icons});

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(title)),
        body: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GlassContainer(
              onTap: () => speak(items[index]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icons[index], size: 50, color: color),
                  const SizedBox(height: 10),
                  Text(items[index], style: const TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


/// ================= GAMIFIED MONEY SCREEN =================
/// ================= GAMIFIED MONEY SCREEN (LIST VIEW FIX) =================
class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> with SingleTickerProviderStateMixin {
  final Random random = Random();
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer(); 

  // Game State
  late Map<String, dynamic> targetNote;
  int score = 0;
  int streak = 0; 
  int level = 1;  
  
  String? feedbackText;
  bool showFeedback = false;

  final List<Map<String, dynamic>> allNotes = [
    {"value": 5, "image": "assets/notes/rs_5.jpg"},
    {"value": 10, "image": "assets/notes/rs_10.jpg"},
    {"value": 20, "image": "assets/notes/rs_20.jpg"},
    {"value": 50, "image": "assets/notes/rs_50.jpg"},
    {"value": 100, "image": "assets/notes/rs_100.jpg"},
    {"value": 500, "image": "assets/notes/rs_500.jpg"},
    {"value": 1000, "image": "assets/notes/rs_1000.jpg"},
  ];

  List<Map<String, dynamic>> currentLevelNotes = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _updateLevel(); 
    _pickRandomNote();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateLevel() {
    if (level == 1) {
      currentLevelNotes = allNotes.where((n) => (n['value'] as int) <= 20).toList();
    } else if (level == 2) {
      currentLevelNotes = allNotes.where((n) => (n['value'] as int) <= 100).toList();
    } else {
      currentLevelNotes = List.from(allNotes);
    }
  }

  void _pickRandomNote() {
    setState(() {
      targetNote = currentLevelNotes[random.nextInt(currentLevelNotes.length)];
    });
    _speakInstruction();
  }

  void _speakInstruction() {
    String text = "";
    if (currentLanguage == "hi-IN") text = "${targetNote['value']} रुपये टैप करें";
    else if (currentLanguage == "ne-NP") text = "${targetNote['value']} रुपैयाँ ट्याप गर्नुहोस्";
    else text = "Tap ${targetNote['value']} rupees";
    
    speak(text);
  }

  String _getTargetText() {
    if (currentLanguage == "hi-IN") return "यह नोट खोजें: ₹${targetNote['value']}";
    if (currentLanguage == "ne-NP") return "यो नोट फेला पार्नुहोस्: ₹${targetNote['value']}";
    return "Find this note: ₹${targetNote['value']}";
  }

  void _playSound(String type) {
    try {
      if (type == 'win') _audioPlayer.play(AssetSource('sounds/success.mp3'));
      if (type == 'coin') _audioPlayer.play(AssetSource('sounds/coin.mp3'));
    } catch (e) {
      // Ignore
    }
  }

  void _checkAnswer(int tappedValue) {
    if (tappedValue == targetNote['value']) {
      // CORRECT
      _playSound('coin');
      
      setState(() {
        streak++;
        score += 10 + (streak * 5); 
        
        if (streak > 1) {
          showFeedback = true;
          if (streak == 2) feedbackText = "Sweet!";
          else if (streak == 3) feedbackText = "Tasty!";
          else if (streak == 4) feedbackText = "Divine!";
          else feedbackText = "Unstoppable!";
          
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) setState(() => showFeedback = false);
          });
        }

        if (streak % 5 == 0 && level < 3) {
          level++;
          _updateLevel();
          _confettiController.play(); 
          _playSound('win');
          showCelebration(context, "Level Up!");
        }
      });

      _pickRandomNote();

    } else {
      // WRONG
      setState(() {
        streak = 0; 
        showFeedback = true;
        feedbackText = "Oops!";
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) setState(() => showFeedback = false);
        });
      });
      
      if (currentLanguage == "hi-IN") speak("गलत, फिर कोशिश करें");
      else speak("Wrong, try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                // --- 1. TOP BAR ---
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Level $level", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 18, color: Colors.white),
                              const SizedBox(width: 5),
                              Text("$score", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- 2. PROGRESS BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (streak % 5) / 5, 
                      backgroundColor: Colors.white10,
                      color: Colors.greenAccent,
                      minHeight: 6,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --- 3. TARGET HINT DISPLAY ---
                GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        _getTargetText(),
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 8),
                      // The visual hint
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                          boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 8)]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            targetNote['image'] as String,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 4. OPTIONS LIST (CHANGED FROM GRIDVIEW TO LISTVIEW) ---
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: currentLevelNotes.length,
                    itemBuilder: (context, index) {
                      final note = currentLevelNotes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: GlassContainer(
                          padding: EdgeInsets.zero,
                          onTap: () => _checkAnswer(note['value'] as int),
                          child: Column(
                            children: [
                              // LARGE IMAGE AREA
                              Container(
                                height: 150, // Fixed height for consistency
                                width: double.infinity, // Take full width
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  note['image'] as String,
                                  // This ensures perfect fit based on original ratio
                                  fit: BoxFit.contain, 
                                ),
                              ),
                              // VALUE TEXT BAR
                              Container(
                                width: double.infinity,
                                color: Colors.white.withOpacity(0.1),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Rs ${note['value']}",
                                  style: const TextStyle(
                                    fontSize: 22, 
                                    fontWeight: FontWeight.bold, 
                                    color: Colors.white
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
              ],
            ),

            // --- CONFETTI ---
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange], 
            ),

            // --- POPUP TEXT ---
            if (showFeedback)
              Positioned(
                top: 250,
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Text(
                          feedbackText ?? "",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black, blurRadius: 10)]
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
/// ================= COUNTING SCREEN =================
class CountingScreen extends StatefulWidget {
  const CountingScreen({super.key});
  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  int start = 1;              
  int correctToday = 0;       
  late int targetNumber;      
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _pickRandomTarget();
  }

  void _pickRandomTarget() {
    targetNumber = start + random.nextInt(10);
    speak("Tap $targetNumber");
  }

  List<int> get currentNumbers => List.generate(10, (index) => start + index);

  void onNumberTap(int number) {
    if (number == targetNumber) {
      setState(() {
        correctToday++;
        _pickRandomTarget();
      });
      if (correctToday >= 10) showCelebration(context, "Goal Completed!");
    } else {
      speak("Try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text("Counting $start - ${start + 9}")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GlassContainer(
                borderRadius: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Today: $correctToday / 10", style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20,
                ),
                itemCount: currentNumbers.length,
                itemBuilder: (context, index) {
                  final number = currentNumbers[index];
                  return GlassContainer(
                    onTap: () => onNumberTap(number),
                    child: Center(
                      child: Text(
                        number.toString(),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() { if(start > 1) start -= 10; _pickRandomTarget(); }), 
                    child: const Text("Previous")
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() { if(start < 91) start += 10; _pickRandomTarget(); }), 
                    child: const Text("Next")
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

if (true){
   print("Hello world")
}