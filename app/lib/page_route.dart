import 'package:flutter/material.dart';

class BottomUpPageRoute extends PageRouteBuilder {
  final Widget page;

  BottomUpPageRoute({required this.page}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

      var offsetAnimation = tween.animate(curvedAnimation);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
