import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:music/Models/Music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music/Providers/MusicProvider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  TextEditingController _controller = TextEditingController();

  String recherche = "";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MusicProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Music",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.cyan,
          ),
          body: FutureBuilder<List<Music>>(
              future: getArtiste(recherche),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == "") {
                    return Container();
                  } else {
                    List<Music>? listMusic = snapshot.data;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount:
                                  (listMusic == null ? 0 : listMusic.length),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    final player = AudioPlayer();
                                    await player.play(
                                        UrlSource(listMusic![index].preview));
                                    final provider = Provider.of<MusicProvider>(
                                        context,
                                        listen: false);
                                    provider.changeIcon();
                                  },
                                  child: Consumer<MusicProvider>(
                                    builder: (context, value, child) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              listMusic![index].artist_picture),
                                        ),
                                        title: Text(listMusic[index].title),
                                        subtitle:
                                            Text(listMusic[index].name_artist),
                                        trailing: value.icon,
                                      );
                                    },
                                  ),
                                );
                              }),
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
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
        ));
  }

  Future<List<Music>> getArtiste(String artistName) async {
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
