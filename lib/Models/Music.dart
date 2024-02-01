class Music {
  late String title;
  late String preview;
  late String name_artist;
  late String artist_picture;

  Music.fromJson(dynamic jsonData) {
    title = jsonData["title"];
    preview = jsonData["preview"];
    name_artist = jsonData["artist"]["name"];
    artist_picture = jsonData["artist"]["picture_medium"];
  }
  String getPreview() {
    return preview;
  }
}
