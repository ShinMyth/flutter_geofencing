import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

late LatLng employeeLocation;

late BitmapDescriptor employeeLocationMarker;

const List<LatLng> officePolygonPoints = <LatLng>[
  LatLng(8.494447689033173, 124.65176473964237),
  LatLng(8.49468975564717, 124.65185459364372),
  LatLng(8.494777297507396, 124.65161520650037),
  LatLng(8.49471164111411, 124.65159173717258),
  LatLng(8.494664554198868, 124.65171981264706),
  LatLng(8.494488807209033, 124.65165611018516),
  LatLng(8.494447689033173, 124.65176473964237),
];

Set<Marker> markers = {};

Set<Polygon> polygons = {};

bool isWithinOfficePolygonPoints = false;

class GeofencingService {
  void setEmployeeLocation({
    required LatLng employeeLocationInput,
    required Function setState,
  }) {
    employeeLocation = employeeLocationInput;

    setMarkerIcons(setState: setState);
  }

  void setMarkerIcons({required Function setState}) async {
    employeeLocationMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      Platform.isAndroid
          ? 'assets/images/employee-marker-android.png'
          : 'assets/images/employee-marker-ios.png',
    );

    generateMarkers(setState: setState);
  }

  void generateMarkers({required Function setState}) {
    markers = {
      Marker(
        markerId: const MarkerId("employee"),
        icon: employeeLocationMarker,
        position: employeeLocation,
      ),
    };

    generatePolygons(setState: setState);
  }

  void generatePolygons({required Function setState}) {
    containsLocation();

    polygons = {
      Polygon(
        polygonId: const PolygonId('office'),
        points: officePolygonPoints,
        fillColor: isWithinOfficePolygonPoints
            ? Colors.green.withOpacity(0.275)
            : Colors.black.withOpacity(0.35),
        strokeColor: isWithinOfficePolygonPoints
            ? const Color(0xFF41495C)
            : const Color(0xFFF56F6C),
        strokeWidth: 1,
        geodesic: true,
      ),
    };

    setState(() {});
  }

  void containsLocation() {
    maps_toolkit.LatLng employeeLocationPoint = maps_toolkit.LatLng(
      employeeLocation.latitude,
      employeeLocation.longitude,
    );

    List<maps_toolkit.LatLng> officeLocationPolygonPoints =
        <maps_toolkit.LatLng>[];

    for (var element in officePolygonPoints) {
      officeLocationPolygonPoints
          .add(maps_toolkit.LatLng(element.latitude, element.longitude));
    }

    isWithinOfficePolygonPoints = maps_toolkit.PolygonUtil.containsLocation(
      employeeLocationPoint,
      officeLocationPolygonPoints,
      true,
    );

    log("Contains Location: $isWithinOfficePolygonPoints");
    log("Is Within Office Polygon Points: $isWithinOfficePolygonPoints");
  }
}
