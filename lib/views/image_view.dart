import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageView extends StatefulWidget {

  final String ImageUrl;

  ImageView({@required this.ImageUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  //String albumName = 'flutterimg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
          Hero(
            tag: widget.ImageUrl,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.ImageUrl, fit: BoxFit.cover,)),
          ),

          Container(

            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _save();
                   // Navigator.pop(context);
                  },
                  child: Stack(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          color: Color(0xff1C1B1B).withOpacity(0.8),

                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                         alignment: Alignment.center,
                         // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54, width: 1),
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0x0FFFFFFF)
                                  ]
                              )
                          ),
                          child: Column(children: <Widget>[
                            Text("Set Wallpaper", style: TextStyle(
                                fontSize: 16, color: Colors.white70),),
                            Text("Image will be saved in Gallery",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white70
                              ),)
                          ],),
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 16),
                InkWell(onTap: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.w500),
                ),
                ),
                SizedBox(height: 50),
              ],
            ),
          )
        ],)
    );
  }
    _save() async {
      await _askPermission();
      var response = await Dio().get(widget.ImageUrl, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
      print(result);
      Navigator.pop(context);
    }

    _askPermission() async {

        /* PermissionStatus permission = */await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage);
      }


}



