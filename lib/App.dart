import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:music/Models/Music.dart';
import 'package:audioplayers/audioplayers.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextEditingController _controller = TextEditingController();

  String recherche = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Music",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder(
          future: getArtiste(recherche),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == "") {
                return Container();
              } else {
                List<Music> listMusic = snapshot.data;
                AudioPlayer audio = AudioPlayer();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          audio.dispose();
                          audio.play(UrlSource(listMusic[0].preview));
                        },
                        child: Text(listMusic[0].preview)),
                    DropdownButton(
                      value: "please select music",
                      items: [
                        /* DropdownMenuItem<String>(
                          child: Text("Music 1"),
                          value: listMusic[0].preview,
                        )*/
                      ],
                      onChanged: null,
                      iconEnabledColor: Colors.green,
                      icon: Icon(Icons.play_circle),
                      iconSize: 42.0,
                    )
                  ],
                );
              }
            } else {
              return SpinKitWave(
                color: Colors.black,
                size: 50.0,
                type: SpinKitWaveType.center,
              );
            }
          })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Please insert the artist name"),
                    content: TextField(
                      controller: _controller,
                    ),
                    elevation: 0,
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red)),
                          ElevatedButton(
                            onPressed: () {
                              recherche = _controller.text;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Text("Valid"),
                          )
                        ],
                      )
                    ],
                  );
                });
          },
          child: Icon(Icons.search)),
    );
  }

  Future<dynamic> getArtiste(String artistName) async {
    if (recherche == "") {
      return "";
    } else {
      String url = "http://api.deezer.com/search?q=" + artistName.trim();
      var response = await http.get(Uri.parse(url));
      var responseJson = jsonDecode(response.body);
      List<Music> musics = [];
      for (var music in responseJson["data"]) {
        musics.add(Music.fromJson(music));
      }
      return musics;
    }
  }

  Future<void> playMusic(String url) async {
    AudioPlayer player = AudioPlayer();
    await player.play(url as Source);
  }
}
