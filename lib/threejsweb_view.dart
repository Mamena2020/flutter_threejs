// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart' as wwm;
// import 'package:webview_windows/webview_windows.dart' as www;

// class ThreeJSWebView extends StatefulWidget {
//   const ThreeJSWebView({super.key});

//   @override
//   _ThreeJSWebViewState createState() => _ThreeJSWebViewState();
// }

// class _ThreeJSWebViewState extends State<ThreeJSWebView> {
//   wwm.WebViewController _webViewMobileController = wwm.WebViewController();

//   www.WebviewController _webViewWindowsController = www.WebviewController();

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   Future<void> load() async {
//     if (defaultTargetPlatform == TargetPlatform.android ||
//         defaultTargetPlatform == TargetPlatform.iOS) {
//       _webViewMobileController = wwm.WebViewController()
//         ..setJavaScriptMode(wwm.JavaScriptMode.unrestricted)
//         ..loadFlutterAsset('assets/web/index.html')
//         ..addJavaScriptChannel(
//           'Flutter',
//           onMessageReceived: (wwm.JavaScriptMessage message) {
//             // Handle pesan dari JavaScript (jika diperlukan)
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(message.message)),
//             );
//           },
//         );
//     }

//     if (defaultTargetPlatform == TargetPlatform.windows) {
//       // Gunakan webview_windows untuk Windows
//       _webViewWindowsController = www.WebviewController();
//       await _webViewWindowsController.initialize();

//       // Muat file HTML lokal dari assets
//       final filePath = await _getLocalFileUrl('assets/web/index.html');
//       await _webViewWindowsController.loadUrl(filePath);
//     }
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
//         body: defaultTargetPlatform == TargetPlatform.android ||
//                 defaultTargetPlatform == TargetPlatform.iOS
//             ?
//             // Tampilkan WebView untuk Android/iOS
//             Column(
//                 children: [
//                   Expanded(
//                     child:
//                         wwm.WebViewWidget(controller: _webViewMobileController),
//                   ),
//                   _buildControlButtons(),
//                 ],
//               )
//             : defaultTargetPlatform == TargetPlatform.windows
//                 ? Column(
//                     children: [
//                       Expanded(
//                         child: _webViewWindowsController.value.isInitialized
//                             ? www.Webview(_webViewWindowsController)
//                             : Center(child: CircularProgressIndicator()),
//                       ),
//                       _buildControlButtons(),
//                     ],
//                   )
//                 : SizedBox());
//   }

//   Widget _buildControlButtons() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               // Panggil fungsi JavaScript untuk menggerakkan kamera
//               if (defaultTargetPlatform == TargetPlatform.android ||
//                   defaultTargetPlatform == TargetPlatform.iOS) {
//                 _webViewMobileController.runJavaScript('moveCamera(5, 5, 5);');
//               } else if (defaultTargetPlatform == TargetPlatform.windows) {
//                 _webViewWindowsController.executeScript('moveCamera(5, 5, 5);');
//               }
//             },
//             child: Text('Move Camera'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Reset kamera ke posisi awal
//               if (defaultTargetPlatform == TargetPlatform.android ||
//                   defaultTargetPlatform == TargetPlatform.iOS) {
//                 _webViewMobileController.runJavaScript('moveCamera(0, 0, 5);');
//               } else if (defaultTargetPlatform == TargetPlatform.windows) {
//                 _webViewWindowsController.executeScript('moveCamera(0, 0, 5);');
//               }
//             },
//             child: Text('Reset Camera'),
//           ),
//         ],
//       ),
//     );
//   }
// }
