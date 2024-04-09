import 'package:flutter/material.dart';
import 'package:telnyx_call/dialpad.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: const Column(
        children: [Text('Call Screen')],
      ),
      floatingActionButton: FloatingActionButton.large(
          child: const Icon(Icons.call),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DialPad()));
          }),
    );
  }
}
