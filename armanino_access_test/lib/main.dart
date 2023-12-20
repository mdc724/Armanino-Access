// Dart Components
import 'dart:async';
import 'dart:convert';

// Flutter and Web View components
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'WebController.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Firebase components
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:armanino_access_test/api/firebase_api.dart'; // TODO:: Update with Proper App Package Reference
import 'package:firebase_messaging/firebase_messaging.dart';

// Device Registration components
import 'api/RegisterDevice.dart';
import 'package:http/http.dart' as http;



// Global key to access the context and WebView controller
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



// Set main as async
void main() async {

  // Ensure that Firebase is initialized before runApp is called
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // Initialize in-app notifications from firebase_api.dart
  await FirebaseApi().initNotifications();

  // Handle background messaging - must be initialized here
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  
  // Run app
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey, // Assign the navigatorKey to MaterialApp
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
  
  // Initiate splash screen
  FlutterNativeSplash();
}





// Handle background messages - must be done in the main.dart file, since the app is in a background state
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print("_handleBackgroundMessage triggered"); // message.data['url']
}





// Initialize app as webview
class WebViewApp extends StatelessWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO:: Update with Application Title
        title: const Text('Armanino Access'),
      ),
      body: const WebViewPage(),
    );
  }
}





// Initialize page within webview
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}





// Navigate to first entry page upon load
class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        // TODO:: Update with Initial Load Destination URL
        url: Uri.parse('https://accesstest.armaninollp.com/arm_access'),
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
        ),
      ),
      onWebViewCreated: (InAppWebViewController controller) {
        _controller = controller;

        // Store in Web Controller file so this initialized web view can be accessed within firebase_api.dart
        WebController.controller =_controller;
      },
      // Add the onLoadStop callback to execute JavaScript after the page has loaded
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        if (_controller != null) {
          await _extractValue();
        }
      },
    );
  }

 





  // Extract user_name input once it is keyed in
  Future<void> _extractValue() async {
    if (_controller != null) {
      // Initialize extractedValue and inputComplete outside the JavaScript block
      //String? emailInput = "";
      //bool inputComplete = false;

      // Interact with the web application via JavaScript
      await _controller!.evaluateJavascript(source: '''
        // Find the input element with the ID 'okta-signin-username'
        var emailInput = document.getElementById('okta-signin-username');
        var inputComplete = false;
        
        if (emailInput) {
          // Add an event listener for the 'blur' event, when the input is clicked or tabbed off of
          emailInput.addEventListener('blur', function() {
            // Set inputComplete to true to indicate the value has been fully completed
            inputComplete = true;
          });
        }
      ''');



      // Create a periodic timer that prints extractedValue every 2 seconds
      Timer.periodic(Duration(seconds: 1), (Timer timer) async {

        // Retrieve the updated value using evaluateJavascript
        String? updatedValue = await _controller!.evaluateJavascript(
          source: "document.getElementById('okta-signin-username').value;",
        );
        
        // Retrieve the completed value using evaluateJavascript
        bool? completedValue = await _controller!.evaluateJavascript(
          source: "inputComplete",
        );

        // Check if the value has changed before printing
        if (updatedValue != RegisterDevice.emailValue && completedValue == true) {
          
          // Reset variable if so
          RegisterDevice.emailValue = updatedValue;

          // Print token and email values
          print('Variable Token: ${RegisterDevice.tokenValue}');
          print('Variable Email: ${RegisterDevice.emailValue}');

          // Call sendData function with updated values
          await sendData(RegisterDevice.tokenValue, RegisterDevice.emailValue);
        }
      });
    }
  }





  // Send data to custom ServiceNow "Register Mobile Device" API
  Future<void> sendData(String? tokenValue, String? emailValue) async {

    // Replace this with your actual JSON data
    Map<String, dynamic> jsonData = {
      'Token': tokenValue,
      'Email': emailValue,
    };

    // TODO:: Update with Mobile Device Registration REST API
    final url = Uri.parse('https://armaninollptest.service-now.com/api/arman/register_mobile_device/register');


    // TODO:: Replace 'your_username' and 'your_password' with your actual credentials
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('svc.firebasemessaging::@>L)z(s^23?@(xi3q#)cSKu'));


    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      },
      body: jsonEncode(jsonData),
    );


    // If web service receives valid connection response
    if (response.statusCode == 200) {
      // Successful response, parse the data if needed
      print('Response data: ${response.body}');
    }
    else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }
}





// SIMPLE WEB PAGE LOAD VERSION - NO FIREBASE MESSAGING COMPONENTS
/*
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
*/

