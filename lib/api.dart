import 'dart:convert';

import 'package:fluttertube/models/video.dart';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const API_KEY = "AIzaSyDqUMM1_b70gW2vNZYeJghkLF4hAD4mjjw";

class Api {
  late String _search;
  late String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;
    //print("Chegou no search");
    //fazer requisição via HTTP
    http.Response response = await http.get(Uri.parse(
        //Código de requisição do youtube
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"));

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    //print("Chegou no nextPage");
    http.Response response = await http.get(Uri.parse(
        //Código de requisição do youtube
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"));

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    //Verificar se o código de resposta é 200 (significa que deu certo)
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded["items"].map<Video>(
        (map) {
          return Video.fromJson(map);
        },
      ).toList();
      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
