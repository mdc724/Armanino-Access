// Flutter and Web View components
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../WebController.dart';

// Firebase components
import 'package:firebase_messaging/firebase_messaging.dart';

// Device Registration components
import 'RegisterDevice.dart';



// Global key to access the context and WebView controller
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



// Initialize Firebase Messaging components
class FirebaseApi {

  // Get Firebase Messaging instance
  final _firebaseMessaging = FirebaseMessaging.instance;


  
  // Initialize push notifications
  Future<void> initNotifications() async {
    
    // Request permission from user to issue Firebase notifications
    await _firebaseMessaging.requestPermission();

    // Get user's device token to pair the user to the device in ServiceNow
    RegisterDevice.tokenValue = await _firebaseMessaging.getToken();
    print('Variable Token: ${RegisterDevice.tokenValue}');

    // Listen for Firebase Messages
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenMessage);
  }



  // Handle message for app when app is in a terminated state
  void _handleInitialMessage(RemoteMessage? message) async {
    print("_handleInitialMessage triggered");
  }


  // Handle message for app when app is opened
  void _handleForegroundMessage(RemoteMessage? message) async {
    print("_handleForegroundMessage triggered");
  }


  // Handle opening action of a message when app is in the background
  void _handleOpenMessage(RemoteMessage? message) async {
    print("_handleOpenMessage triggered");

    
    // If message is null, escape function
    if (message == null) {
      return;
    }


    // Create JSON object for parsing
    Map<String, dynamic> jsonData = {
      'notification': message.notification,
      'data': message.data   
    };


    // If JSON data is not empty
    if (jsonData['data'] != null) {
      String url = jsonData['data']['url'];
      if (url.isNotEmpty) {

        // Launch in web view
        _openUrlInWebView(url); // navigatorKey
      }
    }
  }



  // Open notifications in the app's web view with the URL provided
  void _openUrlInWebView(String URL) {

      // Prefix the URL with https://
      //URL = "https://" + URL;

      // Use the provided InAppWebViewController to navigate to the new URL
      WebController.controller?.loadUrl(urlRequest: URLRequest(url: Uri.parse(URL)));
    }
  }









/*
// CORRECT SAMPLE NOTIFICATION - ensures the app can be properly opened to the right context URL

{  
    "notification": {
        "title": "Schedule client meeting",
        "body": "Project Task Assignment:  Schedule client meeting\r\n\r\nTask Number: CSPRJTASK0068402\r\nSummary: Schedule client meeting\r\nAssigned to: Mike Cornell\r\nAdditional Assignee List:  Mike Cornell"
    },

    "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default", 
        "status": "done",
        "screen": "screenA",
        "url": "accesstest.armaninollp.com/arm_access?id=project_task_detail&table=customer_project_task&sys_id=d0fe587097847910a59e7f971153afd9"
    },

    "registration_ids":["f2GHEPhKSXyLKMDHMATRWF:APA91bFct1F5q5F1mh70fj7aWFWZmcNq9ZS89N9oTrpqTzRQ8bNz-iPsYvmLAge3MyzMuYOGH5UYTX-kN9xlZPUM8gvk5IWMPJ7cEwlT_6m-3U96thFldNQNZlS6hTnN41rijQWp7w3u"]
}
*/

