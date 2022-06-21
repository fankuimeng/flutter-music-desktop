import 'package:flutter/foundation.dart';

class AppInfoProvider with ChangeNotifier {
  bool _isPlayListModal = false;
  String _themeColor = '';
  List<String> _playList = [
    'http://127.0.0.1:5501/assets/124.mp3',
    'http://127.0.0.1:5501/assets/mfk.flac',
    'http://127.0.0.1:5501/assets/mfk.mp3'
  ];
  String _currentPlay = 'http://127.0.0.1:5501/assets/mfk.mp3';

  bool get isPlayListModal => _isPlayListModal;
  String get themeColor => _themeColor;
  List<String> get playList => _playList;
  String get currentPlay => _currentPlay;

  setIsPlayListModal() {
    _isPlayListModal = !isPlayListModal;
    notifyListeners();
  }

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

  setCurrentPlay(String currentPlay) {
    _currentPlay = currentPlay;
    notifyListeners();
  }

  setPlayList(List<String> playList) {
    _playList = playList;
    notifyListeners();
  }
}
