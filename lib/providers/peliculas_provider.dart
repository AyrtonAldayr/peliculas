import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '1fb6cb00bdb5228a62aa9ddf21b91e0e';
  String _url = 'api.themoviedb.org';
  String _lenguaje = 'es-ES';

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final dacodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(dacodeData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.http(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _lenguaje});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    final url = Uri.http(
        _url, '3/movie/popular', {'api_key': _apikey, 'language': _lenguaje});
    return await _procesarRespuesta(url);
  }
}
