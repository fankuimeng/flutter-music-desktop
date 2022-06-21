import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:music/config/Appcolor.dart';
import 'package:music/store/AppInfoProvider.dart';
import 'package:music/ui/Player/Player.dart';
import 'package:music/ui/button/RoundedFlatButton.dart';
import 'package:music/utils/audio_player.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  int _skinNumber = 0;
  int selectedPlayerIdx = 0;
  final List<String> paths = [];

  AppSkin _skin = skins[0];

  void switchSkin() {
    _skinNumber++;
    _skinNumber = (_skinNumber % skins.length);
    setState(() {
      _skin = skins[_skinNumber];
    });
  }

  // Future<void> setSource(Source source) async {
  //   await player.setSource(source);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AppColors(
            colors: _skin,
            child: WindowBorder(
                color: _skin.border,
                width: 1,
                child: Column(
                  children: <Widget>[
                    const Flexible(
                      flex: 1,
                      child: TopWindow(),
                    ),
                    Flexible(
                        flex: 10,
                        child: MainWindow(onButtonPressed: switchSkin)),
                    const Flexible(
                      flex: 1,
                      child: Player(),
                    ),
                  ],
                ))));
  }
}

class LeftSide extends StatelessWidget {
  const LeftSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context)!.colors;
    return Expanded(
        child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.backgroundStart, colors.backgroundEnd],
                  stops: const [0.0, 1.0]),
            ),
            child: const RightSideTopArea()));
  }
}

class RightSide extends StatelessWidget {
  final VoidCallback? onButtonPressed;
  const RightSide({Key? key, this.onButtonPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<String> playList = context.watch<AppInfoProvider>().playList;

    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedFlatButton(
            text: '本地音乐',
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
              );
              List<PlatformFile> files = result!.files;
              for (var item in files) {
                if (item.path != null && item.path != '') {
                  playList.add(item.path as String);
                }
              }
              List<String> list = playList.toSet().toList();
              AudioPlayerUtil.updateUrls(list);
              // ignore: use_build_context_synchronously
              context.read<AppInfoProvider>().setPlayList(list);
            }),
        RoundedFlatButton(
            text: '皮肤切换',
            onPressed: () {
              if (onButtonPressed != null) onButtonPressed!();
            }),
      ],
    ));
  }
}

class RightSideTopArea extends StatelessWidget {
  const RightSideTopArea({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
        child: Row(children: [
      const Text('网易云音乐'),
      Expanded(child: MoveWindow()),
      const WindowButtons()
    ]));
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context)!.colors;
    final buttonColors = WindowButtonColors(
        iconNormal: colors.icon,
        iconMouseDown: colors.iconMouseDown,
        iconMouseOver: colors.iconMouseOver,
        mouseDown: colors.buttonMouseDown,
        mouseOver: colors.buttonMouseOver);
    final closeButtonColors = WindowButtonColors(
        mouseOver: Colors.red[700],
        mouseDown: Colors.red[900],
        iconNormal: colors.icon,
        iconMouseOver: Colors.white);

    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

class TopWindow extends StatelessWidget {
  const TopWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context)!.colors;
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colors.backgroundStart, colors.backgroundEnd],
              stops: const [0.0, 1.0]),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 200,
              child: Row(
                children: const [
                  Text('网易云音乐',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Flexible(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('主编兰'),
                Expanded(child: MoveWindow()),
              ],
            )),
            Container(
              width: 150,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    const WindowButtons(),
                  ]),
            ),
          ],
        ));
  }
}

class MainWindow extends StatelessWidget {
  final VoidCallback? onButtonPressed;

  const MainWindow({
    Key? key,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context)!.colors;
    bool isPlayListModal = context.watch<AppInfoProvider>().isPlayListModal;
    List<String> playList = context.watch<AppInfoProvider>().playList;
    String currentPlay = context.watch<AppInfoProvider>().currentPlay;

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colors.backgroundStart, colors.backgroundEnd],
              stops: const [0.0, 1.0]),
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.backgroundStart, colors.backgroundEnd],
                      stops: const [0.5, 1.0]),
                ),
                child: ListView(
                    children: [1, 2, 3, 4, 6, 5, 6, 7, 8]
                        .map((item) => Text('item$item'))
                        .toList())),
            RightSide(
              onButtonPressed: onButtonPressed,
            ),
            isPlayListModal
                // ignore: dead_code
                ? Opacity(
                    opacity: 0.3,
                    child: GFDrawer(
                      child: ListView(
                          padding: EdgeInsets.zero,
                          children: playList
                              .map((item) => ListTile(
                                  title: currentPlay == item
                                      ? Text(
                                          item,
                                          style: const TextStyle(fontSize: 16),
                                        )
                                      : Text(
                                          item,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                  onTap: () {
                                    context
                                        .read<AppInfoProvider>()
                                        .setCurrentPlay(item);
                                    AudioPlayerUtil.listPlayerHandle(
                                        urls: playList, url: item);
                                  }))
                              .toList()),
                    ),
                  )
                // ignore: dead_code
                : Container()
          ],
        ));
  }
}
