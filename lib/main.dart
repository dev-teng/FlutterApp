import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated when you set up Firebase CLI
import 'package:my_project/login_screen.dart';
import 'home.dart';


// Without this, Firebase Auth will NOT work.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  //Initially false, meaning the user is logged out.
  bool isLoggedIn = false;

  //_login() and _logout() change the isLoggedIn value and update the screen.

  void _login() {
    //setState() is a method used to tell the framework: “Hey, something in the state of this widget has changed. Please rebuild the widget so the UI reflects the new state.”
    setState(() {
      isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override // “Hey, this function already exists in the parent class, but I’m writing my own version of it here.”
  Widget build(BuildContext context) {
    return MaterialApp(
      //If the user is logged in, show the Home screen.
      //If not, show the LoginScreen.
      //The login/logout functions are passed as callbacks.
      //used ternary operator
      //onLogout is a callback function, the Home widget can call this function when the user clicks logout
      home: isLoggedIn ? Home(onLogout: _logout) : LoginScreen(onLogin: _login),
      debugShowCheckedModeBanner: false,
    );
  }
}


