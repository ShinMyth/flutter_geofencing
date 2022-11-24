import 'package:geofencing/screens/geofencing_screen/geofencing_screen_view.dart';
import 'package:geofencing/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  void checkPermission() async {
    await LocationService().checkPermission();

    // Navigate to geofencing screen after 2.5 seconds
    Future.delayed(
      const Duration(milliseconds: 2500),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GeofencingScreenView(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 35.w,
          width: 35.w,
          child: Image.asset("assets/images/flutter-logo-with-label.png"),
        ),
      ),
    );
  }
}
