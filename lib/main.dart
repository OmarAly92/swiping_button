import 'package:flutter/material.dart';
import 'package:swiping_button_ego/swiping_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  double horizontal = 0.0;

  double vertical = 0.0;
  bool showSwipeButtonBodyOne = true;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[const Text('You have pushed the button this many times:')],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.blue[100],
        child: SizedBox(
          height: 50,
          child: SwipingButton(
            alignmentEnd: true,
            maxVerticalDrag: 200,
            maxHorizontalDrag: MediaQuery.of(context).size.width * 0.6,
            mainButton: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.mic),
            ),
            onHorizontalDragCallback: () async {
              await animationController.forward();
              animationController.reset();
            },
            onVerticalDragCallback: () {},

            swipeButtonBodyTwo: SwipeBodyWidgets(
              body: Text('slide to cancel'),
              leading: Row(children: [Icon(Icons.mic), const SizedBox(width: 4), Text('00:30')]),
            ),
              swipeButtonBodyOne: SwipeBodyWidgets(body: TextField()),
          ),
        ),
      ),
    );
  }
}
