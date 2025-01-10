import 'package:assignment_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:assignment_app/constants/export_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          readOnly: true,
          onTap: () => Navigator.pushNamed(context, '/search'),
          decoration: InputDecoration(
            hintText: searchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: ApiService.fetchMovies(fetchAllMoviesUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text(fetchError));
          }
          if (snapshot.hasData) {
            final movies = snapshot.data as List<dynamic>;
            if (movies.isEmpty) {
              return const Center(child: Text(noResultsFound));
            }
            return ListView.builder(
              padding: commonPadding,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  contentPadding: verticalPadding,
                  leading: CachedNetworkImage(
                    imageUrl: movie['show']['image']?['medium'] ?? '',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(movie['show']['name'], style: titleTextStyle),
                  subtitle: Text(
                    movie['show']['summary'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: subtitleTextStyle,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: movie['show'],
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text(fetchError));
        },
      ),
    
    );
  }
}
