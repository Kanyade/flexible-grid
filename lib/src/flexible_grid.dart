part of '../flexible_grid.dart';

/// A flexible grid layout widget that arranges its children in a grid with
/// customizable column count, spacing, and optional row height enforcement.
/// code snippet:
/// ```dart
/// FlexibleGrid(
///   columnCount: 3,
///   enforceRowHeight: true,
///   children: [
///     FlexibleGridItemProxy(columnSpan: 2, child: Container(color: Colors.green, height: 80)),
///     Container(color: Colors.red),
///     Container(color: Colors.blue, height: 150),
///     Container(color: Colors.yellow, height: 120),
///     Container(color: Colors.purple, height: 100),
///   ],
/// )
/// ```
class FlexibleGrid extends MultiChildRenderObjectWidget {
  const FlexibleGrid({
    super.key,
    required super.children,
    this.columnCount = 2,
    this.horizontalSpacing = 0,
    this.verticalSpacing = 0,
    this.enforceRowHeight = false,
    this.useTightConstraints = false,
  }) : assert(columnCount > 0, 'columnCount must be greater than zero'),
       assert(horizontalSpacing >= 0, 'horizontalSpacing cannot be negative'),
       assert(verticalSpacing >= 0, 'verticalSpacing cannot be negative');

  /// The number of columns in the grid.
  final int columnCount;

  /// Whether to enforce uniform row heights based on the tallest item in each row.
  /// If true, all items in a row will have the same height.
  /// If false, items can have varying heights.
  /// Defaults to false.
  /// Check out [useTightConstraints] for more control over item sizing.
  final bool enforceRowHeight;

  /// Whether to use tight constraints for grid items.
  /// If true, items will be forced to fill their allocated space and cannot request more.
  /// Defaults to false.
  /// Only applicable when [enforceRowHeight] is true.
  /// If you are using this option, you need to rebuild the grid when item sizes change
  /// yourself, as the grid won't repaint itself automatically.
  /// This is useful to stretch out items with fixed sizes to fill the grid space.
  final bool useTightConstraints;

  /// The horizontal spacing between grid items.
  final double horizontalSpacing;

  /// The vertical spacing between grid items.
  final double verticalSpacing;

  @override
  RenderFlexibleGrid createRenderObject(BuildContext context) => RenderFlexibleGrid(
    columnCount: columnCount,
    enforceRowHeight: enforceRowHeight,
    useTightConstraints: useTightConstraints,
    horizontalSpacing: horizontalSpacing,
    verticalSpacing: verticalSpacing,
  );

  @override
  void updateRenderObject(BuildContext context, RenderFlexibleGrid renderObject) {
    renderObject
      ..columnCount = columnCount
      ..horizontalSpacing = horizontalSpacing
      ..verticalSpacing = verticalSpacing
      ..enforceRowHeight = enforceRowHeight
      ..useTightConstraints = useTightConstraints;
  }
}

class RenderFlexibleGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FlexibleGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlexibleGridParentData> {
  RenderFlexibleGrid({
    required this.columnCount,
    required this.enforceRowHeight,
    required this.useTightConstraints,
    required this.horizontalSpacing,
    required this.verticalSpacing,
  });

  int columnCount;
  bool enforceRowHeight;
  bool useTightConstraints;
  double horizontalSpacing;
  double verticalSpacing;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexibleGridParentData) {
      child.parentData = FlexibleGridParentData();
    }
  }

  @override
  void performLayout() {
    final maxWidth = constraints.maxWidth;
    final totalSpacing = horizontalSpacing * (columnCount - 1);
    final columnWidth = (maxWidth - totalSpacing) / columnCount;

    double x = 0;
    double y = 0;

    int currentColumn = 0;
    double maxRowHeight = 0;

    RenderBox? child = firstChild;
    // Layout each child
    while (child != null && child.parentData is FlexibleGridParentData) {
      final childParentData = child.parentData! as FlexibleGridParentData;

      final isSpanningItem = child is FlexibleGridItemProxyBox;
      final itemColumnSpan = isSpanningItem ? min(columnCount, child.columnSpan) : 1;

      final childWidth = isSpanningItem
          ? (columnWidth * itemColumnSpan) + (horizontalSpacing * (itemColumnSpan - 1))
          : columnWidth;

      // Check if the item fits in the current row
      if (currentColumn + itemColumnSpan > columnCount) {
        // Move to the next row if the item would exceed the column count
        y += maxRowHeight + verticalSpacing;
        x = 0;
        currentColumn = 0;
        maxRowHeight = 0;
      }
      late final double rowHeight;

      // Determine row height
      // If enforceRowHeight is true, calculate the max height for the row
      if (enforceRowHeight && itemColumnSpan < columnCount) {
        if (currentColumn == 0) {
          // Calculate max height for this row by looking ahead at remaining items in the row
          double tempMaxHeight = 0;
          RenderBox? tempChild = child;
          int tempColumn = currentColumn;

          while (tempChild != null && tempColumn < columnCount) {
            final tempParentData = tempChild.parentData! as FlexibleGridParentData;
            final isTempSpanning = tempChild is FlexibleGridItemProxyBox;

            final tempSpan = isTempSpanning ? min(columnCount - tempColumn, tempChild.columnSpan) : 1;

            if (tempColumn + tempSpan > columnCount) break;

            final tempWidth = isTempSpanning
                ? (columnWidth * tempSpan) + (horizontalSpacing * (tempSpan - 1))
                : columnWidth;

            tempChild.layout(BoxConstraints(maxWidth: tempWidth), parentUsesSize: true);
            if (tempChild.size.height > tempMaxHeight) {
              tempMaxHeight = tempChild.size.height;
            }

            tempColumn += tempSpan;
            tempChild = tempParentData.nextSibling;
          }

          maxRowHeight = tempMaxHeight;
          rowHeight = maxRowHeight;
        } else {
          rowHeight = maxRowHeight;
        }
      } else {
        rowHeight = constraints.maxHeight;
      }

      final childConstraints = switch ((enforceRowHeight, itemColumnSpan < columnCount, useTightConstraints)) {
        (true, true, true) => BoxConstraints.tightFor(width: childWidth, height: rowHeight),
        _ => BoxConstraints(maxWidth: childWidth, maxHeight: rowHeight),
      };

      child.layout(childConstraints, parentUsesSize: true);
      childParentData.offset = Offset(x, y);

      maxRowHeight = maxRowHeight < child.size.height ? child.size.height : maxRowHeight;

      currentColumn += itemColumnSpan;
      if (currentColumn < columnCount) {
        // Move to next column
        x += (columnWidth * itemColumnSpan) + (horizontalSpacing * itemColumnSpan);
      } else {
        // Move to next row
        y += maxRowHeight + (childParentData.nextSibling != null ? verticalSpacing : 0);
        x = 0;
        currentColumn = 0;
        maxRowHeight = 0;
      }

      child = childParentData.nextSibling;
    }

    size = constraints.constrain(Size(maxWidth, y + (currentColumn == 0 ? 0 : maxRowHeight)));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null && child.parentData is FlexibleGridParentData) {
      final childParentData = child.parentData! as FlexibleGridParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final childParentData = child.parentData! as FlexibleGridParentData;
      final isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (result, transformed) => child!.hitTest(result, position: transformed),
      );
      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}

class FlexibleGridParentData extends ContainerBoxParentData<RenderBox> {}
