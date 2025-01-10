import 'package:assignment_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants/export_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
   createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;
  String? errorMessage;

  void searchMovies(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await ApiService.fetchMovies(searchMoviesUrl(query));
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: searchHint,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: searchMovies,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : searchResults.isEmpty
                  ? const Center(child: Text(noResultsFound))
                  : ListView.builder(
                      padding: commonPadding,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = searchResults[index];
                        return ListTile(
                          contentPadding: verticalPadding,
                          leading: CachedNetworkImage(
                            imageUrl: movie['show']['image']?['medium'] ?? '',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          title: Text(movie['show']['name'],
                              style: titleTextStyle),
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
                    ),
    );
  }
}
