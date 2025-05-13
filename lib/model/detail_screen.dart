import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/NewsResponse.dart';
import 'package:news_app/webview_screen.dart';

import '../helper.dart';

class DetailScreen extends StatelessWidget {

  final Articles articles;
  const DetailScreen({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image(height, context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(),
                SizedBox(height: 8),
                author(),
                SizedBox(height: 8),
                content(),
                SizedBox(height: 8),
                readMore(context),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget image(double height, BuildContext context) {
    return Stack(
      children: [
        // SizedBox(
        //   // color: Colors.redAccent,
        //   width: double.infinity,
        //   height: height / 3,
        //   child: Image.asset('assets/image/image_3.jpeg', fit: BoxFit.cover),
        // ),
        SizedBox(
          height: height / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              fit: BoxFit.cover,
              articles.urlToImage ?? "https://placehold.co/600x400",
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
        SafeArea(
          minimum: EdgeInsets.only(left: 8),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
      ],
    );
  }

  Widget title() {
    return Text(
        articles.title ?? "-",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
    );
  }

  Widget author() {
    String formattedDate = Helper.formatDate(articles.publishedAt, 'dd MMM yyyy');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${articles.author}"),
        Text("${articles.source?.name}"),
        Text("${formattedDate}"),
      ],
    );
  }

  Widget content() {
    return Text(
      articles.content ?? "-",
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      )
    );
  }

  Widget readMore(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebviewScreen(url: articles.url ?? "https://google.com")),
        );
      },
      child: Text(
        "Read more in web",
        style: TextStyle(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
          fontSize: 16
        )
      ),
    );
  }
}
