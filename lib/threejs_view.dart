import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js_helpers/three_js_helpers.dart' as tHelper;
import 'package:three_js_transform_controls/three_js_transform_controls.dart';
import 'dart:math' as math;

class ThreejsView extends StatefulWidget {
  const ThreejsView({super.key});

  @override
  State<ThreejsView> createState() => _ThreejsViewState();
}

class _ThreejsViewState extends State<ThreejsView> {
  bool isLoaded = false;
  late three.ThreeJS threeJs;
  late three.OrbitControls orbit;
  late three.PerspectiveCamera cameraPersp;

  late TransformControls controlTransform;
  // Controller 是否啟用
  bool controllerClicked = false;

  // bool orbitUsed = false;

  // 新增 raycaster 和 pointer 變數
  final three.Raycaster raycaster = three.Raycaster();
  final three.Vector2 pointer = three.Vector2();
  final threshold = 0.01;

  @override
  void initState() {
    super.initState();
    threeJs = three.ThreeJS(
      onSetupComplete: () {
        setState(() {
          isLoaded = true;
          print("LOADED");
        });
      },
      setup: setup,
      windowResizeUpdate: (newSize) {
        print("windowResizeUpdate====>");
        final aspect = newSize.width / newSize.height;

        threeJs.renderer!.setSize(newSize.width, newSize.height);

        cameraPersp.aspect = aspect;
        cameraPersp.updateProjectionMatrix();

        threeJs.render();
      },
    );
  }

  @override
  void dispose() {
    threeJs.dispose();
    three.loading.clear();
    controlTransform.dispose();
    orbit.clearListeners();
    super.dispose();
  }

  void setup() {
    // set camera
    cameraPersp =
        three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, 2200);
    threeJs.camera = cameraPersp;
    threeJs.camera.position.setValues(0, 2, 10);

    //================================================= add scene
    threeJs.scene = three.Scene();

    //================================================= plane
    threeJs.scene.add(createPlane());

    //================================================= set orbit control
    orbit = three.OrbitControls(threeJs.camera, threeJs.globalKey);
    orbit.update();

    //================================================= Set Raycaster
    raycaster.params['Points']['threshold'] = threshold;

    // final planeGeometry = three.PlaneGeometry(100, 100);
    // final planeMaterial = three.MeshPhongMaterial.fromMap({
    //   'color': 0x0DAAFF, //
    //   // 'side': three.DoubleSide, //
    //   // 'opacity': 0.9, //
    //   // 'transparent': true, //
    // });

    // final planeMesh = three.Mesh(planeGeometry, planeMaterial);
    // planeMesh.rotation.x = math.pi / 2;
    // threeJs.scene.add(planeMesh);

    // add grid
    threeJs.scene.add(tHelper.GridHelper(100, 100, 0x888888, 0x444444));

    //================================================= add axes
    final axesHelper =
        tHelper.AxesHelper(3); // Axis Line (red => X, Green = Y, Blue = Z)
    threeJs.scene.add(axesHelper);

    //================================================= transform control
    controlTransform = TransformControls(threeJs.camera, threeJs.globalKey);
    controlTransform.addEventListener('change', (event) {
      // threeJs.render();// make slow
    });

    controlTransform.addEventListener('dragging-changed', (event) {
      // not activated orbit when using control transform
      orbit.enabled = !event.value;
    });
    threeJs.scene.add(controlTransform);

    // control
    controlTransform.addEventListener('mouseDown', (event) {
      // if using control to modify pos, rot, or size
      controllerClicked = true;
    });

    controlTransform.addEventListener('mouseUp', (event) {
      // if NOT using control to modify pos, rot, or size
      controllerClicked = false;
    });

    //================================================= Pointer Listener
    threeJs.domElement.addEventListener(three.PeripheralType.pointermove,
        (three.WebPointerEvent event) {
      print(
          "Pointer MOVE/////////////////////////////////////////////////////");
      var deltaX = (event.clientX - pointerOnStart.x).abs();
      var deltaY = (event.clientY - pointerOnStart.y).abs();

      if (deltaX > 5 || deltaY > 5) {
        isClicked = false;
      }
    });

    threeJs.domElement.addEventListener(three.PeripheralType.pointerdown,
        (three.WebPointerEvent event) {
      onPointerDown(event);
      isClicked = true;
      print("Pointer DOWN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    });

    threeJs.domElement.addEventListener(three.PeripheralType.pointerup,
        (three.WebPointerEvent event) {
      print("Pointer UP ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      // if using control to modify pos, rot, or size -> return here
      if (controllerClicked) return;

      if (isClicked) {
        print("Is Clicked............................");
        detectObjectRaycast(event);
      } else {
        print("Is Dragg............................");
      }
    });
  }

  var pointerOnStart = three.Vector2();
  bool isClicked = false;

  void onPointerDown(three.WebPointerEvent event) {
    pointerOnStart.x = event.clientX;
    pointerOnStart.y = event.clientY;
  }

  void onPointerUp(three.WebPointerEvent event) {
    pointer.x = (event.clientX / threeJs.width) * 2 - 1;
    pointer.y = -(event.clientY / threeJs.height) * 2 + 1;
  }

  void detectObjectRaycast(three.WebPointerEvent event) {
    onPointerUp(event);

    // raycaster
    raycaster.setFromCamera(pointer, threeJs.camera);
    final intersects = raycaster.intersectObjects(objects, true);

    if (intersects.isNotEmpty) {
      final object = intersects[0].object;
      if (object != controlTransform.object) {
        controlTransform.attach(object);
      }
    } else {
      print("Not detect Object");
      controlTransform.detach();
    }
    threeJs.render();
  }

  List<three.Object3D> objects = [];

  int objectCount = 0;

  three.Mesh createCube() {
    var boxGeo = three.BoxGeometry();

    var rand = math.Random().nextInt(colors.length);

    // var meshMat = three.MeshBasicMaterial.fromMap({"color": 0x0FFFdF});
    var meshMat =
        three.MeshBasicMaterial.fromMap({"color": colors[rand].value});
    return three.Mesh(boxGeo, meshMat)..name = "cube_$objectCount";
  }

  three.Mesh createPlane() {
    var planeGeo = three.PlaneGeometry(30, 30);
    var meshMat = three.MeshBasicMaterial.fromMap({
      // "color": 0xFFFFFF,
      "color": Colors.white.value,
      'side': three.DoubleSide,
    });
    final plane = three.Mesh(planeGeo, meshMat)..name = "plane";
    plane.rotation.x = -0.5 * math.pi;
    return plane;
  }

  void addCube() {
    final cube = createCube();
    objects.add(cube);

    controlTransform.attach(cube);
    controlTransform.setMode(GizmoType.translate);

    threeJs.scene.add(cube);

    threeJs.render();
  }

  List<Color> colors = [
    Colors.teal,
    Colors.amber,
    Colors.blue,
    Colors.brown,
    Colors.purple,
    Colors.red,
    Colors.pink,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        threeJs.build(),
        if (isLoaded)
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            controlTransform.setMode(GizmoType.translate);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.transform,
                            color: controlTransform.mode == GizmoType.translate
                                ? Colors.blue
                                : Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            controlTransform.setMode(GizmoType.rotate);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.rotate_90_degrees_ccw,
                            color: controlTransform.mode == GizmoType.rotate
                                ? Colors.blue
                                : Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            controlTransform.setMode(GizmoType.scale);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.photo_size_select_small,
                            color: controlTransform.mode == GizmoType.scale
                                ? Colors.blue
                                : Colors.black,
                          )),
                    ],
                  ),
                ),
              )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCube();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
