// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_field, avoid_unnecessary_containers, deprecated_member_use, use_super_parameters, prefer_final_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'categories/breakfast_page.dart';
import 'categories/dessert_page.dart';
import 'categories/dinner_page.dart';
import 'categories/lunch_page.dart';

class JsonData {
  final String imgUrl;
  final String bgUrl;
  final String title;
  final String subtitle;
  final String score;
  final String time;
  final String from;
  final String desc;
  final List<Map<String, dynamic>> ingredients;
  final List<Map<String, dynamic>> steps;
  final List<Map<String, dynamic>> foods;

  JsonData({
    required this.imgUrl,
    required this.bgUrl,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.time,
    required this.from,
    required this.desc,
    required this.ingredients,
    required this.steps,
    required this.foods,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchJsonsData();
  }

  void _filterJson(String searchText) {
    setState(() {
      filteredJsonDataList = jsonDataList
          .where((jsonData) =>
              jsonData.subtitle
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              jsonData.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchJsonsData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/62etf70C';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          jsonDataList = (jsonData as List)
              .map((data) => JsonData(
                    imgUrl: data['imgUrl'],
                    bgUrl: data['bgUrl'],
                    title: data['title'],
                    subtitle: data['subtitle'],
                    score: data['score'],
                    time: data['time'],
                    from: data['from'],
                    desc: data['desc'],
                    ingredients:
                        List<Map<String, dynamic>>.from(data['ingredients']),
                    steps: List<Map<String, dynamic>>.from(data['steps']),
                    foods: List<Map<String, dynamic>>.from(data['foods']),
                  ))
              .toList();
          filteredJsonDataList = List.from(jsonDataList);
        });
      } else {
        Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Center(
              child: SpinKitWave(
                color: Color.fromARGB(255, 241, 106, 53),
                size: 25,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: SpinKitWave(
              color: Color.fromARGB(255, 241, 106, 53),
              size: 25,
            ),
          ),
        ),
      );
    }
  }

  List categories = [
    {
      "image": "assets/images/images (6).jpeg",
      "name": "Breakfast",
      "widget": BreakfastPage(),
    },
    {
      "image": "assets/images/images.jpeg",
      "name": "Dessert",
      "widget": DessertPage(),
    },
    {
      "image": "assets/images/images (4).jpeg",
      "name": "Lunch",
      "widget": LunchPage(),
    },
    {
      "image": "assets/images/images (2).jpeg",
      "name": "Dinner",
      "widget": DinnerPage(),
    },
  ];

  void _navigateToDetailPage(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recepy Momy",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              height: 220,
              padding:
                  EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 30),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 106, 53),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, Chef!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Check Amazing Recipes..",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 55,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 241, 106, 53),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: _filterJson,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: "Find any recipe here..",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade500),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Categories",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        _navigateToDetailPage(context, category["widget"]);
                      },
                      child: Container(
                        height: 50,
                        width: 110,
                        margin: const EdgeInsets.only(right: 10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                category["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(255, 37, 36, 36)
                                    .withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  category["name"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Popular Recipes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredJsonDataList.length,
              itemBuilder: (context, index) {
                final jsonData = filteredJsonDataList[index];

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  jsonData: jsonData,
                                )));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                jsonData.imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(255, 37, 36, 36)
                                    .withOpacity(0.3),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xfff2f2f2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jsonData.subtitle,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/timer.svg",
                                              width: 18,
                                              color: Color.fromARGB(
                                                  255, 241, 106, 53),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Center(
                                            child: Text(
                                              jsonData.time,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        jsonData.score,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final JsonData jsonData;

  const DetailPage({Key? key, required this.jsonData}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final double _confidence = 1.0;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
  }

  List<Offset> currentOffsets = <Offset>[];
  List<Offset> offsets = <Offset>[];
  List<List<Offset>> allOffsets = [];

  Offset? lastPosition;

  @override
  Widget build(BuildContext context) {
    final bgUrl = widget.jsonData.bgUrl;
    final title = widget.jsonData.title;
    final subtitle = widget.jsonData.subtitle;
    final score = widget.jsonData.score;
    final time = widget.jsonData.time;
    final from = widget.jsonData.from;
    final desc = widget.jsonData.desc;

    Widget ingredientWidget = ingredientToJson(widget.jsonData.ingredients);
    Widget stepWidget = stepToJson(widget.jsonData.steps);
    Widget foodWidget = foodToJson(widget.jsonData.foods);

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.network(
              bgUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 235,
            left: 35,
            right: 35,
            child: foodWidget,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 30,
              ),
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              score,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      desc,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 70,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/timer.svg",
                                    color: Color.fromARGB(255, 241, 106, 53),
                                    width: 25,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cooking Time",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      time,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 241, 106, 53),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 70,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/royal-crown-like-an-invert-rounded-bowl-svgrepo-com.svg",
                                    color: Color.fromARGB(255, 241, 106, 53),
                                    width: 25,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "From",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      from,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 241, 106, 53),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/noodles-in-bowl-svgrepo-com.svg",
                          color: Color.fromARGB(255, 241, 106, 53),
                          width: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Ingredients",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ingredientWidget,
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/heating-food-in-flat-pan-on-fire-svgrepo-com.svg",
                          color: Color.fromARGB(255, 241, 106, 53),
                          width: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Steps",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    stepWidget,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget foodToJson(List<Map<String, dynamic>> foods) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          final imagePath = food['imagePath'] as String?;
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 6),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget ingredientToJson(List<Map<String, dynamic>> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var ingredient in ingredients)
          Text(
            ingredient['name'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget stepToJson(List<Map<String, dynamic>> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var step in steps)
          Text(
            step['name'],
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        SizedBox(height: 5),
      ],
    );
  }
}
