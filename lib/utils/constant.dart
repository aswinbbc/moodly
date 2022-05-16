import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  Constants._();
  static const double padding = 20;

  static const double avatarRadius = 45;
  static const BASE_URL =
      "https://aswinwebsite.000webhostapp.com/emo_music_admin/";
  // static const BASE_URL = "http://192.168.129.116/emo_music_admin/";

  static Future<String> getUserId() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? "0";
  }
}
