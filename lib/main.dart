import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    backgroundColor: Colors.transparent,
    title: '阅读，遇见更大的世界',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyTestHomePage(),
      title: '阅读，遇见更大的世界',
      debugShowCheckedModeBanner: false, // 隐藏右上角的 Debug 标签
    );
  }
}

class MyTestHomePage extends StatefulWidget {
  const MyTestHomePage({Key? key}) : super(key: key);

  @override
  State<MyTestHomePage> createState() => _MyTestHomePageState();
}

class _MyTestHomePageState extends State<MyTestHomePage> {
  final InAppWebViewSettings _settings =
      InAppWebViewSettings(javaScriptEnabled: true);

  // 1. 添加一个状态来跟踪窗口是否置顶
  bool _isAlwaysOnTop = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        windowManager.setOpacity(1.0);
      },
      onExit: (_) {
        windowManager.setOpacity(0.01);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri("https://r.qq.com")),
          initialSettings: _settings,
        ),
        // 2. 添加悬浮按钮
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () async {
            // 3. 切换置顶状态并调用 windowManager
            setState(() {
              _isAlwaysOnTop = !_isAlwaysOnTop;
            });
            await windowManager.setAlwaysOnTop(_isAlwaysOnTop);
          },
          // 4. 根据状态改变按钮图标
          child: Icon(
            _isAlwaysOnTop ? Icons.push_pin : Icons.push_pin_outlined,
          ),
        ),
      ),
    );
  }
}
