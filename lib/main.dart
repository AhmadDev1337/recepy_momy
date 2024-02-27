// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'home/home.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? appOpenAd;

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: "ca-app-pub-8363980854824352/2610279448",
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        appOpenAd = ad;
        appOpenAd!.show();
        log('Ad onAdLoaded');
      }, onAdFailedToLoad: (error) {
        log('Open App ad failed to load: $error');
      }),
      orientation: AppOpenAd.orientationPortrait);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  loadAppOpenAd();
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
