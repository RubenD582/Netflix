import 'package:app/home.dart';
import 'package:app/page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Info extends StatefulWidget {
  Info({
    super.key, 
    required this.show,
  });

  Map<String, dynamic> show;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late YoutubePlayerController _controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrailerUrl();
  }

  Future<void> _loadTrailerUrl() async {
    String url = await fetchTrailerUrl(widget.show['id']) ?? "";
    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId: url,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
          hideThumbnail: false,
          forceHD: true,
          controlsVisibleAtStart: false
          
        ),
      );

      setState(() {
        loading = false;
      });
    });
  }

  Future<String?> fetchTrailerUrl(int movieId) async {
    final url = Uri.parse('http://127.0.0.1:5000/trailer_url?movie_id=$movieId');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('trailer_url')) {
          return data['trailer_url'];
        } else {
          if (kDebugMode) {
            print("Trailer not found");
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print("Failed to fetch trailer: ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching trailer URL: $e");
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading 
    ? Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    ) : Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300), 
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red, 
                  onReady: () {
                    _controller.addListener(() {
              
                    });
                  },
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      BottomUpPageRoute(page: Home()), 
                    );
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(
                        Radius.circular(100)
                      )
                    ),
                    child: Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/logo-short.svg",
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 10,),
                  const Text(
                    "S E R I E S",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB6B6B6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
           Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Text(
                      widget.show['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    "${widget.show['release_date']} • 4 Seasons",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  SvgPicture.asset(
                    "assets/images/dolby.svg",
                    width: 56,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset("assets/images/play.svg"),
                      const Text(
                        'Resume',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset(
                        "assets/images/download.svg",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 15,),
                      const Text(
                        'Download',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Text(
                widget.show['overview'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Cast: Winona Ryder, David Harbour, Millie Bobby Brown...",
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Creator: The Duffer Brothers",
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 15, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/add-list.svg",
                        width: 20,
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "My List",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/rate.svg",
                        width: 20,
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Rate",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/share.svg",
                        width: 20,
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Share",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 5,
                    color: const Color(0xFFE50913),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Row(
                children: [
                  Text(
                    "More Like This",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    showIcon("assets/images/movies/show10.jpg", true),
                    const SizedBox(width: 10),
                    showIcon("assets/images/movies/show11.jpg"),
                    const SizedBox(width: 10),
                    showIcon("assets/images/movies/show12.jpg"),
                    const SizedBox(width: 10),
                    showIcon("assets/images/movies/show13.jpg"),
                    const SizedBox(width: 10),
                    showIcon("assets/images/movies/show14.jpg"),
                    const SizedBox(width: 10),
                    showIcon("assets/images/movies/show15.jpg"),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget showIcon(String imageURL, [bool recentlyAdded = false]) {
    return SizedBox(
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
                child: Image.asset(
                  imageURL,
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
                      ),
                    ),
                  ),
                ),
              ) : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
