import 'package:flutter/material.dart';

import 'package:movies/src/provides/peliculas_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cines'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.search), 
            onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch(),
                //query: 
              );
            }
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTargetas(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _swiperTargetas() {
    
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData) {
          return  CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Populares', style: TextStyle(color: Colors.black, fontSize: 16.0)),
          ),
          SizedBox(height: 15.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if(snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator()
                  )
                );
              }

            }
          )
        ],
      ),
    );
  }

}