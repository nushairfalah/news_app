import 'package:flutter/material.dart';
import 'package:news_app/news_screen.dart';

class TabbarScreen extends StatefulWidget {
  const TabbarScreen({super.key});

  @override
  State<TabbarScreen> createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> with SingleTickerProviderStateMixin{
  late TabController tabController;
  // List<Widget> tabs = [
  //   Tab(text: "Technology"),
  //   Tab(text: "Business"),
  //   Tab(text: "Entertainment"),
  //   Tab(text: "General"),
  //   Tab(text: "Health"),
  //   Tab(text: "Science"),
  //   Tab(text: "Sports"),
  // ];

  late List<String> categories;
  late List<Widget> tabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    categories = ["Technology","Business","Entertainment","General","Health","Science","Sports"];
    tabs = categories.map((category) => Tab(text: category)).toList();

    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("News App"),
      //   bottom: TabBar(
      //     isScrollable: true,
      //     tabAlignment: TabAlignment.start,
      //     controller: tabController,
      //     tabs: tabs,
      //     indicatorSize: TabBarIndicatorSize.tab,
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: tabController,
              tabs: tabs,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: categories.map((category) =>
                    NewsScreen(category: category.toLowerCase())
                ).toList(),
                // children: [
                //   view("1"),
                //   view("2"),
                //   view("3"),
                //   view("4"),
                //   view("5"),
                //   view("6"),
                //   view("7"),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget view(String view){
    return Center(
      child: Text(view),
    );
  }
}
