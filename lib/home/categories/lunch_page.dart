// ignore_for_file: unused_field, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unnecessary_import, deprecated_member_use, use_super_parameters, sized_box_for_whitespace

import 'dart:convert';
import 'dart:ui';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

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

class LunchPage extends StatefulWidget {
  const LunchPage({Key? key}) : super(key: key);

  @override
  State<LunchPage> createState() => _LunchPageState();
}

class _LunchPageState extends State<LunchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JsonData> jsonDataList = [];

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<JsonData> filteredJsonDataList = [];
  JsonData? jsonData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _startSearch() {
    setState(() {
      isSearching = true;
      _searchController.text = '';
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
      filteredJsonDataList.clear();
    });
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredJsonDataList = jsonDataList
            .where((jsonData) =>
                jsonData.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredJsonDataList = List.from(jsonDataList);
      }
    });
  }

  Future<void> fetchData() async {
    const singleJsonUrl = 'https://pastebin.com/raw/hH5uepL9';

    try {
      final response = await http.get(Uri.parse(singleJsonUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonDataList = jsonData.map<JsonData>((data) {
          return JsonData(
            imgUrl: data['imgUrl'],
            bgUrl: data['bgUrl'],
            title: data['title'],
            subtitle: data['subtitle'],
            score: data['score'],
            time: data['time'],
            from: data['from'],
            desc: data['desc'],
            ingredients: List.from(data['ingredients']),
            steps: List.from(data['steps']),
            foods: List.from(
              data['foods'],
            ),
          );
        }).toList();

        filteredJsonDataList = List.from(jsonDataList);

        setState(() {});
      } else {
        Scaffold(
          backgroundColor: Color(0xFF0D0D0D),
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
        backgroundColor: Color(0xFF0D0D0D),
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

  int calculatePageCount() {
    return (filteredJsonDataList.length / (itemsPerPage * storiesPerRow))
        .ceil();
  }

  List<List<JsonData>> chunkStories() {
    final List<List<JsonData>> chunkedStories = [];
    for (int i = 0; i < filteredJsonDataList.length; i += itemsPerPage) {
      final List<JsonData> chunk = filteredJsonDataList.sublist(
        i,
        i + itemsPerPage,
      );
      chunkedStories.add(chunk);
    }
    return chunkedStories;
  }

  List<JsonData> getStoriesForCurrentPage() {
    final int startIndex = currentPage * itemsPerPage * storiesPerRow;
    final int endIndex = (currentPage + 1) * itemsPerPage * storiesPerRow;
    return filteredJsonDataList.sublist(
        startIndex, endIndex.clamp(0, filteredJsonDataList.length));
  }

  int currentPage = 0;
  final int itemsPerPage = 5;
  final int storiesPerRow = 2;

  void goToNextPage() {
    final int lastPage = calculatePageCount() - 1;
    if (currentPage < lastPage) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recepy Momy",
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Lunch",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching ? _stopSearch() : _startSearch();
                    });
                  },
                  child: AnimSearchBar(
                    width: 200,
                    rtl: true,
                    textController: _searchController,
                    onSuffixTap: () {
                      _stopSearch();
                    },
                    onSubmitted: _performSearch,
                    helpText: "Search...",
                    animationDurationInMilli: 735,
                    color: Colors.white,
                    textFieldIconColor: Color.fromARGB(255, 241, 106, 53),
                    searchIconColor: Color.fromARGB(255, 241, 106, 53),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                for (int pageIndex = 0;
                    pageIndex < calculatePageCount();
                    pageIndex++)
                  if (pageIndex == currentPage)
                    Column(
                      children: [
                        for (int rowIndex = 0;
                            rowIndex < itemsPerPage;
                            rowIndex++)
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              for (int columnIndex = 0;
                                  columnIndex < storiesPerRow;
                                  columnIndex++)
                                if (rowIndex * storiesPerRow + columnIndex <
                                    getStoriesForCurrentPage().length)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          jsonData: getStoriesForCurrentPage()[
                                              rowIndex * storiesPerRow +
                                                  columnIndex],
                                        ),
                                      ));
                                    },
                                    child: AnimationLimiter(
                                      child:
                                          AnimationConfiguration.synchronized(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          curve: Curves.decelerate,
                                          child: FadeInAnimation(
                                            child: buildJsonContainer(
                                                getStoriesForCurrentPage()[
                                                    rowIndex * storiesPerRow +
                                                        columnIndex]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                      ],
                    ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (calculatePageCount() > 1 && currentPage > 0)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Colors.grey.shade400,
                            ),
                            const BoxShadow(
                              offset: Offset(-3.0, -3.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Colors.white,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 241, 106, 53),
                        ),
                        child: GestureDetector(
                          onTap: goToPreviousPage,
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFFf2f2f2),
                          ),
                        ),
                      ),
                    if (calculatePageCount() > 1 &&
                        currentPage < calculatePageCount() - 1)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Colors.grey.shade400,
                            ),
                            const BoxShadow(
                              offset: Offset(-3.0, -3.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              color: Colors.white,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 241, 106, 53),
                        ),
                        child: GestureDetector(
                          onTap: goToNextPage,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFf2f2f2),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJsonContainer(JsonData jsonData) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 40),
          height: 190,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Color(0xfff2f2f2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(4.0, 4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
                color: Colors.grey.shade500,
              ),
              BoxShadow(
                offset: Offset(-4.0, -4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
                color: Colors.white,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 106, 53),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
                topLeft: Radius.circular(70),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    jsonData.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(jsonData.from),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 2,
          child: Image.network(
            jsonData.imgUrl,
            width: 120,
          ),
        ),
      ],
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
