import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;

class FbxViewer extends StatefulWidget {
  const FbxViewer({super.key});

  @override
  State<FbxViewer> createState() => _FbxViewerState();
}

class _FbxViewerState extends State<FbxViewer> {
  late three.ThreeJS threeJs;

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () {
        setState(() {});
      },
      setup: setup,
    );
  }

  @override
  void dispose() {
    super.dispose();
    threeJs.dispose();
    three.loading.clear();
    joystick?.dispose();
  }

  three.Joystick? joystick;
  void setup() {
    joystick = threeJs.width < 500
        ? three.Joystick(
            size: 150,
            margin: const EdgeInsets.only(left: 35, bottom: 35),
            screenSize: Size(threeJs.width, threeJs.height),
            listenableKey: threeJs.globalKey)
        : null;

    threeJs.camera =
        three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, 2200);
    threeJs.camera.position.setValues(3, 6, 10);

    threeJs.scene = three.Scene();

    final ambientLight = three.AmbientLight(0xaaeecf, 0.3);
    threeJs.scene.add(ambientLight);

    final pointLight = three.PointLight(0xaaeecf, 0.1);

    pointLight.position.setValues(0, 0, 0);

    threeJs.camera.add(pointLight);
    threeJs.scene.add(threeJs.camera);

    threeJs.camera.lookAt(threeJs.scene.position);

    threeJs.renderer?.autoClear =
        false; // To allow render overlay on top of sprited sphere
    if (joystick != null) {
      threeJs.postProcessor = ([double? dt]) {
        threeJs.renderer!.setViewport(0, 0, threeJs.width, threeJs.height);
        threeJs.renderer!.clear();
        threeJs.renderer!.render(threeJs.scene, threeJs.camera);
        threeJs.renderer!.clearDepth();
        threeJs.renderer!.render(joystick!.scene, joystick!.camera);
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: threeJs.build());
  }
}
