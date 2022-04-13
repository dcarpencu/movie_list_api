import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> _movie = <Movie>[];
  bool _isLoading = true;
  int _pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future<void> _getMovies() async {
    setState(() => _isLoading = true);

    final Response response =
        await get(Uri.parse('https://yts.mx/api/v2/list_movies.json?quality=3D&page=$_pageNumber'));

    final Map<String, dynamic> result = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> movies = result['data']['movies'] as List<dynamic>;

    final List<Movie> data = <Movie>[];
    for (int i = 0; i < movies.length; i++) {
      final Map<String, dynamic> item = movies[i] as Map<String, dynamic>;
      data.add(Movie.fromJson(item));
    }

    setState(() {
      _movie.addAll(data);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @overridez
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _pageNumber++;
                  _getMovies();
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          if (_isLoading && _movie.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else
            return ListView.builder(
                itemCount: _movie.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = _movie[index];

                  return Column(children: <Widget>[
                    Image.network(movie.poster),
                    Text('${movie.year}'),
                    Text(movie.genres.join(', ')),
                    Text('${movie.rating}'),
                  ]);
                });
        }));
  }
}

class Movie {
  Movie({required this.title, required this.year, required this.rating, required this.genres, required this.poster});

  Movie.fromJson(Map<String, dynamic> item)
      : title = item['title'] as String,
        year = item['year'] as int,
        rating = (item['rating'] as num).toDouble(),
        genres = List<String>.from(item['genres'] as List<dynamic>),
        poster = item['medium_cover_image'] as String;

  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String poster;

  @override
  String toString() {
    return 'Movie{title: $title, year: $year, rating: $rating, genres: $genres, poster: $poster}';
  }
}
