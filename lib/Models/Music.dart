class Music {
  late String title;
  late String preview;
  late String name_artist;
  late String title_album;
  late String type;

  Music.fromJson(dynamic jsonData) {
    title = jsonData["title"];
    preview = jsonData["preview"];
    name_artist = jsonData["artist"]["name"];
    title_album = jsonData["album"]["title"];
    type = jsonData["type"];
  }
  String getPreview() {
    return preview;
  }
}
