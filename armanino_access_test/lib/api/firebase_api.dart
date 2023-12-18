import 'package:firebase_messaging/firebase_messaging.dart';



class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token (normally you would send this to your server)
    print('Token: $fCMToken');

    // function to handle received messages

    // function to initialize foreground and background settings
  }
}




/*
import 'package:firebase_messaging/firebase_messaging.dart';

class MyFirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initialize() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // Handle the incoming message when the app is in the foreground.
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // Handle the notification when the app is launched from a terminated state.
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // Handle the notification when the app is resumed from the background.
      },
    );
  }
}
*/

