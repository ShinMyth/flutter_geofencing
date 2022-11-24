import 'package:geofencing/services/geofencing_service.dart';
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
        employeeLocationInput:
            const LatLng(8.494248946505653, 124.65202668111144));
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTap(LatLng eventLatLng) {
    setState(() {
      GeofencingService()
          .setEmployeeLocation(employeeLocationInput: eventLatLng);

      animateCamera();
    });
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
                onTap: _onMapTap,
                compassEnabled: false,
                mapToolbarEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                markers: mapMarkers,
                polygons: mapPolygons,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employee Latitude: ${employeeLocation.latitude}",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Employee Longitude: ${employeeLocation.longitude}",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Contain Location: $isContainsLocation",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
