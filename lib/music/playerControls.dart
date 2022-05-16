import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'model/myaudio.dart';

import 'colors.dart';

class PlayerControls extends StatefulWidget {
  PlayerControls({Key? key, required this.data}) : super(key: key);
  final List data;

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Controls(
          //   icon: Icons.repeat,
          // ),
          PreviousSong(
              url: index == 0
                  ? widget.data.last['url']
                  : widget.data.elementAt(index - 1)['url']),
          PlayControl(
            url: widget.data.elementAt(index)['url'],
          ),
          NextSong(
              url: index == (widget.data.length - 1)
                  ? widget.data.first['url']
                  : widget.data.elementAt(index + 1)['url']),
          // Controls(
          //   icon: Icons.shuffle,
          // ),
        ],
      ),
    );
  }
}

class PlayControl extends StatelessWidget {
  const PlayControl({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAudio>(
      builder: (_, myAudioModel, child) => GestureDetector(
        onTap: () {
          myAudioModel.audioState == "Playing"
              ? myAudioModel.pauseAudio()
              : myAudioModel.playAudio(url);
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: darkPrimaryColor.withOpacity(0.5),
                  offset: Offset(5, 10),
                  spreadRadius: 3,
                  blurRadius: 10),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-3, -4),
                  spreadRadius: -2,
                  blurRadius: 20)
            ],
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: darkPrimaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: darkPrimaryColor.withOpacity(0.5),
                            offset: Offset(5, 10),
                            spreadRadius: 3,
                            blurRadius: 10),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-3, -4),
                            spreadRadius: -2,
                            blurRadius: 20)
                      ]),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  child: Center(
                      child: Icon(
                    myAudioModel.audioState == "Playing"
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 50,
                    color: darkPrimaryColor,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextSong extends StatelessWidget {
  const NextSong({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAudio>(
      builder: (_, myAudioModel, child) => GestureDetector(
        onTap: () {
          Fluttertoast.showToast(msg: 'song loading...');
          myAudioModel.playAudio(url);
        },
        child: Controls(
          icon: Icons.skip_next,
        ),
      ),
    );
  }
}

class PreviousSong extends StatelessWidget {
  PreviousSong({Key? key, required this.url}) : super(key: key);

  final String url;
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAudio>(
      builder: (_, myAudioModel, child) => GestureDetector(
        onTap: () {
          Fluttertoast.showToast(msg: 'song loading...');
          myAudioModel.playAudio(url);
        },
        child: Controls(
          icon: Icons.skip_previous,
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final IconData icon;

  const Controls({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: darkPrimaryColor.withOpacity(0.5),
              offset: Offset(5, 10),
              spreadRadius: 3,
              blurRadius: 10),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -4),
              spreadRadius: -2,
              blurRadius: 20)
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: darkPrimaryColor.withOpacity(0.5),
                        offset: Offset(5, 10),
                        spreadRadius: 3,
                        blurRadius: 10),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -4),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ]),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: primaryColor, shape: BoxShape.circle),
              child: Center(
                  child: Icon(
                icon,
                size: 30,
                color: darkPrimaryColor,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
