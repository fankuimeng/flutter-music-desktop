import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:music/pages/app/app_page.dart';
import 'package:music/store/AppInfoProvider.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';

import 'config/themeColor.dart';

void main() async {
  /// 确保初始化
  WidgetsFlutterBinding.ensureInitialized();

  /// 数据初始化
  // await Data.initData();

  /// 配置初始化
  // await StorageManager.init();

  /// APP入口并配置Provider
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AppInfoProvider(),
    )
  ], child: const MyApp()));

  /// 自定义报错页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    debugPrint(flutterErrorDetails.toString());
    return const Center(child: Text("程序错误，快去反馈给作者!"));
  };

  // Android状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(870, 700);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String colorKey = context.watch<AppInfoProvider>().themeColor;
    ColorScheme colorScheme =
        const ColorScheme.light().copyWith(primary: themeColorMap[colorKey]);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: colorScheme.primary),
      ),
      debugShowCheckedModeBanner: false,
      home: const AppBody(),
    );
  }
}
