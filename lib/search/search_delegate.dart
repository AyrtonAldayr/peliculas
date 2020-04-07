import 'package:flutter/material.dart';
import 'package:peliculas/models/pelicula_model.dart';
import 'package:peliculas/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate<String> {

  DataSearch(): super(searchFieldLabel:"Buscar");

  String selecccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Homer',
    'Capitan Final',
    'Spiderman',
    'American Dad',
    'La Tortuga voladora',
    'Capitan America',
  ];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda de AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(selecccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
        future: peliculasProvider.getBuscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final peliculas = snapshot.data;
            return ListView(
              children: peliculas.map((peli) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(peli.getPosterImg()),
                    placeholder: AssetImage('assets/images/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                  title: Text(peli.title),
                  subtitle: Text(peli.originalTitle),
                  onTap: () {
                    close(context, null);
                    peli.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: peli);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
