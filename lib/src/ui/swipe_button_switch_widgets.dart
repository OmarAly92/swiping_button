part of '../../swiping_button.dart';

/// Internal widget to switch between two swipe body layouts with animation.
class _SwipeButtonSwitchWidgets extends StatefulWidget {
  const _SwipeButtonSwitchWidgets({
    required this.showSwipeButtonBodyOne,
    required this.swipeButtonBodyOne,
    required this.swipeButtonBodyTwo,
    this.switchBodytransitionBuilder,
    this.delaySwitch,
    Key? key,
  }) : super(key: key);

  /// Controls which swipe body is shown.
  final bool showSwipeButtonBodyOne;

  /// First swipe body layout (optional).
  final SwipeBodyWidgets? swipeButtonBodyOne;

  /// Second swipe body layout (optional).
  final SwipeBodyWidgets? swipeButtonBodyTwo;

  final AnimatedSwitcherTransitionBuilder? switchBodytransitionBuilder;

  /// Optional delay before the transition animation begins.
  final Duration? delaySwitch;

  @override
  State<_SwipeButtonSwitchWidgets> createState() =>
      _SwipeButtonSwitchWidgetsState();
}

class _SwipeButtonSwitchWidgetsState extends State<_SwipeButtonSwitchWidgets> {
  late bool _currentShow;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    // Initialise the currently displayed body according to the initial parameter.
    _currentShow = widget.showSwipeButtonBodyOne;
  }

  @override
  void didUpdateWidget(covariant _SwipeButtonSwitchWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the desired body changes, schedule a delayed update if a delay is specified.
    if (widget.showSwipeButtonBodyOne != oldWidget.showSwipeButtonBodyOne) {
      // Cancel any pending timer to avoid multiple queued updates.
      _delayTimer?.cancel();
      if (widget.delaySwitch != null) {
        _delayTimer = Timer(widget.delaySwitch!, () {
          if (mounted) {
            setState(() {
              _currentShow = widget.showSwipeButtonBodyOne;
            });
          }
        });
      } else {
        // Immediate update with no delay.
        _currentShow = widget.showSwipeButtonBodyOne;
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The fade duration remains constant at 200ms; the delay does not extend
    // the animation length.
    const Duration fadeDuration = Duration(milliseconds: 200);
    return AnimatedSwitcher(
      duration: fadeDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder:
          widget.switchBodytransitionBuilder ??
          (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
      child:
          _currentShow
              ? _buildSwipeBody(
                widget.swipeButtonBodyOne,
                key: const ValueKey('bodyOne'),
              )
              : _buildSwipeBody(
                widget.swipeButtonBodyTwo,
                key: const ValueKey('bodyTwo'),
              ),
    );
  }

  /// Builds a swipe body layout with optional leading and body widgets.
  Widget _buildSwipeBody(SwipeBodyWidgets? body, {required Key key}) {
    return Stack(
      key: key,
      children: [
        if (body?.leading != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: body!.leading!,
          ),
        if (body?.body != null) Center(child: body!.body!),
      ],
    );
  }
}
