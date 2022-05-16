import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'emo/mood.dart';
import 'music/home.dart';
import 'music/model/myaudio.dart';

void main() {
  // runApp(MyApp());
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Circular'),
    debugShowCheckedModeBanner: false,
    home: ChangeNotifierProvider(create: (_) => MyAudio(), child: HomePage()),
  ));
}
