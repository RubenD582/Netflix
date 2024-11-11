import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSelect extends StatefulWidget {
  const ProfileSelect({super.key});

  @override
  State<ProfileSelect> createState() => _ProfileSelectState();
}

class _ProfileSelectState extends State<ProfileSelect> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
        title: Text(
          "Who's watching?",
          textAlign: TextAlign.center,
          style: GoogleFonts.cabin(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 21,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/profile/blue.svg",
                        height: 125,
                        width: 125,
                      ),
                      const SizedBox(height: 12,),
                      const Text(
                        "Ruben",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30,),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/profile/yellow.svg",
                      height: 125,
                      width: 125,
                    ),
                    const SizedBox(height: 12,),
                    const Text(
                      "Kids",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/profile/red.svg",
                      height: 125,
                      width: 125,
                    ),
                    const SizedBox(height: 12,),
                    const Text(
                      "Daniela",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30,),
                Column(
                  children: [
                    Container(
                      height: 124,
                      width: 124,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF4D4D4D),
                          width: 2.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/add.svg",
                          height: 48,
                          width: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    const Text(
                      "Add profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}