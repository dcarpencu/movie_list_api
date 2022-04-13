import 'dart:convert';

import 'package:http/http.dart';

Future<void> main() async {
  final Response response = await get(Uri.parse('https://yts.mx/api/v2/list_movies.json?quality=3D'));

  final Map<String, dynamic> result = jsonDecode(response.body) as Map<String, dynamic>;
  final List<dynamic> movies = result['data']['movies'] as List<dynamic>;

  final List<Movie> data = <Movie>[];
  for (int i = 0; i < movies.length; i++) {
    final Map<String, dynamic> item = movies[i] as Map<String, dynamic>;
    data.add(Movie.fromJson(item));
  }
  print(data);
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
