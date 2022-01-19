import 'package:geolocator/geolocator.dart';

class LocationServices {
  late GeolocatorPlatform _geolocatorPlatform;

  // Constructor
  LocationServices() {
    _geolocatorPlatform = GeolocatorPlatform.instance;
  }

  // Function to check location service is enabled or not
  Future<bool> isEnabled() async {
    return await _geolocatorPlatform.isLocationServiceEnabled();
  }


  // Function to handle permission
  // Only if location service is enabled
  Future<LocationPermission> hasPermission() async {
    return await _geolocatorPlatform.checkPermission();
  }

  // Function to request permission
  Future<LocationPermission> requestPermission() async {
    return await _geolocatorPlatform.requestPermission();
  }

  // Function to get the current location
  Future<Position?> getCurrentPosition() async {
    return await _geolocatorPlatform.getCurrentPosition();
  }

  // Function to get last Known position
  Future<Position?> getLastKnownPosition() async {
   return await _geolocatorPlatform.getLastKnownPosition();
  }

  // Function to get Accuracy
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    return await _geolocatorPlatform.getLocationAccuracy();
  }

  // Function to get open setting
  Future<bool> openAppSettings() async {
    return await _geolocatorPlatform.openAppSettings();
  }

  // Function to open location setting
  Future<bool> openLocationSettings() async {
    return await _geolocatorPlatform.openLocationSettings();
  }
}
