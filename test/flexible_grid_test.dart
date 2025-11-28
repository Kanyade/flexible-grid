import 'package:flexible_grid/flexible_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('1. Basic Grid Behavior (No FlexibleGridItemProxy Widget):', () {
    testWidgets('Renders all children in correct row/column order with default columnCount = 2', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 2,
              children: [
                Container(key: const Key('item0'), width: 100, height: 50, color: Colors.red),
                Container(key: const Key('item1'), width: 100, height: 50, color: Colors.blue),
                Container(key: const Key('item2'), width: 100, height: 50, color: Colors.green),
                Container(key: const Key('item3'), width: 100, height: 50, color: Colors.yellow),
              ],
            ),
          ),
        ),
      );

      final item0 = tester.getTopLeft(find.byKey(const Key('item0')));
      final item1 = tester.getTopLeft(find.byKey(const Key('item1')));
      final item2 = tester.getTopLeft(find.byKey(const Key('item2')));
      final item3 = tester.getTopLeft(find.byKey(const Key('item3')));

      // Row 0: item0 and item1 should be side by side
      expect(item0.dy, equals(item1.dy)); // same row
      expect(item0.dx, lessThan(item1.dx)); // item0 to the left

      // Row 1: item2 and item3 should be side by side
      expect(item2.dy, equals(item3.dy)); // same row
      expect(item2.dx, lessThan(item3.dx)); // item2 to the left

      // Row 1 should be below Row 0
      expect(item2.dy, greaterThan(item0.dy));
      expect(item3.dy, greaterThan(item1.dy));
    });

    testWidgets('Applies horizontalSpacing correctly between items when non-zero', (tester) async {
      const horizontalSpacing = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FlexibleGrid(
                columnCount: 2,
                horizontalSpacing: horizontalSpacing,
                children: [
                  Container(key: const Key('item0'), height: 50, color: Colors.red),
                  Container(key: const Key('item1'), height: 50, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      );

      final item0Rect = tester.getRect(find.byKey(const Key('item0')));
      final item1Rect = tester.getRect(find.byKey(const Key('item1')));

      // Calculate expected spacing
      final actualSpacing = item1Rect.left - item0Rect.right;
      expect(actualSpacing, equals(horizontalSpacing));
    });

    testWidgets('Applies verticalSpacing correctly between item rows', (tester) async {
      const verticalSpacing = 30.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 2,
              verticalSpacing: verticalSpacing,
              children: [
                Container(key: const Key('item0'), height: 50, color: Colors.red),
                Container(key: const Key('item1'), height: 50, color: Colors.blue),
                Container(key: const Key('item2'), height: 50, color: Colors.green),
                Container(key: const Key('item3'), height: 50, color: Colors.yellow),
              ],
            ),
          ),
        ),
      );

      final item0Rect = tester.getRect(find.byKey(const Key('item0')));
      final item2Rect = tester.getRect(find.byKey(const Key('item2')));

      // Calculate vertical spacing between rows
      final actualSpacing = item2Rect.top - item0Rect.bottom;
      expect(actualSpacing, equals(verticalSpacing));
    });

    testWidgets('Expands into multiple rows correctly when children > columnCount', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 3,
              children: [
                Container(key: const Key('item0'), height: 50, color: Colors.red),
                Container(key: const Key('item1'), height: 50, color: Colors.blue),
                Container(key: const Key('item2'), height: 50, color: Colors.green),
                Container(key: const Key('item3'), height: 50, color: Colors.yellow),
                Container(key: const Key('item4'), height: 50, color: Colors.purple),
              ],
            ),
          ),
        ),
      );

      final item0 = tester.getTopLeft(find.byKey(const Key('item0')));
      final item1 = tester.getTopLeft(find.byKey(const Key('item1')));
      final item2 = tester.getTopLeft(find.byKey(const Key('item2')));
      final item3 = tester.getTopLeft(find.byKey(const Key('item3')));
      final item4 = tester.getTopLeft(find.byKey(const Key('item4')));

      // Row 0: item0, item1, item2 should be on same row
      expect(item0.dy, equals(item1.dy));
      expect(item1.dy, equals(item2.dy));

      // Row 1: item3, item4 should be on same row
      expect(item3.dy, equals(item4.dy));

      // Row 1 should be below Row 0
      expect(item3.dy, greaterThan(item0.dy));
      expect(item4.dy, greaterThan(item1.dy));
    });

    testWidgets('Handles empty children list (renders nothing, no exceptions)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 2,
              children: [],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final gridSize = tester.getSize(find.byType(FlexibleGrid));
      expect(gridSize.height, equals(0));
    });
  });

  group('2. FlexibleGridItemProxy Widget Basic Placement:', () {
    testWidgets('FlexibleGridItemProxy widget with span = 1 behaves like a normal widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FlexibleGrid(
                columnCount: 2,
                children: [
                  FlexibleGridItemProxy(
                    columnSpan: 1,
                    child: Container(key: const Key('span1'), height: 50, color: Colors.red),
                  ),
                  Container(key: const Key('normal'), height: 50, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      );

      final span1Rect = tester.getRect(find.byKey(const Key('span1')));
      final normalRect = tester.getRect(find.byKey(const Key('normal')));

      // Both should be on the same row
      expect(span1Rect.top, equals(normalRect.top));

      // Both should have the same width (single column width)
      expect(span1Rect.width, normalRect.width);
    });

    testWidgets('FlexibleGridItemProxy widget placed as the first child spans expected number of columns',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FlexibleGrid(
                columnCount: 3,
                horizontalSpacing: 10,
                children: [
                  FlexibleGridItemProxy(
                    columnSpan: 2,
                    child: Container(key: const Key('span2'), height: 50, color: Colors.red),
                  ),
                  Container(key: const Key('item1'), height: 50, color: Colors.blue),
                  Container(key: const Key('item2'), height: 50, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
      );

      final span2Rect = tester.getRect(find.byKey(const Key('span2')));
      final item1Rect = tester.getRect(find.byKey(const Key('item1')));

      // Span widget should be wider than a single column
      expect(span2Rect.width, greaterThan(item1Rect.width));

      // Expected width: 2 columns + 1 spacing
      final expectedWidth = (item1Rect.width * 2) + 10;
      expect(span2Rect.width, expectedWidth);
    });

    testWidgets('FlexibleGridItemProxy widget placed in the middle of a row fits correctly if space remains',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FlexibleGrid(
                columnCount: 4,
                children: [
                  Container(key: const Key('item0'), height: 50, color: Colors.red),
                  FlexibleGridItemProxy(
                    columnSpan: 2,
                    child: Container(key: const Key('span2'), height: 50, color: Colors.blue),
                  ),
                  Container(key: const Key('item2'), height: 50, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
      );

      final item0 = tester.getTopLeft(find.byKey(const Key('item0')));
      final span2 = tester.getTopLeft(find.byKey(const Key('span2')));
      final item2 = tester.getTopLeft(find.byKey(const Key('item2')));

      // All should be on the same row
      expect(item0.dy, equals(span2.dy));
      expect(span2.dy, equals(item2.dy));

      // Should be in correct horizontal order
      expect(item0.dx, lessThan(span2.dx));
      expect(span2.dx, lessThan(item2.dx));
    });

    testWidgets('FlexibleGridItemProxy widget placed at end of row moves to next row if not enough remaining columns',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 3,
              children: [
                Container(key: const Key('item0'), height: 50, color: Colors.red),
                Container(key: const Key('item1'), height: 50, color: Colors.blue),
                FlexibleGridItemProxy(
                  columnSpan: 2,
                  child: Container(key: const Key('span2'), height: 50, color: Colors.green),
                ),
                Container(key: const Key('item3'), height: 50, color: Colors.yellow),
              ],
            ),
          ),
        ),
      );

      final item0 = tester.getTopLeft(find.byKey(const Key('item0')));
      final item1 = tester.getTopLeft(find.byKey(const Key('item1')));
      final span2 = tester.getTopLeft(find.byKey(const Key('span2')));
      final item3 = tester.getTopLeft(find.byKey(const Key('item3')));

      // item0 and item1 should be on the first row
      expect(item0.dy, equals(item1.dy));

      // span2 should be on a new row (below item0 and item1)
      expect(span2.dy, greaterThan(item0.dy));

      // item3 should be on the same row as span2
      expect(span2.dy, equals(item3.dy));
    });
  });

  group('3. FlexibleGridItemProxy Widget Larger Than Row or Invalid Span Values:', () {
    testWidgets('Span > columnCount — widget clamps to max columnCount', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FlexibleGrid(
                columnCount: 3,
                children: [
                  FlexibleGridItemProxy(
                    columnSpan: 5, // Greater than columnCount
                    child: Container(key: const Key('span5'), height: 50, color: Colors.red),
                  ),
                  Container(key: const Key('item1'), height: 50, color: Colors.blue),
                  Container(key: const Key('item2'), height: 50, color: Colors.red),
                  Container(key: const Key('item3'), height: 50, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
      );

      final span5Rect = tester.getRect(find.byKey(const Key('span5')));
      final item1Rect = tester.getRect(find.byKey(const Key('item1')));
      final item2Rect = tester.getRect(find.byKey(const Key('item2')));
      final item3Rect = tester.getRect(find.byKey(const Key('item3')));
      final gridRect = tester.getRect(find.byType(FlexibleGrid));

      // Widget should take full width (clamped to columnCount)
      expect(span5Rect.width, equals(gridRect.width));

      // Span widget should be the same width as all three containers combined
      final combinedWidth = item1Rect.width + item2Rect.width + item3Rect.width;
      expect(span5Rect.width, equals(combinedWidth));
    });

    testWidgets('Span = 0 or negative — verify widget throws assert error', (tester) async {
      expect(
        () => FlexibleGridItemProxy(
          columnSpan: 0,
          child: Container(),
        ),
        throwsAssertionError,
      );

      expect(
        () => FlexibleGridItemProxy(
          columnSpan: -1,
          child: Container(),
        ),
        throwsAssertionError,
      );
    });
  });

  group('4. Spacing + FlexibleGridItemProxy Interaction:', () {
    testWidgets(
        'Horizontal spacing applied correctly for FlexibleGridItemProxy widgets (no spacing inside their span area)',
        (tester) async {
      const horizontalSpacing = 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 420,
              child: FlexibleGrid(
                columnCount: 3,
                horizontalSpacing: horizontalSpacing,
                children: [
                  FlexibleGridItemProxy(
                    columnSpan: 2,
                    child: Container(key: const Key('span2'), height: 50, color: Colors.red),
                  ),
                  Container(key: const Key('item1'), height: 50, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      );

      final span2Rect = tester.getRect(find.byKey(const Key('span2')));
      final item1Rect = tester.getRect(find.byKey(const Key('item1')));

      // Calculate spacing between span widget and next item
      final actualSpacing = item1Rect.left - span2Rect.right;
      expect(actualSpacing, horizontalSpacing);

      // Span widget should include spacing in its width calculation
      // Width = 2 * columnWidth + 1 * spacing (between the 2 columns it spans)
      final columnWidth = (420 - (2 * horizontalSpacing)) / 3;
      final expectedSpanWidth = (2 * columnWidth) + horizontalSpacing;
      expect(span2Rect.width, expectedSpanWidth);
    });
  });

  group('5. enforceRowHeight Behavior:', () {
    testWidgets('When enforceRowHeight = false, each item\'s height is based on its own intrinsic height',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 2,
              enforceRowHeight: false,
              children: [
                Container(
                  key: const Key('item0'),
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  key: const Key('item1'),
                  height: 100,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      );

      final item0Rect = tester.getRect(find.byKey(const Key('item0')));
      final item1Rect = tester.getRect(find.byKey(const Key('item1')));

      // Items should have their own heights
      expect(item0Rect.height, equals(50));
      expect(item1Rect.height, equals(100));
    });

    testWidgets('When enforceRowHeight = true, all items in a row match the tallest item in that row', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexibleGrid(
              columnCount: 2,
              enforceRowHeight: true,
              children: [
                // Unbounded Align has the child with smaller height in the row
                Align(
                  key: const Key('item0'),
                  alignment: Alignment.topCenter,
                  child: Container(height: 50, color: Colors.red),
                ),
                Container(
                  key: const Key('item1'),
                  height: 100,
                  color: Colors.blue,
                ),
                // Unbounded Align has the child with bigger height in the row
                Align(
                  key: const Key('item2'),
                  alignment: Alignment.topCenter,
                  child: Container(height: 75, color: Colors.yellow),
                ),
                Container(
                  key: const Key('item3'),
                  height: 60,
                  color: Colors.green,
                ),
                // Simple containers in the last row
                Container(
                  key: const Key('item4'),
                  height: 40,
                  color: Colors.green,
                ),
                Container(
                  key: const Key('item5'),
                  height: 20,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      );

      final item0Rect = tester.getRect(find.byKey(const Key('item0')));
      final item1Rect = tester.getRect(find.byKey(const Key('item1')));
      final item2Rect = tester.getRect(find.byKey(const Key('item2')));
      final item3Rect = tester.getRect(find.byKey(const Key('item3')));
      final item4Rect = tester.getRect(find.byKey(const Key('item4')));
      final item5Rect = tester.getRect(find.byKey(const Key('item5')));

      expect(item0Rect.height, equals(100));
      expect(item1Rect.height, equals(100));

      expect(item2Rect.height, equals(75));
      expect(item3Rect.height, equals(75));

      expect(item4Rect.height, equals(40));
      expect(item5Rect.height, equals(40));
    });
  });

  group('6. Behavior With Different Column Counts:', () {
    testWidgets('columnCount = 1 — span widget should behave as full width and produce vertical list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FlexibleGrid(
                columnCount: 1,
                children: [
                  Container(key: const Key('item0'), height: 50, color: Colors.red),
                  FlexibleGridItemProxy(
                    columnSpan: 2,
                    child: Container(key: const Key('span2'), height: 50, color: Colors.blue),
                  ),
                  Container(key: const Key('item2'), height: 50, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
      );

      final item0 = tester.getTopLeft(find.byKey(const Key('item0')));
      final span2 = tester.getTopLeft(find.byKey(const Key('span2')));
      final item2 = tester.getTopLeft(find.byKey(const Key('item2')));

      // All items should be vertically stacked
      expect(item0.dx, equals(0));
      expect(span2.dx, equals(0));
      expect(item2.dx, equals(0));

      // Each on a different row
      expect(span2.dy, greaterThan(item0.dy));
      expect(item2.dy, greaterThan(span2.dy));

      // All should be full width
      final item0Rect = tester.getRect(find.byKey(const Key('item0')));
      final span2Rect = tester.getRect(find.byKey(const Key('span2')));
      expect(item0Rect.width, equals(400));
      expect(span2Rect.width, equals(400));
    });

    testWidgets('columnCount = large number (e.g., 10) — ensure spans still respected and layout remains correct',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              child: FlexibleGrid(
                columnCount: 10,
                children: [
                  ...List.generate(8, (i) => Container(key: Key('item$i'), height: 50)),
                  FlexibleGridItemProxy(
                    columnSpan: 3,
                    child: Container(key: const Key('span3'), height: 50, color: Colors.red),
                  ),
                  Container(key: const Key('item9'), height: 50, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      );

      // All first 8 items should be on the same row
      final item0 = tester.getTopLeft(find.byKey(const Key('item0')));
      final item7 = tester.getTopLeft(find.byKey(const Key('item7')));
      expect(item0.dy, equals(item7.dy));

      // Span widget and item9 should be on the same row (row 1)
      final span3 = tester.getTopLeft(find.byKey(const Key('span3')));
      final item9 = tester.getTopLeft(find.byKey(const Key('item9')));
      expect(span3.dy, equals(item9.dy));
      expect(span3.dy, greaterThan(item0.dy));
    });

    testWidgets('columnCount = 0 or negative — grid should throw assert error', (tester) async {
      expect(
        () => FlexibleGrid(
          columnCount: 0,
          children: const [],
        ),
        throwsAssertionError,
      );

      expect(
        () => FlexibleGrid(
          columnCount: -1,
          children: const [],
        ),
        throwsAssertionError,
      );
    });
  });
}
