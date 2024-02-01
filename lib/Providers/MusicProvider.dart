import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicProvider extends ChangeNotifier {
  Icon icon = Icon(Icons.play_arrow);

  void changeIcon() {
    this.icon = Icon(Icons.pause);
    notifyListeners();
  }
}
