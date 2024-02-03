import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music/Models/Music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music/Providers/MusicProvider.dart';
import 'package:music/views/Details.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
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
      body: Consumer<MusicProvider>(
        builder: (context, value, child) {
          return FutureBuilder<List<Music>>(
              future: value.getArtiste(value.recherche),
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
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: Colors.cyan,
                                  thickness: 1.0,
                                );
                              },
                              itemCount:
                                  (listMusic == null ? 0 : listMusic.length),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Details(
                                                music: listMusic[index])));
                                  },
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            listMusic![index].artist_picture),
                                      ),
                                      title: Text(listMusic[index].title),
                                      subtitle:
                                          Text(listMusic[index].name_artist),
                                      trailing: CircleAvatar(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.cyan,
                                        child: Text(
                                          "${MusicProvider().getTotalMusicByArtist()[index]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                );
                              }),
                        )
                      ],
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitWave(
                    color: Colors.black,
                    size: 50.0,
                    type: SpinKitWaveType.center,
                  );
                } else {
                  return Container();
                }
              }));
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Please insert the artist name"),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return TextField(
                          controller:
                              Provider.of<MusicProvider>(context).controller,
                          onChanged: (value) {
                            setState(() {
                              Provider.of<MusicProvider>(context, listen: false)
                                  .recherche = value;
                            });
                          },
                        );
                      },
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
                              final provider = Provider.of<MusicProvider>(
                                  context,
                                  listen: false);

                              provider.updateMusicsList();
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
}
