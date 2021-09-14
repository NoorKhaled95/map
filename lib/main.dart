import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primaryColor: Colors.lightBlue[700],
      accentColor: Colors.cyan[400],

      // Define the default font family.
      fontFamily: 'Georgia',

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController googleMapController;

  LatLng centerPoint = LatLng(25.276987, 55.296249);

  LatLng shopPoint = LatLng(25.276987, 55.296249);
  Set<Marker> markers = {};

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 20)));
    markers.add(Marker(
        markerId: MarkerId('MyLocation'),
        position: LatLng(position.latitude, position.longitude)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        onTap: (x) {
          print(x);
          markers.add(Marker(
              markerId: MarkerId('${x.latitude}_${x.longitude}'), position: x));
          setState(() {});
        },
        markers: markers,
        onMapCreated: (controller) {
          this.googleMapController = controller;
          getUserLocation();
        },
        initialCameraPosition: CameraPosition(
          target: centerPoint,
          zoom: 11.0,
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 32),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          FloatingActionButton(
            child: Icon(
              Icons.location_searching,
              color: Colors.white,
            ),
            onPressed: () async {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=31.519161296212705,34.44142755120993';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              // if (await canLaunch('https://wa.me/+972599540404')) {
              //   launch('https://wa.me/+972599540404');
              // }
            },
          ),
        ]),
      ),
    );
  }
}
