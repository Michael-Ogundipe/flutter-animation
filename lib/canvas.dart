import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Cube extends StatefulWidget {
  const Cube({super.key});

  @override
  State<Cube> createState() => _CubeState();
}

class _CubeState extends State<Cube> with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late AnimationController zController;
  late Tween<double> animation;

  @override
  void initState() {
    super.initState();
    xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));

    animation = Tween<double>(
      begin: 0,
      end: pi * 2,
    );
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    zController.dispose();
    super.dispose();
  }

  double widthAndHeight = 100;

  @override
  Widget build(BuildContext context) {
    xController
      ..reset()
      ..repeat();
    yController
      ..reset()
      ..repeat();
    zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              AnimatedBuilder(
                animation: Listenable.merge([
                  xController,
                  yController,
                  zController,
                ]),
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(animation.evaluate(xController))
                      ..rotateY(animation.evaluate(yController))
                      ..rotateZ(animation.evaluate(zController)),
                    child: Stack(
                      children: [
                        // front
                        Container(
                          color: Colors.green,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                        // left side
                        Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()..rotateY(pi / 2),
                          child: Container(
                            color: Colors.red,
                            width: widthAndHeight,
                            height: widthAndHeight,
                          ),
                        ),
                        // right side
                        Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()..rotateY(-pi / 2),
                          child: Container(
                            color: Colors.blue,
                            width: widthAndHeight,
                            height: widthAndHeight,
                          ),
                        ),
                        // back
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(Vector3(0, 0, -widthAndHeight)),
                          child: Container(
                            color: Colors.purple,
                            width: widthAndHeight,
                            height: widthAndHeight,
                          ),
                        ),
                        // top side
                        Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()..rotateX(-pi / 2),
                          child: Container(
                            color: Colors.orange,
                            width: widthAndHeight,
                            height: widthAndHeight,

                          ),
                        ),
                        // bottom side
                        Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()..rotateX(pi / 2),
                          child: Container(
                            color: Colors.brown,
                            width: widthAndHeight,
                            height: widthAndHeight,

                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
