import 'dart:math' show pi;

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
      super.initState();

      controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );

      rotationAnimation = Tween<double>(begin: 0, end: 0.5)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: controller.value * 2.0 * pi,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // top
                const Positioned(top: 200, child: Circle()),
                // bottom
                const Positioned(bottom: 200, child: Circle()),
                // left
                const Positioned(left: 0, child: Circle()),
                //right
                Positioned(right: 0,
                    child: GestureDetector(
                      onVerticalDragUpdate: (_){
                        controller.forward();
                      },
                        child: Circle(title: 'One',)),
                ),
                //center
                const Center(child: Circle())
              ],
            ),
          );
        }
      ),
    );
  }
}

class Circle extends StatelessWidget {
  const Circle({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Text(title ?? 'C'),
    );
  }
}
