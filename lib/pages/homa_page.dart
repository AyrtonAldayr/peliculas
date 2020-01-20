import 'package:flutter/material.dart';
import 'package:peliculas/models/pelicula_model.dart';
import 'package:peliculas/widgets/card_swiper_widget.dart';

import '../providers/peliculas_provider.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en Cines'),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            _swiperTarjetas(),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    /*
    final peliculasProvider=new PeliculasProvider();
    peliculasProvider.getEnCines();
    return CardSwiper(peliculas: [1,2]);*/
    return FutureBuilder(
        future: peliculasProvider.getEnCines(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(peliculas: snapshot.data);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
