import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:api_firebase/firebase_options.dart';
import 'package:api_firebase/screen/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyBAQgsWGD3k18hxHFZT3Rqj9hw0CS6KRQM",
  //     appId: "1:457498760975:android:b02842985ce24e0d73907a",
  //     messagingSenderId: "XXX",
  //     projectId: "fir-flutter-demo-cee54",
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
