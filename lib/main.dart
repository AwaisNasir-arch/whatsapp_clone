import 'package:flutter/material.dart';

// ============================================================
//  WhatsApp-style app (screens only, no Firebase)
//
//  Handout topics used in this app:
//   2. Named routes           -> /contacts, /settings, /about
//   4. BottomNavigationBar    -> Chats | Updates | Communities | Calls
//   5. BottomAppBar + FAB     -> Contacts screen
//   6. TabBar + TabBarView    -> Status | Channels (Updates tab)
//   7. Drawer + ListView      -> side menu
// ============================================================

void main() => runApp(const MyApp());

const Color green = Color(0xFF1FA855);

// ---------- App + named routes (#2) ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: green),
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage(),
      '/contacts': (context) => const ContactsPage(),
      '/settings': (context) => const SimplePage(title: 'Settings'),
      '/about': (context) => const SimplePage(title: 'About'),
    },
  );
}

// ============================================================
//  HOME: top bar + drawer + bottom navigation bar
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    ChatsPage(),
    UpdatesPage(),
    EmptyText('No communities yet'),
    EmptyText('No calls yet'),
  ];

  // Close the drawer, then open a named route
  void openFromDrawer(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    // Top bar
    appBar: AppBar(
      title: const Text('WhatsApp',
          style: TextStyle(color: green, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    ),

    // Side menu (#7)
    drawer: Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: green),
            child: Text('WhatsApp Menu',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Contacts'),
            onTap: () => openFromDrawer('/contacts'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => openFromDrawer('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => openFromDrawer('/about'),
          ),
        ],
      ),
    ),

    // Page changes when a bottom item is tapped
    body: pages[currentIndex],

    // Green "new chat" button, only on the Chats tab
    floatingActionButton: currentIndex == 0
        ? FloatingActionButton(
      backgroundColor: green,
      foregroundColor: Colors.white,
      onPressed: () => Navigator.pushNamed(context, '/contacts'),
      child: const Icon(Icons.add_comment),
    )
        : null,

    // Bottom navigation bar (#4)
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      onTap: (index) => setState(() => currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        BottomNavigationBarItem(icon: Icon(Icons.donut_large), label: 'Updates'),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Communities'),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
      ],
    ),
  );
}

// ============================================================
//  CHATS TAB: search bar + filter chips
// ============================================================
class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final List<String> filters = ['All', 'Unread', 'Favourites', 'Groups'];
  String filter = 'All';

  @override
  Widget build(BuildContext context) => Column(
    children: [
      // Search bar
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Ask Meta AI or Search',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),

      // Filter chips
      SizedBox(
        height: 45,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 12),
          children: [
            for (final name in filters)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(name),
                  selected: filter == name,
                  selectedColor: const Color(0xFFD8F8D8),
                  onSelected: (_) => setState(() => filter = name),
                ),
              ),
          ],
        ),
      ),

      // Message in the empty space
      const Expanded(child: EmptyText('No chats yet')),
    ],
  );
}

// ============================================================
//  UPDATES TAB: TabBar + TabBarView (#6)
// ============================================================
class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  @override
  Widget build(BuildContext context) => const DefaultTabController(
    length: 2,
    child: Column(
      children: [
        TabBar(
          labelColor: green,
          indicatorColor: green,
          tabs: [Tab(text: 'Status'), Tab(text: 'Channels')],
        ),
        Expanded(
          child: TabBarView(
            children: [
              EmptyText('No status updates yet'),
              EmptyText('No channels yet'),
            ],
          ),
        ),
      ],
    ),
  );
}

// ============================================================
//  CONTACTS SCREEN: BottomAppBar + FloatingActionButton (#5)
// ============================================================
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Select contact')),
    body: const EmptyText('No contacts yet'),
    bottomNavigationBar: BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
            const SizedBox(width: 45),
          ],
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    floatingActionButton: FloatingActionButton(
      backgroundColor: green,
      foregroundColor: Colors.white,
      onPressed: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add contact pressed'))),
      child: const Icon(Icons.person_add),
    ),
  );
}

// ============================================================
//  Small reusable widgets
// ============================================================

// Grey message in the middle of an empty screen
class EmptyText extends StatelessWidget {
  final String text;
  const EmptyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.grey)),
  );
}

// Simple page with a title (Settings, About)
class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title Screen', style: const TextStyle(fontSize: 24))),
  );
}