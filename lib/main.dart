import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

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
  bool _hasError = false;
  String _currentUrl = urlIndex;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _loading = true;
            _hasError = false;
          }),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (WebResourceError error) {
            // Solo mostramos el bloqueo de "sin conexión" si falló la
            // página principal, no si falló un recurso secundario
            // (una fuente, un ícono, un script de terceros, etc.).
            final bool esPaginaPrincipal =
                (error is AndroidWebResourceError)
                    ? (error.isForMainFrame ?? true)
                    : true;
            if (!esPaginaPrincipal) return;
            setState(() {
              _loading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(urlIndex));
  }

  void _goTo(String url, int tabIndex) {
    setState(() {
      _currentTab = tabIndex;
      _currentUrl = url;
    });
    _controller.loadRequest(Uri.parse(url));
  }

  void _reintentar() {
    setState(() => _hasError = false);
    _controller.loadRequest(Uri.parse(_currentUrl));
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
              if (_hasError)
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, color: Color(0xFFD8AF32), size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'No se pudo cargar. Revisa tu conexión a internet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _reintentar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD8AF32),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  ),
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
