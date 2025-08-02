part of '../../swiping_button.dart';

class SwipeBodyWidgets {
  final Widget? leading;
  final Widget? body;

  SwipeBodyWidgets({this.leading, this.body});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwipeBodyWidgets &&
          runtimeType == other.runtimeType &&
          leading == other.leading &&
          body == other.body;

  @override
  int get hashCode => Object.hash(leading, body);
}
