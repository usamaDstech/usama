import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usama/app/on_boarding/on_boarding_screen.dart';
import 'package:usama/app/provider/home_provider.dart';

import 'app/home/home_screen.dart';
import 'app/provider/onBoarding_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Usama',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const OnBoardingScreen(),
          '/homeScreen': (context) => const HomeScreen(), // Replace with your actual HomeScreen
        },
      ),
    );
  }
}

