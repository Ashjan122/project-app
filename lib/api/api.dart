import 'dart:convert';
import 'package:film/model/movie_model.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String apiKey = "3ee561b06f4878efe26f736f9cd5a27b";
  static const String baseUrl = "https://api.themoviedb.org/3";

  
  static Future<List<Movie>> getPopularMovies() async {
    Uri url = Uri.parse("$baseUrl/movie/popular?api_key=$apiKey&language=en-US");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

 
  static Future<MovieDetails> getMovieDetails(int movieId) async {
    Uri url = Uri.parse("$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return MovieDetails.fromJson(data);
    } else {
      throw Exception("Failed to load movie details");
    }
  }
}