import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gradients/gradients.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/model.dart';
import 'package:http/http.dart';
import 'package:news_app/category.dart';
import 'package:news_app/newsView.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchcontroller = new TextEditingController();
  List<String> navBarItem=["Trending", "India", "World", "Finance", "Health", "Sports", "GeoPolitics", "Cricket"];
  List<NewsQueryModel> newsModelList=<NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel=<NewsQueryModel>[];
  bool isLoading1=true;
  getNewsByQuery(String query)async{
    Map element;
    int i=0;
    String url="https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=c6251ce4474d46dda24a1998f2b46632";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading1 = false;
          });
          if (i == 5) {
            break;
          }
        }
        catch (e) {
        };
      }
    });
  }

  bool isLoading2=true;
  getNewsByProvider(String provider)async{
    String url="https://newsapi.org/v2/everything?q=$provider&sortBy=publishedAt&apiKey=c6251ce4474d46dda24a1998f2b46632";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element){
        try{
          NewsQueryModel newsQueryModel=new NewsQueryModel();
          newsQueryModel=NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading2=false;
          });
        }
        catch(e){
        };
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByProvider("India");
    getNewsByQuery("World");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.blue.shade100,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade100,
                  Colors.blue.shade300
                ]
              )
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.fromLTRB(10, 0, 10,0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blue.shade500
                  ),
                  child:
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            if((searchcontroller.text).replaceAll(" ","")!=""){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: searchcontroller.text,)));
                            }
                          },
                          child: Container(
                            child: Icon(Icons.search,color: Colors.white,),
                            margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchcontroller,
                            textInputAction: TextInputAction.search,
                            onSubmitted:(value){
                              if((value).replaceAll(" ","")!=""){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: value)));
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search News"
                            ),
                          ),
                        )
                      ],
                    ),
                ),
                Container(
                  height: 50,
                  child:
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: navBarItem.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query:navBarItem[index])));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
                            decoration: BoxDecoration(
                                color: Colors.tealAccent.shade700,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child: Text(navBarItem[index],style: TextStyle(
                                  fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500
                              ),),
                            ),
                          ),
                        );
                      }
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: isLoading2 ? Container(height:250, child: Center(child: CircularProgressIndicator())) : CarouselSlider(
                      items: newsModelListCarousel.map((instance){
                        return Builder(
                          builder: (BuildContext context){
                            try{
                              return Container(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(url:instance.newsUrl)));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:BorderRadius.circular(25),
                                          child: Image.network(instance.newsImg, fit: BoxFit.fitHeight,height:double.infinity,width: double.infinity,),
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
                                                      Colors.black,
                                                    ]
                                                )
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                            child: Text(instance.newsHead,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            catch(e){
                              return Container();
                            }
                          }
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 250,
                        aspectRatio: 16/9,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("LATEST NEWS",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 25),),
                    ],
                  ),
                ),
                Container(
                  child: isLoading1 ? Container(height: MediaQuery.of(context).size.height-500, child: Center(child: CircularProgressIndicator())) : ListView.builder(
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
                          return Container();
                        };
                      }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: "Latest")));
                    },
                      child: Text("SHOW MORE"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
