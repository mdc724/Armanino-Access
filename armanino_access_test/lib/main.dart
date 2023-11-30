//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';



void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
  
  // Initiate splash screen
  FlutterNativeSplash();
}



class WebViewApp extends StatelessWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Once open, this displays persistently at the top
        title: const Text('Armanino Access'),
      ),
      body: const WebViewPage(),
    );
  }
}



class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}



// Launch web page
class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse('https://accesstest.armaninollp.com/arm_access'),
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
        ),
      ),
      onWebViewCreated: (InAppWebViewController controller) {},
    );
  }
}

