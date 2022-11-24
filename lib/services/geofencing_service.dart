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

Set<Marker> mapMarkers = {};
Set<Polygon> mapPolygons = {};

bool isContainsLocation = false;

class GeofencingService {
  void setEmployeeLocation({required LatLng employeeLocationInput}) {
    employeeLocation = employeeLocationInput;

    setMarkerIcons();
  }

  void setMarkerIcons() async {
    employeeLocationMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      Platform.isAndroid
          ? 'assets/images/employee-marker-android.png'
          : 'assets/images/employee-marker-ios.png',
    );

    generateMapMarkers();
  }

  void generateMapMarkers() {
    mapMarkers = {
      Marker(
        markerId: const MarkerId("employee"),
        icon: employeeLocationMarker,
        position: employeeLocation,
      ),
    };

    generateMapPolygons();
  }

  void generateMapPolygons() {
    containsLocation();

    mapPolygons = {
      Polygon(
        polygonId: const PolygonId('office'),
        points: officePolygonPoints,
        fillColor: isContainsLocation
            ? const Color(0xFF00FF00).withOpacity(0.275)
            : const Color(0xFF000000).withOpacity(0.35),
        strokeColor: isContainsLocation
            ? const Color(0xFF41495C)
            : const Color(0xFFF56F6C),
        strokeWidth: 1,
        geodesic: true,
      ),
    };
  }

  void containsLocation() {
    maps_toolkit.LatLng redeclaredEmployeeLocation = maps_toolkit.LatLng(
      employeeLocation.latitude,
      employeeLocation.longitude,
    );

    List<maps_toolkit.LatLng> redeclaredOfficePolygonPoints =
        <maps_toolkit.LatLng>[];

    for (LatLng point in officePolygonPoints) {
      redeclaredOfficePolygonPoints
          .add(maps_toolkit.LatLng(point.latitude, point.longitude));
    }

    isContainsLocation = maps_toolkit.PolygonUtil.containsLocation(
      redeclaredEmployeeLocation,
      redeclaredOfficePolygonPoints,
      true,
    );
  }
}
