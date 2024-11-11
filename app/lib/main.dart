import 'package:app/sign_in.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Netflix',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ super.key });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFF00081D),
      body: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  "assets/images/netflix.svg",
                  width: 124,
                ),
        
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/menu.svg",
                      height: 18,
                    ),
                    const SizedBox(width: 35,),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF83858C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignIn()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          )
                        ),
                      ),
                    ),
                  ],
                )
              ]
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 500,
              child: PageView(
                controller: _controller,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            "assets/images/onBoard1.png",
                            height: 250,
                          ),
                        ),

                        Text(
                          "Watch everywhere",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cabin(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 41,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                          child: Text(
                            "Stream on your phone, tablet, laptop and TV.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  // -------------------------------------------------------------------------------

                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            "assets/images/onBoard2.png",
                            height: 250,
                          ),
                        ),

                        Text(
                          "There's a plan for every fan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cabin(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 41,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                          child: Text(
                            "Small price. Big entertainment.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )
                          ),
                        )
                      ],
                    ),
                  ),

                  // -------------------------------------------------------------------------------

                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                            "assets/images/onBoard3.png",
                            height: 250,
                          ),
                        ),

                        Text(
                          "Cancel online anytime",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cabin(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 41,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                          child: Text(
                            "Join today, no reason to wait.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

            ),
            SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: const WormEffect(
                activeDotColor: Colors.white,
                dotColor: Color(0xFF8E8E93),
                dotHeight: 9,
                dotWidth: 9,
                spacing: 12,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 77,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF932158), 
                                Color(0xFFE50914), 
                                Color(0xFF942158),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 75,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2A1723), Color(0xFF030203)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 14, right: 14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Create a Netflix account and more at",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "netflix.com/more",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0A84FF),
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
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
