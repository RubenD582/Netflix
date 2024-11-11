import 'package:app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInCode extends StatefulWidget {
  const SignInCode({super.key});

  @override
  State<SignInCode> createState() => _SignInCodeState();
}

class _SignInCodeState extends State<SignInCode> {
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
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 38,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Help',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
        title: SvgPicture.asset(
          "assets/images/netflix.svg",
          width: 124,
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF262626),
            height: 1.0, // Line height
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Get your sign-in code",
                textAlign: TextAlign.center,
                style: GoogleFonts.cabin(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF333333),
                  labelText: 'Email or phone number',
                  labelStyle: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto, 
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF5B0308),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  onPressed: () {
                    
                  },
                  child: const Text(
                    'Send Code',
                    style: TextStyle(
                      color: Color(0xFF9D686B),
                      fontWeight: FontWeight.w700,
                      fontSize: 15
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontWeight: FontWeight.w600,
                      fontSize: 13
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Sign in is protected by Google reCAPTCHA to ensure you're not a bot.",
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: " Learn More",
                            style: TextStyle(
                              color: Color.fromARGB(255, 196, 195, 195),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
