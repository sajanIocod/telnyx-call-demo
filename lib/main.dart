import 'package:flutter/material.dart';
import 'package:telnyx_call/telnyx_function.dart';

import 'call_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              devicePixelRatio: 1,
              alwaysUse24HourFormat: true,
              textScaler: const TextScaler.linear(1),
            ),
            child: child!),
        home: const CallScreen());
  }
}

setup() {
  TelnyxConfiguration().connect();
}
