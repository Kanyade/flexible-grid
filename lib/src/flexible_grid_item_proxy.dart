part of '../flexible_grid.dart';

/// A proxy widget that allows a child to span multiple columns in a
/// [FlexibleGrid].
class FlexibleGridItemProxy extends SingleChildRenderObjectWidget {
  const FlexibleGridItemProxy({super.key, required super.child, this.columnSpan = 2})
      : assert(columnSpan > 0, 'columnSpan must be greater than zero');

  final int columnSpan;

  @override
  RenderObject createRenderObject(BuildContext context) => FlexibleGridItemProxyBox(columnSpan: columnSpan);

  @override
  void updateRenderObject(BuildContext context, FlexibleGridItemProxyBox renderObject) {
    renderObject.columnSpan = columnSpan;
  }
}

class FlexibleGridItemProxyBox extends RenderProxyBox {
  FlexibleGridItemProxyBox({required this.columnSpan});

  int columnSpan;
}
