class Movie {  
  final int id;  
  final String title;  
  final String posterPath;  
  final double rating;  
  final String releaseDate;  

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,  
  });

  factory Movie.fromJson(Map<String, dynamic> json) {    
    return Movie(
      id: json["id"],    
      title: json["title"] ?? "Unknown Title",    
      posterPath: json["poster_path"] ?? "",    
      rating: (json["vote_average"] as num?)?.toDouble() ?? 0.0,    
      releaseDate: json["release_date"] ?? "Unknown",    
    );  
  }
}

class MovieDetails {  
  final int id;  
  final String title;  
  final String overview;  
  final String posterPath;  
  final int runtime;  
  final List<String> genres;  
  final String releaseDate;  

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.runtime,
    required this.genres,
    required this.releaseDate,  
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {    
    return MovieDetails(
      id: json["id"],    
      title: json["title"] ?? "Unknown Title",    
      overview: json["overview"] ?? "No description available.",    
      posterPath: json["poster_path"] ?? "",    
      runtime: json["runtime"] ?? 0, 
      genres: (json["genres"] as List<dynamic>?)?.map((genre) => genre["name"].toString()).toList() ?? [],    
      releaseDate: json["release_date"]?.toString() ?? "Unknown",  
    );  
  }

  get rating => null;
}