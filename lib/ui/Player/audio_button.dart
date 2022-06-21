/// Created by RongCheng on 2022/3/3.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/utils/audio_player.dart';

class AudioButton extends StatefulWidget {
  const AudioButton({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  bool _playing = false;

  @override
  void initState() {
    // TODO: implement initState
    // 判断是否正在播放
    if ((AudioPlayerUtil.state == PlayerState.playing) &&
        (AudioPlayerUtil.url != null) &&
        (AudioPlayerUtil.url == widget.url)) {
      _playing = true;
    }
    super.initState();

    // 监听播放状态
    AudioPlayerUtil.statusListener(
        key: this,
        listener: (state) {
          if ((AudioPlayerUtil.url != null) &&
              (AudioPlayerUtil.url == widget.url)) {
            // 为当前资源
            if (mounted) {
              setState(() {
                _playing = state == PlayerState.playing;
              });
            }
          } else {
            // 不是当前资源，若当前正在播放，则暂停
            if (_playing == true) {
              if (mounted) {
                setState(() {
                  _playing == false;
                });
              }
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_playing) {
          AudioPlayerUtil.player.pause();
          setState(() {
            _playing = false;
          });
        } else {
          AudioPlayerUtil.player.resume();
          setState(() {
            _playing = true;
          });
        }
      },
      child: Icon(
        _playing
            ? Icons.pause_circle_outline_outlined
            : Icons.play_circle_outline_outlined,
        size: 40,
      ),
    );
  }
}
