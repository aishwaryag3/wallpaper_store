
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:wallpaper_store/model/categories_model.dart';
import 'package:wallpaper_store/data/data.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_store/model/wallpaper_model.dart';
import 'package:wallpaper_store/views/categories.dart';
import 'package:wallpaper_store/views/search.dart';
import 'package:wallpaper_store/widgets/widget.dart';
import 'package:http/http.dart' as http;

import 'image_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  List <CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async
  {
    var response = await http.get("https://api.pexels.com/v1/curated?per_page=15&page=1", headers: {
      "Authorization" : apiKey
    });
    //print (response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element)
    {
    //  print(element);
   WallpaperModel wallpaperModel = new WallpaperModel();
   wallpaperModel = WallpaperModel.fromMap(element);
   wallpapers.add(wallpaperModel);
    });

    setState((){

    }
    );

  }


  @override
  void initState()
  {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }


 @override
 Widget build(BuildContext context) {
       return Scaffold(
         backgroundColor: Colors.white,
        appBar: AppBar(
          title: BrandName(),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children:<Widget>[
               Container(
                 decoration: BoxDecoration(
                   color: Color(0xfff5f8fd),
                   borderRadius: BorderRadius.circular(30)
                 ),
                 padding: EdgeInsets.symmetric(horizontal: 15),
                 margin: EdgeInsets.symmetric(horizontal: 24),
                 child: Row(children: <Widget>[
                   Expanded(
                        child: TextField(
                          controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search wallpaper",
                        border: InputBorder.none
                      ),
                     ),
                     ),
                   GestureDetector(
                     onTap:(){
                       Navigator.push(context, MaterialPageRoute(
                         builder:(context) => Search(
                          searchQuery: searchController.text,
                         )
                       ));
                             },

                     child: Container(
                   child: Icon(Icons.search)),
                   ),
                 ],),
               ),
             SizedBox(height: 16,),
             Container(
               height: 80,
               child: ListView.builder(
                 padding: EdgeInsets.symmetric(horizontal: 24),
                 itemCount: categories.length,
                 shrinkWrap: true,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context, index)
                    {
                      return CategoryTile(
                      title: categories[index].categoryName,
                      ImageUrl: categories[index].imageUrl,
                    );
                    }),
             ),
                SizedBox(height: 16),
                wallpapersList(wallpapers: wallpapers, context: context)

              ],
            ),
          ),
        ),
       );
  }
}


class CategoryTile extends StatelessWidget {

  final String ImageUrl, title;
  CategoryTile({@required this.title,@required this.ImageUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Categories(
            categoryName: title.toLowerCase(),
          )//
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(children: <Widget> [

         ClipRRect(
            borderRadius: BorderRadius.circular(8),
             child: Image.network(ImageUrl, height:50, width: 100, fit: BoxFit.cover,)),
         Container(

           decoration: BoxDecoration(
             color: Colors.black26,
             borderRadius: BorderRadius.circular(8),
           ),
           height: 50, width: 100,
           alignment: Alignment.center,
           child: Text(title, style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 15,),),
         ),
        ],),
      ),
    );
  }
}

