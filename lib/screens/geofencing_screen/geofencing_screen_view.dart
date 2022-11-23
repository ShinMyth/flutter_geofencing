import 'dart:developer';
import 'package:geofencing/services/geofencing_service.dart';
import 'package:geofencing/services/location_service.dart' as location_service;
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofencingScreenView extends StatefulWidget {
  const GeofencingScreenView({Key? key}) : super(key: key);

  @override
  State<GeofencingScreenView> createState() => _GeofencingScreenViewState();
}

class _GeofencingScreenViewState extends State<GeofencingScreenView> {
  late GoogleMapController mapController;

  @override
  void initState() {
    GeofencingService().setEmployeeLocation(
      employeeLocationInput: location_service.employeeLocation,
      setState: setState,
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng eventLatLng) {
    GeofencingService().setEmployeeLocation(
      employeeLocationInput: eventLatLng,
      setState: setState,
    );

    animateCamera();
  }

  void animateCamera() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: employeeLocation,
          zoom: 19,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Geofencing"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 2.h),
          Container(
            height: 30.h,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: employeeLocation,
                  zoom: 19,
                ),
                onMapCreated: _onMapCreated,
                compassEnabled: false,
                mapToolbarEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                markers: markers,
                polygons: polygons,
                onTap: _onTap,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:
                      isWithinOfficePolygonPoints ? () => log("Clockin") : null,
                  child: const Text("Clockin"),
                ),
                ElevatedButton(
                  onPressed: isWithinOfficePolygonPoints
                      ? () => log("Clockout")
                      : null,
                  child: const Text("Clockout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
