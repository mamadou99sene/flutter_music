import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music/Models/Music.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicProvider extends ChangeNotifier {
  Icon icon = Icon(Icons.play_arrow);
  int currentMusic = 0;
  bool IsPlaying = false;
  static List<Music> musics = [];
  List<Music> allMusicByArtist = [];
  static List<int> totalMusicByArtist = [];
  static Set<String> addedArtists = Set<String>();

  void changeIconToplay() {
    this.icon = Icon(Icons.pause);
    notifyListeners();
  }

  void stopPlaying() {
    IsPlaying = false;
    notifyListeners();
  }

  void startPlaying() {
    IsPlaying = true;
    notifyListeners();
  }

  bool getStatusPlaying() {
    return IsPlaying;
  }

  void changeIconToPause() {
    this.icon = Icon(Icons.play_arrow);
    notifyListeners();
  }

  List<int> getTotalMusicByArtist() {
    return totalMusicByArtist;
  }

  Future<List<Music>> getArtiste(String artistName) async {
    String url = "http://api.deezer.com/search?q=" + artistName.trim();
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      totalMusicByArtist.add(responseJson["total"]);
      for (var music in responseJson["data"]) {
        var artist = music["artist"]["name"];
        if (!addedArtists.contains(artist)) {
          addedArtists.add(artist);
          musics.add(Music.fromJson(music));
          break;
        }
      }
    }
    return musics;
  }

  Future<List<Music>> getAllMusicsByArtist(String artistName) async {
    String url = "http://api.deezer.com/search?q=" + artistName;
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      for (var music in responseJson["data"]) {
        allMusicByArtist.add(Music.fromJson(music));
      }
    }
    return allMusicByArtist;
  }
}
