import 'package:flutter/material.dart';
import 'package:printer/counter.dart';

class BotN extends StatelessWidget {
  const BotN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(80)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Counter())),
            child: const CircleAvatar(
                radius: 100,
                backgroundColor: Colors.red,
                child: Text('Botón de pánico'))),
      ),
    );
  }
}
