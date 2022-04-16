import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'model/fligt_map_model.dart';
import 'service/google_firebase_service.dart';
import 'view/google_maps.dart';

abstract class GoogleMapsViewModel extends State<GoogleMaps> {
  final GoogleFirebaseService _firebaseService = GoogleFirebaseService();
  // Add your state and logic here
  GoogleMapController? controller;
  BitmapDescriptor? dogIcon;

  List<FlightMap> flightList = [];

  final CameraPosition kLake = const CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 10,
  );

  void navigateToRoot(int index) {
    controller!.animateCamera(CameraUpdate.newLatLng(flightList[index].latLong));
  }

  double pageWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double pageHeight(BuildContext context) => MediaQuery.of(context).size.height;

  Future initMapItemList() async {
    final response = await _firebaseService.initMapItemLists();

    if (response is List<FlightMap>) {
      setState(() {
        flightList = response;
      });
      controller!.animateCamera(CameraUpdate.newLatLng(flightList.first.latLong));
    }
  }
}
