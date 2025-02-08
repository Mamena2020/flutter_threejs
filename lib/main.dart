import 'package:flutter/material.dart';
import 'package:test_threejs/fbx_viewer.dart';
import 'package:test_threejs/threejs_view.dart';
// import 'package:test_threejs/threejsweb_view.dart';
// import 'package:test_threejs/webview_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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

class _MyHomePageState extends State<MyHomePage> {
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
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const FbxViewer()));
              },
              child: const Text("three_js"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //         MaterialPageRoute(builder: (_) => const ThreeJSWebView()));
            //   },
            //   child: const Text("three_js web view - Mobile"),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (_) => const ThreeJSWebDeskTopView()));
            //   },
            //   child: const Text("three_js web view - Desktop"),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ThreejsView()));
              },
              child: const Text("three_js Flutter"),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
