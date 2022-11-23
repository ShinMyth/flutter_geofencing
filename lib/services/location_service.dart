import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late LatLng employeeLocation;

class LocationService {
  Future<void> checkLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    employeeLocation = LatLng(position.latitude, position.longitude);
    log("$employeeLocation");
  }
}
