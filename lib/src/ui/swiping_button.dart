part of '../../swiping_button.dart';

/// A customizable swipeable button supporting horizontal and vertical gestures.
/// When a max drag distance is reached, callbacks are triggered and the button returns to its original position.
class SwipingButton extends StatefulWidget {
  const SwipingButton({
    super.key,
    required this.mainButton,
    this.secondaryButton,
    this.showMainButton = true,
    this.maxHorizontalDrag = 200,
    this.maxVerticalDrag = 80,
    this.alignmentEnd = false,
    this.reverseVertical = true,
    this.onHorizontalDragCallback,
    this.onVerticalDragCallback,
    this.padding,
    this.swipeButtonBodyOne,
    this.swipeButtonBodyTwo,
    this.horizontalStartPosition = 0,
    this.verticalStartPosition = 0,
  });

  /// Main button widget to be swiped.
  final Widget mainButton;

  /// Main button widget to be swiped.
  final Widget? secondaryButton;

  /// Max horizontal drag distance before triggering callback.
  final double maxHorizontalDrag;

  /// Max vertical drag distance before triggering callback.
  final double maxVerticalDrag;

  /// Whether the horizontal animation should align to the end.
  final bool showMainButton;

  /// Whether the horizontal animation should align to the end.
  final bool alignmentEnd;

  /// Whether vertical direction is reversed (bottom-up).
  final bool reverseVertical;

  /// Initial horizontal offset.
  final double horizontalStartPosition;

  /// Initial vertical offset.
  final double verticalStartPosition;

  /// Callback when horizontal drag max is reached.
  final VoidCallback? onHorizontalDragCallback;

  /// Callback when vertical drag max is reached.
  final VoidCallback? onVerticalDragCallback;

  /// Optional swipe background widgets.
  final SwipeBodyWidgets? swipeButtonBodyOne;
  final SwipeBodyWidgets? swipeButtonBodyTwo;

  /// Padding around the widget.
  final EdgeInsets? padding;

  @override
  State<SwipingButton> createState() => _SwipingButtonState();
}

class _SwipingButtonState extends State<SwipingButton> with TickerProviderStateMixin {
  // Animation controllers and tween
  late final AnimationController _horizontalController;
  late final AnimationController _verticalController;

  late Animation<double> _horizontalAnimation;
  late Animation<double> _verticalAnimation;

  double _horizontalOffset = 0.0;
  double _verticalOffset = 0.0;

  bool _showSwipeButtonBodyOne = true;
  bool _allowHorizontalDrag = true;
  bool _allowVerticalDrag = true;

  @override
  void initState() {
    super.initState();

    _horizontalOffset = widget.horizontalStartPosition;
    _verticalOffset = widget.verticalStartPosition;

    _horizontalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _verticalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  /// Animate button back to its initial position.
  void _animateBackToStart() {
    _horizontalAnimation = Tween<double>(
        begin: _horizontalOffset,
        end: widget.horizontalStartPosition,
      ).animate(CurvedAnimation(parent: _horizontalController, curve: Curves.easeOutBack))
      ..addListener(() {
        setState(() => _horizontalOffset = _horizontalAnimation.value);
        _showSwipeButtonBodyOne = true;
      });

    _verticalAnimation = Tween<double>(
        begin: _verticalOffset,
        end: widget.verticalStartPosition,
      ).animate(CurvedAnimation(parent: _verticalController, curve: Curves.easeOutBack))
      ..addListener(() {
        setState(() => _verticalOffset = _verticalAnimation.value);
      });

    _horizontalController.forward(from: 0.0);
    _verticalController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          // Background swipe content
          _SwipeButtonSwitchWidgets(
            swipeButtonBodyOne: widget.swipeButtonBodyOne,
            swipeButtonBodyTwo: widget.swipeButtonBodyTwo,
            showSwipeButtonBodyOne: _showSwipeButtonBodyOne,
          ),

          // Swipeable button with gesture detection
          AnimatedPositionedDirectional(
            duration: Duration.zero,
            start: widget.alignmentEnd ? null : _horizontalOffset,
            end: widget.alignmentEnd ? _horizontalOffset : null,
            top: widget.reverseVertical ? null : _verticalOffset,
            bottom: widget.reverseVertical ? _verticalOffset : null,
            child: GestureDetector(
             onHorizontalDragDown:  widget.showMainButton
                  ? (_) => setState(() => _showSwipeButtonBodyOne = false)
                  : null,
              onTapDown:
                  widget.showMainButton
                      ? (_) => setState(() => _showSwipeButtonBodyOne = false)
                      : null,
              onTapUp:
                  widget.showMainButton
                      ? (_) => setState(() => _showSwipeButtonBodyOne = true)
                      : null,

              onHorizontalDragStart:
                  widget.showMainButton
                      ? (_) {
                        _showSwipeButtonBodyOne = false;
                        _allowHorizontalDrag = true;
                      }
                      : null,

              onVerticalDragStart:
                  widget.showMainButton
                      ? (_) {
                        _allowVerticalDrag = true;
                        _showSwipeButtonBodyOne = false;
                        setState(() {});
                      }
                      : null,

              onHorizontalDragUpdate:
                  widget.showMainButton
                      ? (details) {
                        if (!_allowHorizontalDrag) return;
                        _horizontalController.stop();

                        final delta = widget.alignmentEnd ? -details.delta.dx : details.delta.dx;
                        _horizontalOffset += delta;
                        _horizontalOffset = _horizontalOffset.clamp(0.0, widget.maxHorizontalDrag);

                        if (_horizontalOffset >= widget.maxHorizontalDrag) {
                          widget.onHorizontalDragCallback?.call();
                          _allowHorizontalDrag = false;
                          _animateBackToStart();
                        } else {
                          setState(() {});
                        }
                      }
                      : null,

              onVerticalDragUpdate:
                  widget.showMainButton
                      ? (details) {
                        if (!_allowVerticalDrag) return;
                        _verticalController.stop();

                        final delta = widget.reverseVertical ? -details.delta.dy : details.delta.dy;
                        _verticalOffset += delta;
                        _verticalOffset = _verticalOffset.clamp(0.0, widget.maxVerticalDrag);

                        if (_verticalOffset >= widget.maxVerticalDrag) {
                          widget.onVerticalDragCallback?.call();
                          _allowVerticalDrag = false;
                          _animateBackToStart();
                        } else {
                          setState(() {});
                        }
                      }
                      : null,
              onHorizontalDragEnd: widget.showMainButton ? (_) => _animateBackToStart() : null,
              onVerticalDragEnd: widget.showMainButton ? (_) => _animateBackToStart() : null,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child:
                    widget.showMainButton
                        ? SizedBox(key: const ValueKey('bodyOne'), child: widget.mainButton)
                        : SizedBox(
                          key: const ValueKey('bodyTwo'),
                          child: widget.secondaryButton ?? const SizedBox.shrink(),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
