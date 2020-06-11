import 'package:flutter/material.dart';
import 'package:movies/src/models/actores_modelo.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/provides/peliculas_provider.dart';

class PeliculaDetallePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0,),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula)
            ])
          ),
        ],
      )
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.pinkAccent[400],
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(pelicula.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 300),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(width: 20.0,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis),
                  Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
                  Row(
                    children: <Widget>[
                      _buildRate(pelicula.voteAverage),
                      Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1)
                    ],
                  )
                ],
              )
            )
          ],
        ),
      );
  }

  Widget _buildRate(double voteAverage) {
    List<Widget> items = [];
    int starts = (voteAverage.truncate() / 2).truncate();

    for (var i = 0; i < starts; i++) {
      items.add(Icon(Icons.star, color: Colors.yellow[600],),);
    }

    if(voteAverage - voteAverage.truncate() > 0) {
      items.add(Icon(Icons.star_half, color: Colors.yellow[600],));
    }

    return Row(
      children: items,
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) {
          return _acthorCard(actores[i]);
        }
      ),
    );   
  }

  Widget _acthorCard(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getPhoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }

}