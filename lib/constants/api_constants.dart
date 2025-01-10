const String baseUrl = 'https://api.tvmaze.com';
const String fetchAllMoviesUrl = '$baseUrl/search/shows?q=all';
String searchMoviesUrl(String query) => '$baseUrl/search/shows?q=$query';
