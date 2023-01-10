import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final counterProvider = StateProvider<int>((ref) => 0);

main() async {
  runApp(
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      routes: {
        "/": (_) => const HomePage(),
        "/another": (_) => const AnotherPage(),
      },
    );
  }
}

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();

}
class HomePageState extends ConsumerState<HomePage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var counter = ref.read(counterProvider.notifier);
      counter.state++;
      if (counter.state % 50 == 0){
        Navigator.popAndPushNamed(context, "/another");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final widgetCounter = useState(0);
    return Scaffold(
      appBar: AppBar(title: const Text("Hello from hooks"),
      actions: [
        IconButton(onPressed: () => ref.read(counterProvider.notifier).state += 2, icon: const Icon(Icons.add))
      ],),
      body: Center(child:
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("You was clicked:", style: Theme.of(context).textTheme.headline6,),
          Text("${widgetCounter.value + ref.watch(counterProvider)}", style: Theme.of(context).textTheme.headline1,),
        ],),),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => widgetCounter.value++,
      ),
    );
  }
}

class AnotherPage extends HookConsumerWidget {
  const AnotherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromMe = useState(0);
    return Scaffold(
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You from me ${fromMe.value}"),
          ElevatedButton(onPressed: () {
            Navigator.popAndPushNamed(context, "/");
            fromMe.value++;
          },
              child: const Text("Bye"))
        ],),),
    );
  }
}
