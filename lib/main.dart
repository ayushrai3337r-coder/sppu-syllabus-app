import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const SPPUApp());

class SPPUApp extends StatelessWidget {
  const SPPUApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPPU Syllabus Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6600))),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() {
          _isLoading = true;
          _hasError = false;
        }),
        onPageFinished: (_) => setState(() => _isLoading = false),
        onWebResourceError: (error) => setState(() {
          _isLoading = false;
          _hasError = true;
        }),
      ))
      ..loadRequest(
        Uri.parse('https://mhbscmsc.vercel.app'),
        headers: {'Cache-Control': 'no-cache'},
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        title: const Text('SPPU Syllabus Portal',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() => _hasError = false);
              _controller.reload();
            },
          )
        ],
      ),
      body: Stack(children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: Color(0xFFFF6600))),
        if (_hasError)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('No Internet Connection',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6600)),
                  onPressed: () {
                    setState(() => _hasError = false);
                    _controller.reload();
                  },
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}
