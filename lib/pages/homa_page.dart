import 'package:flutter/material.dart';
import 'package:peliculas/models/pelicula_model.dart';
import 'package:peliculas/widgets/card_swiper_widget.dart';
import 'package:peliculas/widgets/movi_horizontal.dart';

import '../providers/peliculas_provider.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Divider(),
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
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

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Popular', style: Theme
                .of(context)
                .textTheme
                .subhead,),
          ),
          SizedBox(height: 5.0,),
          //FutureBuilder(
          StreamBuilder(
              //future: peliculasProvider.getPopulares(),
            stream: peliculasProvider.popularStream,
              builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
                snapshot.data?.forEach((f)=>print(f.title));

                if(snapshot.hasData){
                  return MovideHorizontal(peliculas: snapshot.data,siguientePagina: peliculasProvider.getPopulares,);
                }else{
                  return Center(child: CircularProgressIndicator());
                }
                return Container();
              }),
        ],
      ),
    );
  }
}
