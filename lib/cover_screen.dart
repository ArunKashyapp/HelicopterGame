
import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  const MyCoverScreen({
    super.key,
    required this.gamHasStarted,
  });

  final bool gamHasStarted;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.5),
      child: Text(
        gamHasStarted ? "" : "T A P  T O  P L A Y",
        style: const TextStyle(
            color: Colors.white, fontSize: 20),
      ),
    );
  }
}

