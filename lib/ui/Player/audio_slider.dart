// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music/utils/audio_player.dart';
import 'package:provider/provider.dart';

import '../../store/AppInfoProvider.dart';

class Sliders extends StatefulWidget {
  const Sliders({Key? key}) : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  Duration? _duration;
  Duration? _position;

  late List<StreamSubscription> streams;

  @override
  void initState() {
    super.initState();
    streams = <StreamSubscription>[
      AudioPlayerUtil.player.onDurationChanged.listen((it) {
        setState(() => _duration = it);
        // 同步当前播放音乐
        final String url = AudioPlayerUtil.url as String;
        context.read<AppInfoProvider>().setCurrentPlay(url);
      }),
      AudioPlayerUtil.player.onPositionChanged.listen((it) {
        setState(() => _position = it);
      }),
    ];
  }

  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void dispose() {
    super.dispose();
    for (var it in streams) {
      it.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(),
              Text(
                _position != null
                    ? '$_positionText / $_durationText'
                    : _duration != null
                        ? _durationText
                        : '',
                style: const TextStyle(fontSize: 12.0),
              ),
            ]),
            SizedBox(
              height: 15,
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 4,
                  inactiveTrackColor: Colors.black12,
                  activeTrackColor: Colors.redAccent,
                ),
                child: Slider(
                  value: (_position != null &&
                          _duration != null &&
                          _position!.inMilliseconds > 0 &&
                          _position!.inMilliseconds < _duration!.inMilliseconds)
                      ? _position!.inMilliseconds / _duration!.inMilliseconds
                      : 0.0,
                  onChanged: (v) {
                    final duration = _duration;
                    if (duration == null) {
                      return;
                    }
                    final position = v * duration.inMilliseconds;
                    AudioPlayerUtil.player
                        .seek(Duration(milliseconds: position.round()));
                  },
                ),
              ),
            ),
          ]),
    );
  }
}
