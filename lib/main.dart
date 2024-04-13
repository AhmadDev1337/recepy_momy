// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recepy Momy',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
