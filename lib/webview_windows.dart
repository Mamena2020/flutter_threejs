// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:webview_windows/webview_windows.dart' as www;

// class ThreeJSWebDeskTopView extends StatefulWidget {
//   const ThreeJSWebDeskTopView({super.key});

//   @override
//   _ThreeJSWebDeskTopViewState createState() => _ThreeJSWebDeskTopViewState();
// }

// class _ThreeJSWebDeskTopViewState extends State<ThreeJSWebDeskTopView> {
//   www.WebviewController _webViewWindowsController = www.WebviewController();

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   Future<void> load() async {
//     if (defaultTargetPlatform == TargetPlatform.windows) {
//       // Gunakan webview_windows untuk Windows
//       _webViewWindowsController = www.WebviewController();
//       await _webViewWindowsController.initialize();

//       // Muat file HTML lokal dari assets
//       // final filePath = await _getLocalFileUrl('assets/web/index.html');
//       // await _webViewWindowsController.loadUrl(filePath);

//       // Baca file JavaScript sebagai string
//       // https://unpkg.com/browse/three@0.97.0/build/
//       var jsContent = await rootBundle.loadString('assets/web/three.min.js');

//       // Baca file HTML sebagai string
//       var htmlContent = await rootBundle.loadString('assets/web/index.html');

//       // Sisipkan JavaScript ke dalam HTML
//       var modifiedHtml = htmlContent.replaceFirst(
//         'filethreejshere',
//         '<script>$jsContent</script>',
//       );
//       await _webViewWindowsController.loadStringContent(modifiedHtml);
//     }
//     setState(() {});
//   }

// // Fungsi untuk mendapatkan file URI dari assets
//   Future<String> _getLocalFileUrl(String assetPath) async {
//     final assetFile = File('${Directory.current.path}/$assetPath');
//     if (!await assetFile.exists()) {
//       throw Exception('File tidak ditemukan: ${assetFile.path}');
//     }
//     return assetFile.uri.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           children: [
//             Expanded(
//               child: _webViewWindowsController.value.isInitialized
//                   ? www.Webview(_webViewWindowsController)
//                   : Center(child: CircularProgressIndicator()),
//             ),
//             _buildControlButtons(),
//           ],
//         ));
//   }

//   Widget _buildControlButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               _webViewWindowsController
//                   .executeScript('moveCamera(0.2, 0.5, 5);');
//             },
//             child: Text('Move Camera'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _webViewWindowsController.executeScript('moveCamera(0, 0, 5);');
//             },
//             child: Text('Reset Camera'),
//           ),
//         ],
//       ),
//     );
//   }
// }
