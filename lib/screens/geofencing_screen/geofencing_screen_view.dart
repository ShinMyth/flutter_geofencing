import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geofencing/services/geofencing_service.dart';
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
    GeofencingService().setOfficeLocation(
      officeLocationInput: const LatLng(8.4947423765367, 124.65163452218286),
    );

    GeofencingService().setEmployeeLocation(
      employeeLocationInput: const LatLng(8.49410576576839, 124.65198261053683),
      setState: setState,
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void animateCamera() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: employeeLocation,
          zoom: 18,
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
                  zoom: 18,
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
                // circles: circles,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    GeofencingService().setEmployeeLocation(
                      employeeLocationInput:
                          const LatLng(8.49410576576839, 124.65198261053683),
                      setState: setState,
                    );

                    animateCamera();
                  },
                  child: const Text("Employee Position 1"),
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () {
                    GeofencingService().setEmployeeLocation(
                      employeeLocationInput:
                          const LatLng(8.494335959114938, 124.65196120856947),
                      setState: setState,
                    );

                    animateCamera();
                  },
                  child: const Text("Employee Position 2"),
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () {
                    GeofencingService().setEmployeeLocation(
                      employeeLocationInput:
                          const LatLng(8.49448677537054, 124.6517605651253),
                      setState: setState,
                    );

                    animateCamera();
                  },
                  child: const Text("Employee Position 3"),
                ),
                SizedBox(height: 1.h),
                ElevatedButton(
                  onPressed: () {
                    GeofencingService().setEmployeeLocation(
                      employeeLocationInput:
                          const LatLng(8.49471432259134, 124.6516883334854),
                      setState: setState,
                    );

                    animateCamera();
                  },
                  child: const Text("Employee Position 4"),
                ),
              ],
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
