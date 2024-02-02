import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music/Models/Music.dart';
import 'package:music/Providers/MusicProvider.dart';
import 'package:provider/provider.dart';

class Details extends StatelessWidget {
  Music music;
  Details({required this.music});

  @override
  Widget build(BuildContext context) {
    final audioplayer = AudioPlayer();
    return ChangeNotifierProvider(
      create: (context) => MusicProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(music.name_artist),
          elevation: 0,
          backgroundColor: Colors.cyan,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  audioplayer.stop();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: FutureBuilder(
          future: MusicProvider().getAllMusicsByArtist(music.name_artist),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitWave(
                color: Colors.black,
                size: 50.0,
                type: SpinKitWaveType.center,
              );
            } else if (snapshot.hasData) {
              List<Music>? listMusic = snapshot.data;
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.cyan,
                      thickness: 1.0,
                    );
                  },
                  itemCount: (listMusic == null ? 0 : listMusic.length),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(listMusic![index].artist_picture),
                      ),
                      title: Text(listMusic[index].title),
                      subtitle: Text(listMusic[index].name_artist),
                      trailing: IconButton(
                        onPressed: () async {
                          final provider = Provider.of<MusicProvider>(context,
                              listen: false);

                          if (provider.getStatusPlaying() == false) {
                            provider.currentMusic = index;
                            provider.changeIconToplay();

                            await audioplayer
                                .play(UrlSource(listMusic[index].preview));
                            provider.startPlaying();
                            print(audioplayer.state);
                          } else {
                            audioplayer.stop();
                            provider.stopPlaying();
                            print(audioplayer.state);
                          }
                        },
                        icon: Consumer<MusicProvider>(
                          builder: (context, value, child) {
                            return (value.currentMusic == index &&
                                    value.getStatusPlaying()
                                ? value.icon
                                : Icon(Icons.play_arrow));
                          },
                        ),
                        color: Colors.cyan,
                      ),
                    );
                  });
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
