import 'dart:ui';
import 'package:app/info.dart';
import 'package:app/page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> trendingShowData = {};
  List<Map<String, dynamic>> nowPlayingData = [];
  List<Map<String, dynamic>> topRatedData = [];
  List<Map<String, dynamic>> upcomingData = [];

  late ScrollController _scrollController;
  double _scrollValue = 0.0;

  bool isLoading = true;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() {
      setState(() {
        _scrollValue = _scrollController.offset;
      });
    }); 

    fetchData();

    super.initState();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var responses = await fetchShows('fetch_all');
      setState(() {
        trendingShowData = responses['trending'];
        trendingShowData['background_color'] = Colors.black;

        _getAverageColor(trendingShowData['poster_path']);

        nowPlayingData = List<Map<String, dynamic>>.from(responses['now_showing']);
        topRatedData = List<Map<String, dynamic>>.from(responses['top_rated']);
        upcomingData = List<Map<String, dynamic>>.from(responses['upcoming']);
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching data: $error");
      }
      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<Map<String, dynamic>> fetchShows(String endpoint) async {
    final url = Uri.parse('http://127.0.0.1:5000/$endpoint');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
      rethrow;
    }
  }

  Future<void> _getAverageColor(String posterUrl) async {
    try {
      final response = await http.get(Uri.parse(posterUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

        if (image != null) {
          Color color = _calculateAverageColor(image);
          trendingShowData['background_color'] = color;
          setState(() {}); 
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching or processing image: $e");
      }
    }
  }

  Color _calculateAverageColor(img.Image image) {
    double red = 0;
    double green = 0;
    double blue = 0;
    double count = 0;
    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        img.Pixel pixel = image.getPixel(x, y);
        red = red + pixel.r;
        green = green + pixel.g;
        blue = blue + pixel.b;
        count = count + 1;
      }
    }
    int rf = red ~/ count;
    int gf = green ~/ count;
    int bf = blue ~/ count;
    
    return Color.fromRGBO(rf, gf, bf, 1);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    double opacity = (1 - (_scrollValue / 75.0)).clamp(0.0, 1.0);
    double translateY = (_scrollValue * 0.25).clamp(0.0, 50.0);
    double appBarHeight = (120 - (translateY * 1.5)).clamp(70, 120);

    double appBarOpacity = (1 - (_scrollValue / 100.0)).clamp(0.0, 1.0);

    return isLoading 
    ? Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    ) : Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 13.0),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity((1 - appBarOpacity).clamp(0, 0.5)),
              leadingWidth: double.infinity,
              leading: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRect(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () => fetchData(),
                              child: const Text(
                                'For Ruben',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/cast.svg",
                                  width: 28,
                                ),
                                const SizedBox(width: 15),
                                SvgPicture.asset(
                                  "assets/images/download.svg",
                                  width: 24,
                                ),
                                const SizedBox(width: 15),
                                SvgPicture.asset(
                                  "assets/images/search.svg",
                                  width: 28,
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 200),
                          child: Transform.translate(
                            offset: Offset(0, -translateY),
                            child: ClipRect(
                              child: Row(
                                children: [
                                  category("TV Shows"),
                                  const SizedBox(width: 5,),
                                  category("Movies"),
                                  const SizedBox(width: 5,),
                                  category("Categories", true),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              elevation: 0.0,
              toolbarHeight: appBarHeight,
              titleSpacing: 0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                trendingShowData['background_color'].withOpacity(0.7),
                Colors.black
              ],
              stops: [0, 0.35],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 200),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      BottomUpPageRoute(page: Info(show: trendingShowData,)), 
                    );

                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 487,
                                  width: 345,
                                  child: trendingShowData['poster_path'] != null
                                      ? CachedNetworkImage(
                                          imageUrl: trendingShowData['poster_path'],
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Container(),
                                ),
                                Container(
                                  height: 487,
                                  width: 345,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(1),
                                      ],
                                      stops: [0, 0.85],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              bottom: 20, 
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 225,
                                    child: trendingShowData['logo'] == null ? const SizedBox() : CachedNetworkImage(
                                      imageUrl: trendingShowData['logo'],
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: Text(
                                      trendingShowData['genre'] == null ? "" : trendingShowData['genre'].join(" • "),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        height: 40,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          onPressed: () {
                  
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/play.svg"
                                              ),
                                              const Text(
                                                'Play',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15,),
                                      SizedBox(
                                        width: 140,
                                        height: 40,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.25),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          onPressed: () {
                  
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/add-list.svg",
                                                width: 20,
                                              ),
                                              const SizedBox(width: 15,),
                                              const Text(
                                                'My List',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                  
                  
                        Container(
                          height: 487,
                          width: 345,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15)
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35,),
                subheading("Mobile Games", true, "My List"),
                const SizedBox(height: 15,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mobileGameIcon(
                        "assets/images/games/game5.png",
                        "GTA: San Andreas",
                        "Action"
                      ),
                      const SizedBox(width: 10,),
                      mobileGameIcon(
                        "assets/images/games/game6.png",
                        "Snake.io",
                        "Arcade"
                      ),
                      const SizedBox(width: 10,),
                      mobileGameIcon(
                        "assets/images/games/game7.png",
                        "World of Goo",
                        "Puzzle"
                      ),
                      const SizedBox(width: 10,),
                      mobileGameIcon(
                        "assets/images/games/game8.png",
                        "Death's Door",
                        "Action"
                      ),
                      const SizedBox(width: 10,),
                      mobileGameIcon(
                        "assets/images/games/game9.png",
                        "Bloons TD 6",
                        "Arcade"
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                subheading("Now Playing"),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: nowPlayingData.map<Widget>((show) {
                      String posterUrl = show['poster_path'] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: displayShow(posterUrl, show),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 30),
                subheading("Top rated shows on Netflix"),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: topRatedData.map<Widget>((show) {
                      String posterUrl = show['poster_path'] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: displayShow(posterUrl, show),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),
                subheading("Upcoming"),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: upcomingData.map<Widget>((show) {
                      String posterUrl = show['poster_path'] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: displayShow(posterUrl, show),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),
                subheading("Top 10 Movies"),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      showTop10("assets/images/movies/show24.jpg", 1),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show25.jpg", 2),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show26.jpg", 3),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show27.jpg", 4),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show28.jpg", 5),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show29.jpg", 6),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show30.jpg", 7),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show31.jpg", 8),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show33.jpg", 9),
                      const SizedBox(width: 5),
                      showTop10("assets/images/movies/show1.jpg", 10),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),



                const SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      )

    );
  }

  Widget showTop10(String imageURL, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 170
          ),
          child: Stack(
            children: [
              index < 10 ? Stack(
                children: <Widget>[
                  Text(
                    index.toString(),
                    style: TextStyle(
                      fontSize: 150,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.white,
                    ),
                  ),
                  Text(
                    index.toString(),
                    style: const TextStyle(
                      fontSize: 150,
                      color: Colors.black,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ],
              ) : Stack(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        (index.toString())[0].toString(),
                        style: TextStyle(
                          fontSize: 150,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        (index.toString())[0].toString(),
                        style: const TextStyle(
                          fontSize: 150,
                          color: Colors.black,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
              
                  Positioned(
                    left: 45,
                    child: Row(
                      children: [
                        Text(
                          (index.toString())[1].toString(),
                          style: TextStyle(
                            fontSize: 140,
                            fontWeight: FontWeight.w900,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Colors.white,
                          ),
                        ),
                        Text(
                          (index.toString())[1].toString(),
                          style: TextStyle(
                            fontSize: 150,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          
              Positioned(
                left: index >= 10 ? 75 : 60,
                top: 20,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: Image.asset(
                        imageURL,
                        filterQuality: FilterQuality.high, 
                        fit: BoxFit.fitHeight,
                        width: 100,
                        height: 150,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(7)
                        )
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30)
            ],
          ),
        ),
      ],
    );
  }

  Widget subheading(String title, [bool trailing = false, String trailingText = ""]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        trailing ? Row(
          children: [
            Text(
              trailingText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 28, 
            ),
          ],
        ) : const SizedBox(),

      ],
    );
  }

  Widget displayShow(String imageURL, var show, [bool recentlyAdded = false]) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BottomUpPageRoute(page: Info(show: show,)),
        );
      },
      child: SizedBox(
        width: 100,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Background image
                ClipRRect(
                  borderRadius: BorderRadius.circular(7.0),
                  child: CachedNetworkImage(
                    imageUrl: imageURL,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fill,
                    width: 100,
                    height: 150,
                  ),
                ),
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                ),
                recentlyAdded ? Positioned(
                  bottom: 0,
                  left: 10,
                  child: Container(
                    width: 80,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE50913),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4), 
                        topRight: Radius.circular(4), 
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "New Season",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        )
                      ),
                    ),
      
                  ),
                ) : const SizedBox()
              ],
            )
        
          ],
        ),
      ),
    );
  }

  Widget mobileGameIcon(String imageURL, String gameName, String genre) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.asset(
                imageURL,
                filterQuality: FilterQuality.high, 
                fit: BoxFit.fill,
                width: 100,
              ),
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(25)
                )
              ),
            )
          ],
        ),
        const SizedBox(height: 5,),
        SizedBox(
          width: 100,
          child: Text(
            gameName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            overflow: TextOverflow.visible, 
            softWrap: true, 
          ),
        ),
        Text(
          genre,
          style: const TextStyle(
            color: Color(0xFF9A9A9A),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget category(String name, [bool dropDown = false]) {
    return IntrinsicWidth(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: dropDown ? 7 : 15),
            child: Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                dropDown ? const Icon(
                  Icons.expand_more,
                  color: Colors.white,
                ) : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
