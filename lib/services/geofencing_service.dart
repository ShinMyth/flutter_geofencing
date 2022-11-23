import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

late LatLng employeeLocation;
late LatLng officeLocation;

late BitmapDescriptor employeeLocationMarker;
late BitmapDescriptor officeLocationMarker;

Set<Marker> markers = {};

Set<Polygon> polygons = {};

bool isWithinOfficePolygonPoints = false;

class GeofencingService {
  void setOfficeLocation({required LatLng officeLocationInput}) {
    officeLocation = officeLocationInput;
  }

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

    officeLocationMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      Platform.isAndroid
          ? 'assets/images/office-marker-android.png'
          : 'assets/images/office-marker-ios.png',
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
      Marker(
        markerId: const MarkerId("office"),
        icon: officeLocationMarker,
        position: officeLocation,
      ),
    };

    generatePolygons(setState: setState);
  }

  void generatePolygons({required Function setState}) {
    containsLocation();

    polygons = {
      Polygon(
        polygonId: const PolygonId('office'),
        points: const <LatLng>[
          LatLng(8.49448800611957, 124.65165587107256),
          LatLng(8.494448214337387, 124.65176517108745),
          LatLng(8.494688291360507, 124.6518543545352),
          LatLng(8.49477583322106, 124.65161630849047),
          LatLng(8.494709513631568, 124.6515921686099),
          LatLng(8.494663753108133, 124.65172024408746),
          LatLng(8.49448800611957, 124.65165587107256),
        ],
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
        <maps_toolkit.LatLng>[
      maps_toolkit.LatLng(8.49448800611957, 124.65165587107256),
      maps_toolkit.LatLng(8.494448214337387, 124.65176517108745),
      maps_toolkit.LatLng(8.494688291360507, 124.6518543545352),
      maps_toolkit.LatLng(8.49477583322106, 124.65161630849047),
      maps_toolkit.LatLng(8.494709513631568, 124.6515921686099),
      maps_toolkit.LatLng(8.494663753108133, 124.65172024408746),
      maps_toolkit.LatLng(8.49448800611957, 124.65165587107256),
    ];

    isWithinOfficePolygonPoints = maps_toolkit.PolygonUtil.containsLocation(
      employeeLocationPoint,
      officeLocationPolygonPoints,
      true,
    );

    log("Contains Location: $isWithinOfficePolygonPoints");
    log("Is Within Office Polygon Points: $isWithinOfficePolygonPoints");
  }
}
