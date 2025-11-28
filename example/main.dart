import 'package:flexible_grid/flexible_grid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Demo());
}

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flexible Grid Demo'),
        ),
        body: FlexibleGrid(
          columnCount: 3,
          enforceRowHeight: true,
          children: [
            FlexibleGridItemProxy(
              columnSpan: 2,
              child: Container(
                color: Colors.green,
                height: 100,
              ),
            ),
            Container(color: Colors.red, height: 75),
            Container(color: Colors.blue, height: 150),
            Container(color: Colors.yellow, height: 125),
            Container(color: Colors.purple, height: 100),
          ],
        ),
      ),
    );
  }
}
