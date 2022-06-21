/// Created by RongCheng on 2022/3/2.

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtil {
  // ------- --------------  public -------------------------

  static String? get url => _instance._url; // 当前播放的音频模型
  static PlayerState get state => _instance._state; // 当前播放状态
  static Duration get position => _instance._position; // 当前音频播放进度
  static bool get isListPlayer => _instance._isListPlayer; // 当前是否是列表播放
  static AudioPlayer get player => _instance._audioPlayer;

  // 单个播放
  static void playerHandle({required url}) {
    if (_instance._url == null) {
      // 播放新的音频
      _instance._playNewAudio(url);
      _instance._isListPlayer = false; // 关闭列表播放
    } else {
      if (_instance._url == url) {
        // 继续当前资源进行播放or暂停
        if (_instance._state == PlayerState.playing) {
          _instance._audioPlayer.pause();
          _instance._state = PlayerState.paused;
        } else {
          _instance._audioPlayer.resume();
          _instance._state = PlayerState.playing;
        }
      } else {
        // 播放新的音频
        _instance._playNewAudio(url);
        _instance._isListPlayer = false; // 关闭列表播放
      }
    }
  }

// 列表播放
  static void listPlayerHandle({required List<String> urls, String? url}) {
    if (url != null) {
      // 指定播放列表中某个曲子。自动开启列表播放
      _instance._playNewAudio(url);
      _instance.urls = urls;
      _instance._isListPlayer = true;
    } else {
      if (_instance._isListPlayer == true) {
        // 列表已经开启过。此处破；判断暂停、播放
        if (_instance._state == PlayerState.playing) {
          _instance._audioPlayer.pause();
        } else {
          _instance._audioPlayer.resume();
        }
      } else {
        // 开启列表播放,从0开始
        _instance._playNewAudio(urls.first);
        _instance.urls = urls;
        _instance._isListPlayer = true;
      }
    }
  }

  // 上一曲 ，只在列表播放时有效
  static void previousMusic() {
    if (_instance._isListPlayer == false) return;
    int index = _instance.urls.indexOf(_instance._url!);
    if (index == 0) {
      index = _instance.urls.length - 1;
    } else {
      index -= 1;
    }
    _instance._playNewAudio(_instance.urls[index]);
  }

  // 下一曲，只在列表播放时有效
  static void nextMusic() {
    if (_instance._isListPlayer == false) return;
    int index = _instance.urls.indexOf(_instance._url!);
    if (index == _instance.urls.length - 1) {
      // 最后一首
      index = 0;
    } else {
      index += 1;
    }
    _instance._playNewAudio(_instance.urls[index]);
  }

  // 跳转到某一时段
  static void seekTo({required Duration position, required url}) {
    if (_instance._url == null) {
      // 先播放新的音频，再跳转
      _instance._playNewAudio(AssetSource(url));
      _instance._seekTo(position);
    } else {
      if (_instance._url == url) {
        // 继续当前资源进行播放or暂停
        _instance._seekTo(position);
      } else {
        // 播放新的音频
        _instance._playNewAudio(AssetSource(url));
        _instance._seekTo(position);
      }
    }
  }

  // 修改播放列表
  static Future updateUrls(List<String> urls) async {
    _instance.urls = urls;
  }

  // 获取音频总时长
  static Future getAudioDuration() async {
    final duration = await _instance._audioPlayer.getDuration();
    return duration;
  }

  static Future getPosition() async {
    final position = await _instance._audioPlayer.getCurrentPosition();
    return position;
  }

  // 播放进度监听
  static void positionListener(
      {required dynamic key, required Function(int) listener}) {
    ListenerPositionModel model =
        ListenerPositionModel.fromList([key, listener]);
    _instance._positionPool.add(model);
  }

  // 播放状态监听
  static void statusListener(
      {required dynamic key, required Function(PlayerState) listener}) {
    ListenerStateModel model = ListenerStateModel.fromList([key, listener]);
    _instance._statusPool.add(model);
  }

  static void playerComplete() {
    if (_instance._isListPlayer == true) {
      // 开启列表播放后，自动下一曲
      nextMusic();
    } else {
      _instance._state = PlayerState.completed;
      _instance._stateUpdate(_instance._state);
    }
  }

  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  factory AudioPlayerUtil() => _instance;
  AudioPlayerUtil._internal() {
    _audioPlayer = AudioPlayer();
    _statusPool = [];
    _positionPool = [];
    _showPool = [];
    // 状态监听
    _audioPlayer.onPlayerStateChanged.listen((playerState) {
      _stateUpdate(playerState);
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      _position = p;
      if (p.inSeconds == _secondPosition || _stopPosition == true) return;
      _secondPosition = p.inSeconds;
      for (var element in _positionPool) {
        element.listener(p.inSeconds);
      }
    });
    _audioPlayer.onPlayerComplete.listen((it) {
      playerComplete();
    });
    // _audioPlayer.onSeekComplete.listen((it) => print('Seek complete!'));
  }

  late AudioPlayer _audioPlayer;
  PlayerState _state = PlayerState.stopped;
  String? _url;

  // 创建播放状态监听池
  late List<ListenerStateModel> _statusPool;
  // 播放进度监听池
  late List<ListenerPositionModel> _positionPool;
  // show监听
  late List<ListenerShowModel> _showPool;
  late bool _stopPosition = false; // 暂停进度监听，用于seekTo跳转播放缓冲时，Slider停止
  late int _secondPosition = 0;
  Duration _position = const Duration(seconds: 0);
  bool _show = false;
  bool _isListPlayer = false;
  List<String> urls = [];

  // 更新播放状态
  void _stateUpdate(PlayerState state) {
    _state = state;
    for (var element in _statusPool) {
      element.listener(state);
    }
  }

  // 播放新音频
  void _playNewAudio(url) async {
    RegExp urlExpNetWork =
        RegExp(r"^((https|http|ftp)?:\/\/)[^\s]+"); // 网络地址 本地地址
    urlExpNetWork.hasMatch(url)
        ? await _audioPlayer.play(UrlSource(url))
        : await _audioPlayer.play(DeviceFileSource(url));
    _instance._state = PlayerState.playing;
    _url = url;
  }

  // 跳转
  void _seekTo(Duration position) async {
    _stopPosition = true;
    await _audioPlayer.seek(position);
    _stopPosition = false;
  }
}

// 播放状态监听模型
class ListenerStateModel {
  late dynamic key;

  /// 根据key标记是谁加入的通知，一般直接传widget就好
  late Function(PlayerState) listener;

  /// 简单写一个构造方法
  ListenerStateModel.fromList(List list) {
    key = list.first;
    listener = list.last;
  }
}

// 播放进度监听模型
class ListenerPositionModel {
  late dynamic key;

  /// 根据key标记是谁加入的通知，一般直接传widget就好
  late Function(int) listener;

  /// 简单写一个构造方法
  ListenerPositionModel.fromList(List list) {
    key = list.first;
    listener = list.last;
  }
}

// 底部showTip监听模型
class ListenerShowModel {
  late dynamic key;

  /// 根据key标记是谁加入的通知，一般直接传widget就好
  late Function(bool) listener;

  /// 简单写一个构造方法
  ListenerShowModel.fromList(List list) {
    key = list.first;
    listener = list.last;
  }
}
