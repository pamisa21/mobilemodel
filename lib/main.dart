import 'package:flutter/material.dart';
import 'package:imagerecognitiontemplate/choose_image_screen.dart';
import 'package:imagerecognitiontemplate/home_screen.dart';
import 'package:imagerecognitiontemplate/realtime_cam_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => const HomeScreen(),
      '/realtime': (context) => const RealtimeCamScreen(),
      '/image': (context) => const ChooseImageScreen(),
    },
  ));
}

