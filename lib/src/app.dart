import 'package:flutter/material.dart';
import 'package:todolistapp/screens/home_screen.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent
      ),
      home: HomeScreen(),
    );
  }
}
