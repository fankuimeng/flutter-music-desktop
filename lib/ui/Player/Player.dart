import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/config/Appcolor.dart';
import 'package:music/store/AppInfoProvider.dart';
import 'package:music/ui/Player/audio_button.dart';
import 'package:music/ui/Player/audio_slider.dart';
import 'package:music/utils/audio_player.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Duration? position, duration;

  late List<StreamSubscription> streams;

  Duration? streamDuration, streamPosition;
  PlayerState? state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context)!.colors;
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
          SizedBox(
            width: 200,
            child: Center(
                child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    AudioPlayerUtil.previousMusic();
                    final String url = AudioPlayerUtil.url as String;
                    context.read<AppInfoProvider>().setCurrentPlay(url);
                  },
                  iconSize: 30.0,
                  icon: const Icon(Icons.skip_previous_outlined),
                ),
                AudioButton(url: currentPlay),
                IconButton(
                  onPressed: () {
                    AudioPlayerUtil.nextMusic();
                    final String url = AudioPlayerUtil.url as String;
                    context.read<AppInfoProvider>().setCurrentPlay(url);
                  },
                  iconSize: 30.0,
                  icon: const Icon(Icons.skip_next_outlined),
                ),
              ],
            )),
          ),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Image.network(
                      'https://file.ertuba.com/2022/0510/17eaa86dd538efaec2fa9935f5861640.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Flexible(
                child: Sliders(),
              )
            ],
          )),
          SizedBox(
            width: 150,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  IconButton(
                      onPressed: () {
                        context.read<AppInfoProvider>().setIsPlayListModal();
                      },
                      icon: Icon(Icons.view_headline)),
                ]),
          ),
        ],
      ),
    );
  }
}
