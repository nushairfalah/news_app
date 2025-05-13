import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/model/detail_screen.dart';

import 'helper.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  late Future<List<Articles>?> futureArticles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureArticles = getNews();
  }

  Future<List<Articles>?> getNews() async {
    String country = "us";
    String category = "sports";
    String apiKey = "6259472dcef04116b2387b9e17d224b9";
    String url =
        "https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=$apiKey";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // biar gak nunggu terus

      debugPrint("RESPONSE HASIL: ${response.statusCode}");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        var status = jsonData['status'];
        debugPrint("Status : $status");

        var newsResponse = NewsResponse.fromJson(jsonData);
        var statusResponse = newsResponse.status;
        debugPrint("Status Response : $statusResponse");

        return newsResponse.articles;
      } else {
        debugPrint("Error HTTP: ${response.statusCode}");
        throw Exception("Gagal mengambil data dari server (Status: ${response.statusCode})");
      }
    } on SocketException {
      debugPrint("SocketException: Tidak ada koneksi internet");
      throw Exception("Tidak ada koneksi internet");
    } on TimeoutException {
      debugPrint("TimeoutException: Request terlalu lama");
      throw Exception("Koneksi terlalu lambat (timeout)");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      throw Exception("Terjadi kesalahan tak terduga: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: futureArticles,
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              debugPrint("data");
              return Center(child: CircularProgressIndicator());
            } else if (data.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${data.error}"),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            futureArticles = getNews();
                          });
                        },
                        child: Text("Refresh")
                    )
                  ],
                )
              );
            } else if (data.hasData) {
              var listArticle = data.data;
              return listViewArticle(listArticle);
            }
            return SizedBox();
          },
      ),
    );
  }

  Widget listViewArticle(List<Articles>? listArticle) {
    if (listArticle == null || listArticle.isEmpty) {
      return Center(
        child: Text("Tidak ada data"),
      );
    }

    return ListView.builder(
      itemCount: listArticle.length,
      itemBuilder: (context, index) {
        var article = listArticle[index];
        return cardArticle(article);
      },
    );
  }

  Widget cardArticle(Articles article) {

    String formattedDate = Helper.formatDate(article.publishedAt, 'dd MMM yyyy', locale: 'en');

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(articles: article,)));
      },
      child: Card(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       elevation: 4,
       child: IntrinsicHeight(
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             SizedBox(
               width: 120,
               child: ClipRRect(
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(16),
                   bottomLeft: Radius.circular(16),
                 ),
                 child: Image.network(
                   fit: BoxFit.cover,
                   article.urlToImage ?? "https://placehold.co/600x400",
                   errorBuilder: (context, error, stackTrace) {
                     return Icon(Icons.image_not_supported_outlined, color: Colors.redAccent);
                   },
                   loadingBuilder: (context, child, loadingProgress) {
                     if (loadingProgress == null) return child;
                     return Center(
                       child: CircularProgressIndicator(),
                     );
                   },
                 ),
               ),
             ),
             Expanded(
               child: Padding(
                 padding: EdgeInsets.all(8),
                 child: Column(
                   children: [
                     Text(
                       article.title ?? "null",
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 18,
                       )
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Flexible(child: Text(article.author ?? "null")),
                         Text(formattedDate),
                       ],
                     ),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
         ),
    );
  }
}
