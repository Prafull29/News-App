import 'package:flutter/material.dart';
import 'package:news_app/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.blue.shade100,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade100,
                      Colors.blueAccent
                    ]
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 200,),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/icon.png"),
                  radius: 150,
                ),
                SizedBox(height: 25,),
                Text("NEWS APP",style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.deepOrange,)),
                SizedBox(height: 25,),
                SpinKitFadingCircle(color: Colors.deepOrange, size: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


