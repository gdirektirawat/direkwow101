// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

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

/* ===================== SPLASH SCREEN ===================== */

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // 1.2 seconds
    );

    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(const Duration(milliseconds: 1200), () async {
      await _controller.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
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
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/screen_wordsofwisdom.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

/* ===================== MODEL ===================== */

class User {
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

class _HomePageState extends State<HomePage> {
  final _supabase = Supabase.instance.client;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<User> users = [];
  int selectedIndex = 0;
  bool loading = true;
  bool isPlaying = false;
  bool isImageZoomed = false;

  static const double leftBarWidth = 50;
  static const double listPanelWidth = 280 * 2;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _loadUsers();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final data = await _supabase.from('dkwowtable').select();
    users = (data as List)
        .map((e) => User.fromMap(e as Map<String, dynamic>))
        .toList();
    setState(() => loading = false);
  }

  Future<void> _toggleAudio(User user) async {
    if (user.audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No audio file : ไม่มีไฟล์เสียง')),
      );
      return;
    }

    if (isPlaying) {
      await _audioPlayer.stop();
      setState(() => isPlaying = false);
      return;
    }

    final String audioSource = user.audioUrl.startsWith('http')
        ? user.audioUrl
        : _supabase.storage.from('wowaudio').getPublicUrl(user.audioUrl);

    await _audioPlayer.setSourceUrl(audioSource);
    await _audioPlayer.resume();

    setState(() => isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isMobile = MediaQuery.of(context).size.width < 900;
    final user = users[selectedIndex];

    return Scaffold(
      appBar: isMobile
          ? AppBar(title: const Text('Words of Wisdom - Dk'), backgroundColor: const Color.fromARGB(255, 121, 139, 96))
          : null,
      drawer: isMobile ? _mobileDrawer() : null,
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
          //const Icon(Icons.account_circle),
          //const SizedBox(height: 20),
          //const Icon(Icons.photo),
        ],
      ),
    );
  }

  Widget _mobileDrawer() {
    return Drawer(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(users[i].author,style: const TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
          subtitle: Text(users[i].wow, maxLines: 15),
          onTap: () {
            setState(() => selectedIndex = i);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }


Widget _listPanel() {
  return SizedBox(
    width: listPanelWidth,
    child: Container(
      color: const Color(0xFFE3F2FD), // light blue background
      child: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey,
        ),
        itemBuilder: (_, i) {
          final user = users[i];
          return ListTile(
            selected: i == selectedIndex,
            title: Text(
              user.author,
              style: const TextStyle(
                color: Colors.pink, // author in pink
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              user.wow,
              maxLines: 15,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => setState(() => selectedIndex = i),
          );
        },
      ),
    ),
  );
}
  // Widget _detailPane(User user) {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(24),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         GestureDetector(
  //           onTap: () => setState(() => isImageZoomed = true),
  //           child: AspectRatio(
  //             aspectRatio: 1,
  //             child: Image.network(user.imageUrl, fit: BoxFit.contain),
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //         Text(user.author,
  //             style: const TextStyle(
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xffe59d2f))),
  //         const SizedBox(height: 12),
  //         Text(user.wowthai),
  //         const SizedBox(height: 12),
  //         Text(user.explanation),
  //       ],
  //     ),
  //   );
  // }

Widget _detailPane(User user) {
  return MediaQuery.removePadding(
    context: context,
    removeTop: true,
    removeBottom: true,
    child: SingleChildScrollView(
      padding: EdgeInsets.zero, // absolutely no padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => isImageZoomed = true),
            child: Image.network(
              user.imageUrl,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          _info(user),
        ],
      ),
    ),
  );
}

// Widget _info(User user) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(0, 8, 0, 0), // controlled spacing
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           user.author,
//           style: const TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//             color: Color(0xffe59d2f),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(user.wowthai),
//         const SizedBox(height: 8),
//         Text(user.explanation),
//       ],
//     ),
//   );
// }


Widget _info(User user) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 8), // ⬅️ left spacing added
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.author,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          user.wowthai,
          style: const TextStyle(color: Color.fromARGB(255, 182, 129, 13),
            fontSize: 20,          // ⬆️ larger font
            fontWeight: FontWeight.bold, // bold wowthai
          ),
        ),
        const SizedBox(height: 10),
        Text(
          user.explanation,
          style: const TextStyle(
            fontSize: 18, // ⬆️ larger font
          ),
        ),
      ],
    ),
  );
}



  Widget _zoomOverlay(String url) {
    return Positioned(
      left: leftBarWidth,
      top: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () => setState(() => isImageZoomed = false),
        child: Container(
          color: Colors.black,
          child: Center(
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}