part of '../../swiping_button.dart';

class SwipingButtonController {
  SwipingButtonController({
    this.maxHorizontalDrag = 200,
    this.maxVerticalDrag = 80,
    this.horizontalStartPosition = 0,
    this.verticalStartPosition = 0,
    this.reverseVertical = true,
    this.alignmentEnd = false,
    required TickerProvider vsync,
  }) {
    horizontalOffset.value = horizontalStartPosition;
    verticalOffset.value = verticalStartPosition;

    _horizontalController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 450),
    );
    _verticalController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 450),
    );
  }

  final double maxHorizontalDrag;
  final double maxVerticalDrag;
  final double horizontalStartPosition;
  final double verticalStartPosition;
  final bool reverseVertical;
  final bool alignmentEnd;

  final ValueNotifier<double> horizontalOffset = ValueNotifier(0);
  final ValueNotifier<double> verticalOffset = ValueNotifier(0);
  final ValueNotifier<bool> showSwipeBodyOne = ValueNotifier(true);

  late final AnimationController _horizontalController;
  late final AnimationController _verticalController;

  bool _allowHorizontalDrag = true;
  bool _allowVerticalDrag = true;

  void onHorizontalDragUpdate(DragUpdateDetails details, VoidCallback? onHorizontalDragCallback) {
    if (!_allowHorizontalDrag) return;

    _horizontalController.stop();
    final delta = alignmentEnd ? -details.delta.dx : details.delta.dx;
    horizontalOffset.value += delta;
    horizontalOffset.value = horizontalOffset.value.clamp(0.0, maxHorizontalDrag);

    if (horizontalOffset.value >= maxHorizontalDrag) {
      onHorizontalDragCallback?.call();
      _allowHorizontalDrag = false;
      animateBack();
    }
  }

  void onVerticalDragUpdate(DragUpdateDetails details, VoidCallback? onVerticalDragCallback) {
    if (!_allowVerticalDrag) return;

    _verticalController.stop();
    final delta = reverseVertical ? -details.delta.dy : details.delta.dy;
    verticalOffset.value += delta;
    verticalOffset.value = verticalOffset.value.clamp(0.0, maxVerticalDrag);

    if (verticalOffset.value >= maxVerticalDrag) {
      onVerticalDragCallback?.call();
      _allowVerticalDrag = false;
      animateBack();
    }
  }

  void onDragStart() {
    _allowHorizontalDrag = true;
    _allowVerticalDrag = true;
    showSwipeBodyOne.value = false;
  }

  void onDragEnd() {
    animateBack();
  }

  void animateBack() {
    late Animation<double> horizontalTween;
    late Animation<double> verticalTween;

    horizontalTween = Tween<double>(
      begin: horizontalOffset.value,
      end: horizontalStartPosition,
    ).animate(CurvedAnimation(parent: _horizontalController, curve: Curves.easeOutBack));

    verticalTween = Tween<double>(
      begin: verticalOffset.value,
      end: verticalStartPosition,
    ).animate(CurvedAnimation(parent: _verticalController, curve: Curves.easeOutBack));

    horizontalTween.addListener(() {
      horizontalOffset.value = horizontalTween.value;
      showSwipeBodyOne.value = true;
    });

    verticalTween.addListener(() {
      verticalOffset.value = verticalTween.value;
    });

    _horizontalController.forward(from: 0.0);
    _verticalController.forward(from: 0.0);
  }

  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    horizontalOffset.dispose();
    verticalOffset.dispose();
    showSwipeBodyOne.dispose();
  }
}
