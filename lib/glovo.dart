import 'dart:math';

import 'package:flutter/material.dart';

import 'blob.dart';

class CircularDragDemo extends StatefulWidget {
  const CircularDragDemo({super.key});

  @override
  State<CircularDragDemo> createState() => _CircularDragDemoState();
}

class _CircularDragDemoState extends State<CircularDragDemo> {
  // Center of the circular path - initialize with a default value
  Offset _center = Offset.zero;

  // Radius of the circular path
  double _radius = 120;

  // Current angles of the circles in radians
  double angle1 = 0;
  double angle2 = pi / 2;
  double angle3 = pi;
  double angle4 = pi / 2 + pi;

  // The initial angle difference between circles (90 degrees or pi/2 radians)
  final double _angleDifference = pi / 2;

  // Track which circle is being dragged
  int? _draggedCircleIndex;

  // Previous angle during drag for calculating direction
  double? _previousDragAngle;

  // Flag to check if layout is ready
  bool _isLayoutReady = false;

  @override
  Widget build(BuildContext context) {
    // We'll calculate center in the build method once size is available
    if (!_isLayoutReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _center = Offset(MediaQuery.of(context).size.width / 2.2,
              MediaQuery.of(context).size.height / 3);
          _isLayoutReady = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linked Circles Demo'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [

          Positioned(
            left: _center.dx - 30,
            top: _center.dy - 25,
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Blob(color: Colors.orangeAccent),
            ),
          ),

          // Draw circles only when layout is ready
          if (_isLayoutReady) ...[
            _buildDraggableCircle(0, angle1, Colors.red),
            _buildDraggableCircle(1, angle2, Colors.blue),
            _buildDraggableCircle(2, angle3, Colors.yellow),
            _buildDraggableCircle(3, angle4, Colors.green),
          ] else
            const Center(child: CircularProgressIndicator()),


        ],
      ),
    );
  }

  Widget _buildDraggableCircle(int index, double angle, Color color) {
    // Calculate position on the circle
    final x = _center.dx + _radius * cos(angle);
    final y = _center.dy + _radius * sin(angle);

    return Positioned(
      left: x - 25,
      top: y - 25,
      child: GestureDetector(
        onPanStart: (details) {
          _startDrag(index, details);
        },
        onPanUpdate: (details) {
          _updateDrag(details);
        },
        onPanEnd: (_) {
          _endDrag();
        },
        child: Container(
          width: 100,
          height: 100,
          child: Blob(color: color),
        ),
      ),
    );
  }

  void _startDrag(int index, DragStartDetails details) {
    setState(() {
      _draggedCircleIndex = index;

      // Calculate the angle of the tap relative to the center
      final touchPosition = details.globalPosition;
      _previousDragAngle = atan2(
        touchPosition.dy - _center.dy,
        touchPosition.dx - _center.dx,
      );
    });
  }

  void _updateDrag(DragUpdateDetails details) {
    if (_draggedCircleIndex == null || _previousDragAngle == null) return;

    final touchPosition = details.globalPosition;
    final currentAngle = atan2(
      touchPosition.dy - _center.dy,
      touchPosition.dx - _center.dx,
    );

    // Calculate the angle change (delta)
    var angleDelta = currentAngle - _previousDragAngle!;

    // Handle angle wrap-around
    if (angleDelta > pi) {
      angleDelta -= 2 * pi;
    } else if (angleDelta < -pi) {
      angleDelta += 2 * pi;
    }

    setState(() {
      switch (_draggedCircleIndex) {
        case 0: // First circle dragged
          angle1 = (angle1 + angleDelta) % (2 * pi);
          angle2 = (angle1 + _angleDifference) % (2 * pi);
          angle3 = (angle2 + _angleDifference) % (2 * pi);
          angle4 = (angle3 + _angleDifference) % (2 * pi);
          break;

        case 1: // Second circle dragged
          angle2 = (angle2 + angleDelta) % (2 * pi);
          angle1 = (angle2 - _angleDifference) % (2 * pi);
          angle3 = (angle2 + _angleDifference) % (2 * pi);
          angle4 = (angle3 + _angleDifference) % (2 * pi);
          break;

        case 2: // Third circle dragged
          angle3 = (angle3 + angleDelta) % (2 * pi);
          angle2 = (angle3 - _angleDifference) % (2 * pi);
          angle1 = (angle2 - _angleDifference) % (2 * pi);
          angle4 = (angle3 + _angleDifference) % (2 * pi);
          break;

        case 3: // Fourth circle dragged
          angle4 = (angle4 + angleDelta) % (2 * pi);
          angle3 = (angle4 - _angleDifference) % (2 * pi);
          angle2 = (angle3 - _angleDifference) % (2 * pi);
          angle1 = (angle2 - _angleDifference) % (2 * pi);
          break;
      }

      // Ensure all angles are positive
      angle1 = angle1 < 0 ? angle1 + 2 * pi : angle1;
      angle2 = angle2 < 0 ? angle2 + 2 * pi : angle2;
      angle3 = angle3 < 0 ? angle3 + 2 * pi : angle3;
      angle4 = angle4 < 0 ? angle4 + 2 * pi : angle4;
    });
  }

  void _endDrag() {
    setState(() {
      _draggedCircleIndex = null;
      _previousDragAngle = null;
    });
  }
}

