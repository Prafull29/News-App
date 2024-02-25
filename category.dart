import 'dart:convert';
import 'package:news_app/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/model.dart';
import 'package:news_app/newsView.dart';

class Category extends StatefulWidget {

  late String Query;
  Category({this.Query="NA"});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList=<NewsQueryModel>[];
  bool isLoading=true;
  getNewsByQuery(String query)async{
    String url="https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=c6251ce4474d46dda24a1998f2b46632";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);
    setState(() {
      try{
        data["articles"].forEach((element){
          NewsQueryModel newsQueryModel=new NewsQueryModel();
          newsQueryModel=NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading=false;
          });
        });
      }
      catch(e) {
      };
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.Query.toString().toUpperCase(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 40),),
                    ],
                  ),
                ),
                Container(
                  child: isLoading ? Container(height: MediaQuery.of(context).size.height-90, child: Center(child: CircularProgressIndicator())) : ListView.builder(
                      itemCount: newsModelList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        try{
                          return Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(url: newsModelList[index].newsUrl,)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  elevation: 2.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:BorderRadius.circular(25),
                                        child: Image.network(newsModelList[index].newsImg,fit: BoxFit.fitHeight, height:250, width: double.infinity,),
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(0),
                                                    topRight: Radius.circular(0),
                                                    bottomLeft: Radius.circular(25),
                                                    bottomRight: Radius.circular(25),
                                                  ),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.black12.withOpacity(0),
                                                        Colors.black
                                                      ]
                                                  )
                                              ),
                                              padding: EdgeInsets.fromLTRB(15, 10, 10, 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(newsModelList[index].newsHead,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                                                  Text(newsModelList[index].newsDes.length>50 ? "${newsModelList[index].newsDes.substring(0,50)}...." : newsModelList[index].newsDes, style: TextStyle(color: Colors.white,fontSize: 15),)
                                                ],
                                              )
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          );
                        }
                        catch(e){
                          Container();
                        };
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

