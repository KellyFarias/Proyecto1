import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MyGooglePage extends StatefulWidget {
  MyGooglePage({Key key,  muMunicipion}) : super(key: key);


   String title;
 String lati,long;

  @override
  _MyGooglePageState createState() => _MyGooglePageState();
}

class _MyGooglePageState extends State<MyGooglePage> {
  
    
  GoogleMapController _controller;

 CameraPosition _initialPosition = CameraPosition(target: LatLng(111.9,45.8));
    @override
  // TODO: implement widget
  
  final List<Marker> markers = [];
  addMarker(cordinate){

    int id = Random().nextInt(100);

    setState(() {
      markers.add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    Map latlong=ModalRoute.of(context).settings.arguments;
   // _initialPosition = CameraPosition(target: LatLng(double.parse(latlong[lati]), double.parse(latlong[lon])));
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        onMapCreated: (controller){
          setState(() {
            _controller = controller;
          });
        },
        markers: markers.toSet(),
        onTap: (cordinate){
          _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
          addMarker(cordinate);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _controller.animateCamera(CameraUpdate.zoomOut());
        },
        child: Icon(Icons.zoom_out),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}