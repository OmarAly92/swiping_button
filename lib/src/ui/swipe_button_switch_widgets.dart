part of '../../swiping_button.dart';

/// Internal widget to switch between two swipe body layouts with animation.
class _SwipeButtonSwitchWidgets extends StatelessWidget {
  const _SwipeButtonSwitchWidgets({
    required this.showSwipeButtonBodyOne,
    required this.swipeButtonBodyOne,
    required this.swipeButtonBodyTwo,
  });

  /// Controls which swipe body is shown.
  final bool showSwipeButtonBodyOne;

  /// First swipe body layout (optional).
  final SwipeBodyWidgets? swipeButtonBodyOne;

  /// Second swipe body layout (optional).
  final SwipeBodyWidgets? swipeButtonBodyTwo;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 370),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0.0),
          end: Offset.zero,
        ).animate(animation);

        // Faster fade: curve hits full opacity earlier
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.7, 1), // 40% of total duration
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child:
          showSwipeButtonBodyOne
              ? _buildSwipeBody(swipeButtonBodyOne, key: const ValueKey('bodyOne'))
              : _buildSwipeBody(swipeButtonBodyTwo, key: const ValueKey('bodyTwo')),
    );
  }

  /// Builds a swipe body layout with optional leading and body widgets.
  Widget _buildSwipeBody(SwipeBodyWidgets? body, {required Key key}) {
    return Stack(
      key: key,
      children: [
        if (body?.leading != null)
          Align(alignment: AlignmentDirectional.centerStart, child: body!.leading!),
        if (body?.body != null) Center(child: body!.body!),
      ],
    );
  }
}
