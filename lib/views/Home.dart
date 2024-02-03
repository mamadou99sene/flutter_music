import 'package:flutter/material.dart';
import 'package:music/Providers/MusicProvider.dart';
import 'package:music/views/App.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MusicProvider())
    ], child: MaterialApp(debugShowCheckedModeBanner: false, home: App()));
  }
}
