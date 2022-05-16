import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import '/utils/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'model/myaudio.dart';
import 'playerControls.dart';
import 'albumart.dart';
import 'navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double sliderValue = 2;
  String pathOfImage = "";
  String? moodImagePath;
  String moodDetail = "";
  bool isVisible = false;

  FaceDetector detector = GoogleMlKit.vision.faceDetector(
    const FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
    ),
  );

  bool iswaiting = false;

  @override
  void dispose() {
    super.dispose();
    detector.close();
  }

  Future<String> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      iswaiting = true;
      pathOfImage = image!.path;
    });
    return image!.path;
  }

  Future<String> extractData(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    List<Face> faces = await detector.processImage(inputImage);

    if (faces.length > 0 && faces[0].smilingProbability != null) {
      double? prob = faces[0].smilingProbability;

      if (prob! > 0.8) {
        setState(() {
          moodDetail = "Happy";
          moodImagePath = "assets/happy.png";
        });
      } else if (prob > 0.3 && prob < 0.8) {
        setState(() {
          moodDetail = "Normal";
          moodImagePath = "assets/meh.png";
        });
      } else if (prob > 0.06152385 && prob < 0.3) {
        setState(() {
          moodDetail = "Sad";
          moodImagePath = "assets/sad.png";
        });
      } else {
        setState(() {
          moodDetail = "Angry";
          moodImagePath = "assets/angry.png";
        });
      }
      setState(() {
        isVisible = true;
      });
    }
    return moodDetail;
  }

  List audioData = [
    {
      'image':
          'https://i.pinimg.com/originals/de/f7/9a/def79a4e31a4f9b478ad5eb711bad460.jpg',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Consumer<MyAudio>(
      builder: (_, myAudioModel, child) => Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MyNavigationBar(clickFunction: () {
              pickImage().then((value) {
                Fluttertoast.showToast(msg: 'please wait..');
                extractData(value).then((value) {
                  Fluttertoast.showToast(msg: 'getting music list, wait..');
                  getMusics(value).then((value) {
                    print(audioData.first['url']);
                    myAudioModel.playAudio(audioData.first['url']);
                  });
                });
              });
            }),
            Text(
              "$moodDetail",
              style: TextStyle(
                  fontSize: 20,
                  color: darkPrimaryColor,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: height / 2.5,
              child: AlbumArt(imageUrl: audioData.first['image']),
            ),
            // Text(
            //   'Gidget',
            //   style: TextStyle(
            //       fontSize: 28,
            //       fontWeight: FontWeight.w500,
            //       color: darkPrimaryColor),
            // ),
            // Text(
            //   'The Free Nationals',
            //   style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w400,
            //       color: darkPrimaryColor),
            // ),
            Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                      trackHeight: 5,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
                  child: Consumer<MyAudio>(
                    builder: (_, myAudioModel, child) => Slider(
                      value: myAudioModel.position == null
                          ? 0
                          : myAudioModel.position!.inMilliseconds.toDouble(),
                      activeColor: darkPrimaryColor,
                      inactiveColor: darkPrimaryColor.withOpacity(0.3),
                      onChanged: (value) {
                        myAudioModel
                            .seekAudio(Duration(milliseconds: value.toInt()));
                      },
                      min: 0,
                      max: myAudioModel.totalDuration == null
                          ? 20
                          : myAudioModel.totalDuration!.inMilliseconds
                              .toDouble(),
                    ),
                  ),
                ),
              ],
            ),
            PlayerControls(data: audioData),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Future<List> getMusics(String mood) async {
    var params = {
      "mood": mood,
    };
    List result = await getData("list.php", params: params);
    print(result.first['image']);
    setState(() {
      audioData = result;
    });
    return audioData;
  }
}
