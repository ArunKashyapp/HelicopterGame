import 'dart:async';

import 'package:flappybird/barrier.dart';
import 'package:flappybird/cover_screen.dart';
import 'package:flappybird/my_bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double birdHeight = 0.1;
  double birdWidth = 0.1;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;

  bool gamHasStarted = false;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void startGame() {
    gamHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        gamHasStarted = false;
        _showDialogBox();
      }

      moveMap();

      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gamHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialogBox() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRect(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                    "P L A Y  A G A I N",
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void jump() {
    if (gamHasStarted) {
      setState(() {
        time = 0;
        initialPos = birdY;
      });
    }
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        gamHasStarted ? jump() : startGame();
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                        birdY: birdY,
                      ),
                      MyCoverScreen(gamHasStarted: gamHasStarted),
                      Mybarrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          barrierX: barrierX[0],
                          isThisBottomBarrier: false),
                      Mybarrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          barrierX: barrierX[0],
                          isThisBottomBarrier: true),
                      Mybarrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          barrierX: barrierX[1],
                          isThisBottomBarrier: false),
                      Mybarrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          barrierX: barrierX[1],
                          isThisBottomBarrier: true),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
