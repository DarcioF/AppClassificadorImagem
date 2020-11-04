import 'package:splashscreen/splashscreen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 5,
          backgroundColor: Colors.blue,
          navigateAfterSeconds: MyApp(),
         loaderColor: Colors.transparent,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: 400,
                width: 400,
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.contain
                    )
                ),
              ),
            ),
            Center(
             child: Container(
                width: 300,
                height: 300,
                padding: EdgeInsets.all(10),
                child: FlareActor(
                  "assets/loading2.flr",
                  animation: "loading",
                  fit: BoxFit.contain,
                ),
          ),
        ),
          ],
        ),
        
      ],
    );
  }
}