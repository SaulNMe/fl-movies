import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/provides/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'The flash',
    'Doctor Strange',
    'Capitan America',
    'Avengers',
    'Hombres de negro',
    'Sonic',
    'Fast and Furious',
    'Era de ultron',
    '4 Fantasticos',
    'Godzilla',
  ];

  final peliculasRecientes = [
    'The Flash',
    'Avengers'
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Builder que crea los resultados para mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando la persona escribe
    if(query.isEmpty) { return Container();}
    
    return FutureBuilder(
      future: peliculasProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView.builder(
            itemBuilder: (BuildContext context, i) {
              peliculas[i].uniqueId = peliculas[i].id.toString() + "search";
              return Container(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child: ListTile(
                  leading: Hero(
                    tag: peliculas[i].uniqueId,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/img/no-image.jpg'), 
                      image: NetworkImage(peliculas[i].getPosterImg()),
                      width: 50.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(peliculas[i].title),
                  subtitle: Text(peliculas[i].originalTitle),
                  onTap: (){
                    close(context, null);
                    peliculas[i].uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: peliculas[i]);
                  },
                ),
              );
            }
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias que aparecen cuando la persona escribe
  //   final suggestionList = (query.isEmpty) 
  //                         ? peliculasRecientes 
  //                         : peliculas.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();

  //   return ListView.builder(
  //     itemCount: suggestionList.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.local_movies),
  //         title: Text(suggestionList[i]),
  //         onTap: () {},
  //       );
  //     },
  //   );
  // }
}