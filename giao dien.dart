import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListPage(),
    );
  }
}

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<Article> articles = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'business';

  @override
  void initState() {
    super.initState();
    fetchNews(selectedCategory);
  }

  Future<void> fetchNews(String category) async {
    String apiUrl =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=f8bb7a44a3a54ddc8a3025e0e72c6b67';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        articles = (jsonData['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    fetchNews(selectedCategory);
  }

  void onSearchSubmitted(String query) async {
    String apiUrl =
        'https://newsapi.org/v2/everything?q=$query&apiKey=f8bb7a44a3a54ddc8a3025e0e72c6b67';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        articles = (jsonData['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      });
    } else {
      throw Exception('Failed to search news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(onSearchSubmitted),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index].title),
            subtitle: Text(articles[index].source),
            onTap: () {},
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Sports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Science',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              onCategorySelected('business');
              break;
            case 1:
              onCategorySelected('sports');
              break;
            case 2:
              onCategorySelected('science');
              break;
          }
        },
      ),
    );
  }
}

class Article {
  final String source;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;

  Article({
    required this.source,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source']['name'],
      title: json['titl
