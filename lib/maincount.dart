// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      duration: const Duration(milliseconds: 900), // 0.9 seconds
    );

    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(const Duration(milliseconds: 900), () async {
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
  final int id;

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
    required this.id,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      author: (map['author'] ?? '') as String,
      wow: (map['wow'] ?? '') as String,
      wowthai: (map['wowthai'] ?? '') as String,
      explanation: (map['explanation'] ?? '') as String,
      visitcount: (map['visitcount'] ?? 0) as int,
      imageUrl: (map['imageUrl'] ?? '') as String,
      thumbnailUrl: (map['thumbnailUrl'] ?? '') as String,
      audioUrl: (map['audioUrl'] ?? '') as String,
      videoUrl: (map['videoUrl'] ?? '') as String,
      keyWord: (map['keyWord'] ?? '') as String,
      likecount: (map['likecount'] ?? 0) as int,
      id: (map['id'] ?? 0) as int,
    );
  }

  User copyWith({
    String? author,
    String? wow,
    String? wowthai,
    String? explanation,
    int? visitcount,
    String? imageUrl,
    String? thumbnailUrl,
    String? audioUrl,
    String? videoUrl,
    String? keyWord,
    int? likecount,
    int? id,
  }) {
    return User(
      author: author ?? this.author,
      wow: wow ?? this.wow,
      wowthai: wowthai ?? this.wowthai,
      explanation: explanation ?? this.explanation,
      visitcount: visitcount ?? this.visitcount,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      keyWord: keyWord ?? this.keyWord,
      likecount: likecount ?? this.likecount,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'wow': wow,
      'wowthai': wowthai,
      'explanation': explanation,
      'visitcount': visitcount,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'keyWord': keyWord,
      'likecount': likecount,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(author: $author, wow: $wow, wowthai: $wowthai, explanation: $explanation, visitcount: $visitcount, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, audioUrl: $audioUrl, videoUrl: $videoUrl, keyWord: $keyWord, likecount: $likecount, id: $id)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.author == author &&
      other.wow == wow &&
      other.wowthai == wowthai &&
      other.explanation == explanation &&
      other.visitcount == visitcount &&
      other.imageUrl == imageUrl &&
      other.thumbnailUrl == thumbnailUrl &&
      other.audioUrl == audioUrl &&
      other.videoUrl == videoUrl &&
      other.keyWord == keyWord &&
      other.likecount == likecount &&
      other.id == id;
  }

  @override
  int get hashCode {
    return author.hashCode ^
      wow.hashCode ^
      wowthai.hashCode ^
      explanation.hashCode ^
      visitcount.hashCode ^
      imageUrl.hashCode ^
      thumbnailUrl.hashCode ^
      audioUrl.hashCode ^
      videoUrl.hashCode ^
      keyWord.hashCode ^
      likecount.hashCode ^
      id.hashCode;
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
        const SnackBar(content: Text('No audio file available')),
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
          ? AppBar(title: const Text('DKWOW'), backgroundColor: Colors.blueGrey)
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

  // Widget _leftBar(User user) {
  //   return Container(
  //     width: leftBarWidth,
  //     color: const Color(0xffefe6f4),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         IconButton(
  //           icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
  //           onPressed: () => _toggleAudio(user),
  //         ),
  //         const SizedBox(height: 20),
  //         const Icon(Icons.account_circle),
  //         const SizedBox(height: 20),
  //         const Icon(Icons.photo),
  //       ],
  //     ),
  //   );
  // }

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

          // ❤️ LIKE BUTTON
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.pink),
            onPressed: () => _likeUser(user),
          ),

          const SizedBox(height: 6),
          Text(
            '${user.likecount}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),
          const Icon(Icons.account_circle),
          const SizedBox(height: 20),
          const Icon(Icons.photo),
        ],
      ),
    );
  }

  Widget _mobileDrawer() {
    return Drawer(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(users[i].author),
          subtitle: Text(users[i].wow, maxLines: 4),
          onTap: () {
            setState(() => selectedIndex = i);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

//   Widget _listPanel() {
//     return SizedBox(
//       width: listPanelWidth,
//       child: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (_, i) => ListTile(
//           selected: i == selectedIndex,
//           title: Text(users[i].author,

//  ),
//           subtitle: Text(users[i].wow, maxLines: 8),
//           onTap: () => setState(() => selectedIndex = i),
//         ),
//       ),
//     );
//   }

// Widget _listPanel() {
//   return SizedBox(
//     width: listPanelWidth,
//     child: Container(
//       color: const Color(0xFFE3F2FD), // light blue background
//       child: ListView.separated(
//         itemCount: users.length,
//         separatorBuilder: (_, __) => const Divider(
//           height: 1,
//           thickness: 1,
//           color: Colors.grey,
//         ),
//         itemBuilder: (_, i) {
//           final user = users[i];
//           return ListTile(
//             selected: i == selectedIndex,
//             title: Text(
//               user.author,
//               style: const TextStyle(
//                 color: Colors.pink, // author in pink
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(
//               user.wow,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//             onTap: () => setState(() => selectedIndex = i),
//           );
//         },
//       ),
//     ),
//   );
// }

  Widget _listPanel() {
    return SizedBox(
      width: listPanelWidth,
      child: Container(
        color: const Color(0xFFE3F2FD),
        child: ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final user = users[i];
            final bool isSelected = i == selectedIndex;

            return HoverListTile(
              selected: isSelected,
              onTap: () => setState(() => selectedIndex = i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    user.author,
                    style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.wow,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.favorite,
                              size: 14, color: Colors.pink),
                          const SizedBox(width: 4),
                          Text(
                            '${user.likecount}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
      padding:
          const EdgeInsets.only(left: 16, right: 8), // ⬅️ left spacing added
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.author,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xffe59d2f),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.wowthai,
            style: const TextStyle(
              fontSize: 20, // ⬆️ larger font
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

  // Future<void> _likeUser(User user) async {
  //   final int newLikeCount = user.likecount + 1;

  //   try {
  //     await _supabase
  //         .from('dkwowtable')
  //         .update({'like_count': newLikeCount}).eq(
  //             'id', user.id); // use unique column if available (ID preferred)

  //     setState(() {
  //       users[selectedIndex] = User(
  //         author: user.author,
  //         wow: user.wow,
  //         wowthai: user.wowthai,
  //         explanation: user.explanation,
  //         visitcount: user.visitcount,
  //         imageUrl: user.imageUrl,
  //         thumbnailUrl: user.thumbnailUrl,
  //         audioUrl: user.audioUrl,
  //         videoUrl: user.videoUrl,
  //         keyWord: user.keyWord,
  //         likecount: user.newLikeCount,
  //         id: user.id,
  //       );
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to like')),
  //     );
  //   }
  // }
Future<void> _likeUser(User user) async {
  final int updatedLikeCount = user.likecount + 1;

  try {
    await _supabase
        .from('dkwowtable')
        .update({'like_count': updatedLikeCount})
        .eq('wow', user.wow); // ⚠️ replace with ID if available

    setState(() {
      users[selectedIndex] = User(
        id: user.id ,
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
        likecount: updatedLikeCount, // ✅ CORRECT FIELD
      );
    });
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to like')),
    );
  }
}

//




//
}      //class _HomePageState



class HoverListTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool selected;

  const HoverListTile({
    super.key,
    required this.child,
    required this.onTap,
    required this.selected,
  });

  @override
  State<HoverListTile> createState() => _HoverListTileState();
}

class _HoverListTileState extends State<HoverListTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    Color bg;

    if (widget.selected) {
      bg = Colors.blue.withOpacity(0.15);
    } else if (_hovering) {
      bg = Colors.blue.withOpacity(0.08);
    } else {
      bg = Colors.transparent;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: bg,
          child: widget.child,
        ),
      ),
    );
  }
}