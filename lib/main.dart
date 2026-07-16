import 'package:flutter/material.dart';
import 'dart:async';
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
  int _loadAttempt = 0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/112.0 Mobile Safari/537.36')
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _isLoading = false),
        onWebResourceError: (error) {
          if (_loadAttempt < 3) {
            _loadAttempt++;
            Future.delayed(const Duration(seconds: 2), () {
              _controller.reload();
            });
          }
        },
      ))
      ..loadRequest(Uri.parse('https://mhbscmsc.vercel.app/'));
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
              _loadAttempt = 0;
              _controller.reload();
            },
          )
        ],
      ),
      body: Stack(children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: Color(0xFFFF6600))),
      ]),
    );
  }
}
