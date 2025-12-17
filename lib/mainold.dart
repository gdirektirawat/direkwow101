import 'package:flutter/material.dart';

void main() {
  runApp(const UserBrowserApp());
}

class User {
  final String name;
  final String country;
  final String email;
  final String dob;
  final int age;
  final String image;

  const User({
    required this.name,
    required this.country,
    required this.email,
    required this.dob,
    required this.age,
    required this.image,
  });
}

class UserBrowserApp extends StatelessWidget {
  const UserBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xfff7f2fb),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<User> users = const [
    User(
      name: "Adolf Thom",
      country: "DE",
      email: "adolf.thome@example.com",
      dob: "October 4, 1980",
      age: 43,
      image: "https://i.imgur.com/MDuE5T2.jpeg",
    ),
    User(
      name: "Asta Ande",
      country: "DK",
      email: "asta.ande@example.com",
      dob: "July 21, 1990",
      age: 33,
      image: "https://i.imgur.com/tXWw7bC.jpeg",
    ),
    User(
      name: "Ayan Stranden",
      country: "NO",
      email: "ayan.str@example.com",
      dob: "March 11, 1988",
      age: 36,
      image: "https://i.imgur.com/Ln9lEDb.jpeg",
    ),
    User(
      name: "Ceyhan Polat",
      country: "TR",
      email: "ceyhan@example.com",
      dob: "January 12, 1985",
      age: 39,
      image: "https://i.imgur.com/v0WnP6U.jpeg",
    ),
  ];

  int selectedIndex = 0;

  static const double leftBarWidth = 70;
  static const double listPanelMin = 260;

  @override
  Widget build(BuildContext context) {
    final User selectedUser = users[selectedIndex];
    final Size size = MediaQuery.of(context).size;

    final bool isNarrow = size.width < 1000;

    return Scaffold(
      body: SafeArea(
        child: isNarrow
            ? _buildColumnLayout(selectedUser)
            : _buildRowLayout(selectedUser),
      ),
    );
  }

  // ===================== DESKTOP LAYOUT ============================
  Widget _buildRowLayout(User selectedUser) {
    return Row(
      children: [
        Container(
          width: leftBarWidth,
          color: const Color(0xffefe6f4),
          child: const Column(
            children: [
              SizedBox(height: 28),
              Icon(Icons.account_circle, size: 32),
              SizedBox(height: 24),
              Icon(Icons.people),
              SizedBox(height: 18),
              Icon(Icons.photo),
              SizedBox(height: 18),
              Icon(Icons.dashboard),
            ],
          ),
        ),

        // LIST
        Container(
          width: listPanelMin,
          color: Colors.white,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "LIST",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
              Expanded(child: _userListView()),
            ],
          ),
        ),

        // DETAIL PANE
        Expanded(
          child: Container(
            color: const Color(0xfff7f2fb),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "DETAIL",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
                Expanded(child: _detailPane(selectedUser)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===================== MOBILE/TABLET LAYOUT ============================
  Widget _buildColumnLayout(User selectedUser) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Container(
                width: leftBarWidth,
                color: const Color(0xffefe6f4),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle),
                    SizedBox(height: 8),
                    Icon(Icons.people),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _userListView(axis: Axis.horizontal),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(child: _detailPane(selectedUser)),
      ],
    );
  }

  // ===================== USER LIST VIEW ============================
  Widget _userListView({Axis axis = Axis.vertical}) {
    if (axis == Axis.vertical) {
      return ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final u = users[i];
          final selected = i == selectedIndex;
          return Material(
            color: selected ? const Color(0xfff0efef) : Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              leading: CircleAvatar(backgroundImage: NetworkImage(u.image)),
              title: Text(
                u.name,
                style: TextStyle(
                  color: selected ? Colors.orange[700] : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              subtitle: Text(u.country),
              onTap: () => setState(() => selectedIndex = i),
            ),
          );
        },
      );
    }

    // HORIZONTAL LIST (mobile top)
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, i) {
        final u = users[i];
        final selected = i == selectedIndex;
        return InkWell(
          onTap: () => setState(() => selectedIndex = i),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xfff0efef) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 20, backgroundImage: NetworkImage(u.image)),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(u.country,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===================== DETAIL PANE (FIXED FOR MOBILE) ============================
  Widget _detailPane(User user) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    user.image,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Mr ${user.name}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffe59d2f),
                ),
              ),
              const SizedBox(height: 12),
              Text(user.email, textAlign: TextAlign.center),
              Text(user.dob, textAlign: TextAlign.center),
              Text("${user.age} years old", textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    user.image,
                    width: 260,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 48),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mr ${user.name}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe59d2f),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.email),
                  Text(user.dob),
                  Text("${user.age} years old"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}