// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

/* ===================== MAIN ===================== */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nfjqpozrlbyvzwvvbjvi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5manFwb3pybGJ5dnp3dnZianZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2Mjk2ODksImV4cCI6MjA4MTIwNTY4OX0.LYeruFGw4WuRotE67ZAAl7W6zPBwwQSROGuOUTtZ1F4',
  );

  runApp(const UserBrowserApp());
}

/* ===================== APP ===================== */

class UserBrowserApp extends StatelessWidget {
  const UserBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

/* ===================== SPLASH ===================== */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(const Duration(milliseconds: 1200), () async {
      await _controller.forward();
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Image.asset(
          'assets/images/screen_wordsofwisdom.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

/* ===================== MODEL ===================== */

// class User {
//   final String author;
//   final String wow;
//   final String wowthai;
//   final String explanation;
//   final String imageUrl;
//   final String audioUrl;
//   int likecount;

//   User({
//     required this.author,
//     required this.wow,
//     required this.wowthai,
//     required this.explanation,
//     required this.imageUrl,
//     required this.audioUrl,
//     required this.likecount,
//   });

//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       author: map['author'] ?? '',
//       wow: map['wow'] ?? '',
//       wowthai: map['wow_thai'] ?? '',
//       explanation: map['explanation'] ?? '',
//       imageUrl: map['image_path'] ?? '',
//       audioUrl: map['audio_path'] ?? '',
//       likecount: map['like_count'] ?? 0,
//     );
//   }
// }
class User {
  final int id;
  final String author;
  final String wow;
  final String wowthai;
  final String explanation;
  final int visitcount;
  final String imageUrl;
  final String thumbnailUrl;
  final String audioUrl;
  final String videoUrl;
  final String keyWord;
  final int likecount;

  User({
    required this.id,
    required this.author,
    required this.wow,
    required this.wowthai,
    required this.explanation,
    required this.visitcount,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.audioUrl,
    required this.videoUrl,
    required this.keyWord,
    required this.likecount,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'], // ✅ REQUIRED
      author: map['author'] ?? '',
      wow: map['wow'] ?? '',
      wowthai: map['wow_thai'] ?? '',
      explanation: map['explanation'] ?? '',
      visitcount: map['visit_count'] ?? 0,
      imageUrl: map['image_path'] ?? '',
      thumbnailUrl: map['thumbnail_path'] ?? '',
      audioUrl: map['audio_path'] ?? '',
      videoUrl: map['avatar_video'] ?? '',
      keyWord: map['keyword'] ?? '',
      likecount: map['like_count'] ?? 0,
    );
  }
}
/* ===================== HOME ===================== */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//   final supabase = Supabase.instance.client;
//   final AudioPlayer audioPlayer = AudioPlayer();

//   List<User> users = [];
//   int selectedIndex = 0;
//   bool loading = true;
//   bool isPlaying = false;
//   bool isImageZoomed = false;

// class _HomePageState extends State<HomePage> {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   List<User> users = [];
//   int selectedIndex = 0;
//   bool loading = true;
//   bool isPlaying = false;
//   bool isImageZoomed = false;
class _HomePageState extends State<HomePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<User> users = [];
  int selectedIndex = 0;
  bool loading = true;
  bool isPlaying = false;
  bool isImageZoomed = false;
  static const double leftBarWidth = 50;
  static const double listPanelWidth = 560;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await _supabase.from('dkwowtable').select();
    users = (data as List).map((e) => User.fromMap(e)).toList();
    setState(() => loading = false);
  }

  /* ===================== LIKE ===================== */

  // Future<void> _likeCurrentUser() async {
  //   final user = users[selectedIndex];
  //   //setState(() => user.likecount++);

  //   await supabase
  //       .from('dkwowtable')
  //       .update({'like_count': user.likecount})
  //       .eq('author', user.author);
  // }
// Future<void> _likeUser(User user) async {
//   final newLikeCount = user.likecount + 1;

//   // Update Supabase
//   await _supabase
//       .from('dkwowtable')
//       .update({'like_count': newLikeCount})
//       .eq('id', user.id);

//   // Update local list (immutable replacement)
//   setState(() {
//     users[selectedIndex] = User(
//       id: user.id,
//       author: user.author,
//       wow: user.wow,
//       wowthai: user.wowthai,
//       explanation: user.explanation,
//       visitcount: user.visitcount,
//       imageUrl: user.imageUrl,
//       thumbnailUrl: user.thumbnailUrl,
//       audioUrl: user.audioUrl,
//       videoUrl: user.videoUrl,
//       keyWord: user.keyWord,
//       likecount: newLikeCount,
//     );
//   });
// }
// Future<void> _likeUser(User user) async {
//   final newLikeCount = user.likecount + 1;

//   await _supabase
//       .from('dkwowtable')
//       .update({'like_count': newLikeCount})
//       .eq('id', user.id);

//   setState(() {
//     users[selectedIndex] = User(
//       id: user.id,
//       author: user.author,
//       wow: user.wow,
//       wowthai: user.wowthai,
//       explanation: user.explanation,
//       visitcount: user.visitcount,
//       imageUrl: user.imageUrl,
//       thumbnailUrl: user.thumbnailUrl,
//       audioUrl: user.audioUrl,
//       videoUrl: user.videoUrl,
//       keyWord: user.keyWord,
//       likecount: newLikeCount,
//     );
//   });
// }
Future<void> _likeUser(User user) async {
  final response = await _supabase
      .from('dkwowtable')
      .update({
        'like_count': user.likecount + 1,
      })
      .eq('id', user.id)
      .select('like_count')
      .single();

  final updatedLikeCount = response['like_count'] as int;

  setState(() {
    users[selectedIndex] = User(
      id: user.id,
      author: user.author,
      wow: user.wow,
      wowthai: user.wowthai,
      explanation: user.explanation,
      visitcount: user.visitcount,
      imageUrl: user.imageUrl,
      thumbnailUrl: user.thumbnailUrl,
      audioUrl: user.audioUrl,
      videoUrl: user.videoUrl,
      keyWord: user.keyWord,
      likecount: updatedLikeCount,
    );
  });
}
  /* ===================== AUDIO ===================== */

  Future<void> _toggleAudio(User user) async {
    if (user.audioUrl.isEmpty) return;

    if (isPlaying) {
      await _audioPlayer.stop();
      setState(() => isPlaying = false);
      return;
    }

    final url = user.audioUrl.startsWith('http')
        ? user.audioUrl
        : _supabase.storage.from('wowaudio').getPublicUrl(user.audioUrl);

    await _audioPlayer.setSourceUrl(url);
    await _audioPlayer.resume();
    setState(() => isPlaying = true);
  }

  /* ===================== UI ===================== */

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = users[selectedIndex];
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: isMobile
          ? AppBar(title: const Text('Words of Wisdom - DK'))
          : null,
      drawer: isMobile ? _drawer() : null,
      body: Stack(
        children: [
          Row(
            children: [
              _leftBar(user),
              if (!isMobile) _listPanel(),
              Expanded(child: _detailPane(user)),
            ],
          ),
          if (isImageZoomed) _zoomOverlay(user.imageUrl),
        ],
      ),
    );
  }

  Widget _leftBar(User user) {
    return Container(
      width: leftBarWidth,
      color: const Color(0xffefe6f4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
            onPressed: () => _toggleAudio(user),
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.pink),
            //onPressed: _likeCurrentUser,
            onPressed: () => _likeUser(user),
          ),
          Text('${user.likecount}', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _drawer() => Drawer(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(users[i].author,
                style: const TextStyle(
                    color: Colors.pink, fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                Expanded(child: Text(users[i].wow, maxLines: 2)),
                const Icon(Icons.favorite, size: 14, color: Colors.pink),
                Text(' ${users[i].likecount}'),
              ],
            ),
            onTap: () {
              setState(() => selectedIndex = i);
              Navigator.pop(context);
            },
          ),
        ),
      );

  Widget _listPanel() => SizedBox(
        width: listPanelWidth,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) => ListTile(
            selected: i == selectedIndex,
            title: Text(users[i].author,
                style: const TextStyle(
                    color: Colors.pink, fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                Expanded(child: Text(users[i].wow, maxLines: 2)),
                const Icon(Icons.favorite, size: 14, color: Colors.pink),
                Text(' ${users[i].likecount}'),
              ],
            ),
            onTap: () => setState(() => selectedIndex = i),
          ),
        ),
      );

  Widget _detailPane(User user) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => isImageZoomed = true),
              child: Image.network(user.imageUrl, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.author,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink)),
                  const SizedBox(height: 8),
                  Text(user.wowthai,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                  const SizedBox(height: 8),
                  Text(user.explanation, style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _zoomOverlay(String url) => Positioned(
        left: leftBarWidth,
        top: 0,
        right: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: () => setState(() => isImageZoomed = false),
          child: Container(
            color: Colors.black,
            child: Center(child: Image.network(url, fit: BoxFit.contain)),
          ),
        ),
      );


//       Future<void> _likeUser(User user) async {
//   final newLikeCount = user.likecount + 1;

//   // 1️⃣ Update database
//   await _supabase
//       .from('dkwowtable')
//       .update({'like_count': newLikeCount})
//       .eq('id', user.id);

//   // 2️⃣ Update local state
//   setState(() {
//     users[selectedIndex] = User(
//       id: user.id,
//       author: user.author,
//       wow: user.wow,
//       wowthai: user.wowthai,
//       explanation: user.explanation,
//       visitcount: user.visitcount,
//       imageUrl: user.imageUrl,
//       thumbnailUrl: user.thumbnailUrl,
//       audioUrl: user.audioUrl,
//       videoUrl: user.videoUrl,
//       keyWord: user.keyWord,
//       likecount: newLikeCount,
//     );
//   });
// }
}