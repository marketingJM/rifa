import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const RifaApp());
}

class RifaApp extends StatelessWidget {
  const RifaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rifa Cadena de Oro 18K',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD8AF32),
          brightness: Brightness.dark,
        ),
      ),
      home: const RifaHomePage(),
    );
  }
}

class RifaHomePage extends StatefulWidget {
  const RifaHomePage({super.key});

  @override
  State<RifaHomePage> createState() => _RifaHomePageState();
}

class _RifaHomePageState extends State<RifaHomePage> {
  // Cambia estas URLs si tu sitio queda en otra dirección.
  static const String urlIndex = 'https://marketingjm.github.io/rifa/';
  static const String urlAdmin = 'https://marketingjm.github.io/rifa/admin.html';

  late final WebViewController _controller;
  int _currentTab = 0; // 0 = Vender (index), 1 = Admin
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
        ),
      )
      ..loadRequest(Uri.parse(urlIndex));
  }

  void _goTo(String url, int tabIndex) {
    setState(() => _currentTab = tabIndex);
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD8AF32)),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xFFD8AF32),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentTab,
          onTap: (index) {
            if (index == 0) {
              _goTo(urlIndex, 0);
            } else {
              _goTo(urlAdmin, 1);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'Vender',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
          ],
        ),
      ),
    );
  }
}
