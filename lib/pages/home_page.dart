import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentAdress = 'My Addrees';
  Position? currentPosition;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please Keep your location on.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location Permissio is denied ');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Permission is dined forever');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        currentPosition = position;
        currentAdress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  final newVersion = NewVersion(
    androidId: 'com.duolingo',
  );

  Future<void> _version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    print(version);
    print(code);
  }

  Future<void> neewVer() async {
    final status = await newVersion.getVersionStatus();
    String ver = status!.storeVersion;
    print(ver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              currentAdress,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          currentAdress.isEmpty
              ? Text('Latitude = ' + currentPosition!.latitude.toString())
              : Text('salom'),
          currentPosition != null
              ? Text('Longitude = ' + currentPosition!.longitude.toString())
              : Text('sa'),
          Container(
            margin: const EdgeInsets.all(20),
            child: MaterialButton(
              color: Colors.blue,
              onPressed: () {
                _version();
                neewVer();
                _determinePosition();
                // print(getCountryName());
              },
              child: const Text('salom'),
            ),
          ),
        ],
      ),
    );
  }
}
