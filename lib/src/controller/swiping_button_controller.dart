part of '../../swiping_button.dart';

/// Controller for [SwipingButton] that provides programmatic access to
/// internal behaviours of the widget.  It allows triggering the button's
/// animation back to its starting position from outside of the widget tree.
///
/// To use a controller, create an instance and pass it to a [SwipingButton]
/// via its `controller` property. The button will automatically bind its
/// internal reset callback to the controller during initialisation, so you
/// don't need to provide any arguments to the controller's constructor.
///
/// Example:
///
/// ```dart
/// final controller = SwipingButtonController();
/// SwipingButton(
///   mainButton: myWidget,
///   controller: controller,
/// );
/// // Later, from anywhere with access to the controller:
/// controller.animateBackToStart();
/// ```

/// Controller for [SwipingButton] that provides programmatic access to
/// internal behaviours of the widget.
class SwipingButtonController {
  VoidCallback? _animateBackCallback;

  /// Called by [SwipingButton] to bind its internal reset animation.
  void _bindAnimate(VoidCallback callback) {
    _animateBackCallback = callback;
  }

  /// Public API to trigger a reset of the swipe button.
  void animateBackToStart() {
    _animateBackCallback?.call();
  }
}
