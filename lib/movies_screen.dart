import 'package:film/api/api.dart';
import 'package:film/model/movie_model.dart';
import 'package:flutter/material.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = ApiService.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Error loading movies",
                    style: TextStyle(color: Colors.black)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No movies available",
                    style: TextStyle(color: Colors.black)));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 10),
                    child: Text(
                      "Popular",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Movie movie = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         MovieDetailsScreen(movieId: movie.id),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 180,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                          child: Icon(Icons.error,
                                              size: 50, color: Colors.red));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          movie.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber, size: 18),
                                            const SizedBox(width: 5),
                                            Text(
                                              " ${movie.rating.toStringAsFixed(1)} IMDb ",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        FutureBuilder<MovieDetails>(
                                          future: ApiService.getMovieDetails(
                                              movie.id),
                                          builder: (context, detailsSnapshot) {
                                            if (detailsSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting ||
                                                !detailsSnapshot.hasData) {
                                              return const SizedBox.shrink();
                                            } else {
                                              final movieDetails =
                                                  detailsSnapshot.data!;
                                              return Wrap(
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: movieDetails.genres
                                                    .map((genre) => Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Text(
                                                            genre,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .blue),
                                                          ),
                                                        ))
                                                    .toList(),
                                              );
                                            }
                                          },
                                        ),
                                        FutureBuilder<MovieDetails>(
                                          future: ApiService.getMovieDetails(
                                              movie.id),
                                          builder: (context, detailsSnapshot) {
                                            if (detailsSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text("Loading...",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12));
                                            } else if (detailsSnapshot
                                                    .hasError ||
                                                !detailsSnapshot.hasData) {
                                              return const Text(
                                                  "Unknown Runtime",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12));
                                            } else {
                                              final movieDetails =
                                                  detailsSnapshot.data!;
                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.access_time,
                                                      color: Colors.grey,
                                                      size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${movieDetails.runtime ~/ 60}h ${movieDetails.runtime % 60}m",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
