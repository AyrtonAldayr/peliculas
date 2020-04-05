import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '1fb6cb00bdb5228a62aa9ddf21b91e0e';
  String _url = 'api.themoviedb.org';
  String _lenguaje = 'es-ES';

  int _popularesPage=0;
  bool _cargando = false;
  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  // ignore: non_constant_identifier_names

  Function(List<Pelicula>) get popularesSink =>  _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularStream => _popularesStreamController.stream;

  void disposesStrams(){
    _popularesStreamController?.close();
  }

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
    if(_cargando) return [];

    _cargando = true;
    _popularesPage++;

    print('Cargando siguiente: '+_popularesPage.toString());

    final url = Uri.http(
        _url, '3/movie/popular', {'api_key': _apikey, 'language': _lenguaje, 'page':_popularesPage.toString()});
    //return await _procesarRespuesta(url);
    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando= false;
    return resp;
  }
}
