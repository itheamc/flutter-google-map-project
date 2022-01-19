import 'package:flutter/foundation.dart';
import 'package:flutter_google_map_project/geolocation_service.dart';
import 'package:flutter_google_map_project/models/Address.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  LocationServices? _locationServices;
  Address? address;
  LatLng? _latLng;
  bool _isCameraMoving = false;
  bool? locationEnabled;
  bool? permissionGranted;

  LatLng? get latLng => _latLng;

  bool get isCameraMoving => _isCameraMoving;

  // Constructor
  LocationProvider() {
    _locationServices = LocationServices();
  }

  // Check Location service enability
  Future<void> handleLocationStatus() async {
    final enabled = await _locationServices?.isEnabled();
    if (enabled != null) {
      locationEnabled = enabled;
      if (hasListeners) notifyListeners();
    }
  }

  // Open Location Setting
  Future<void> openLocationSetting() async {
    await _locationServices?.openLocationSettings();
  }

  // Check Location Permission
  Future<void> handleLocationPermission() async {
    LocationPermission permission = await _locationServices!.hasPermission();

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
    }
    if (hasListeners) notifyListeners();
  }

  Future<void> requestPermission() async {
    LocationPermission permission = await _locationServices!.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
    }
    if (hasListeners) notifyListeners();
  }

  // Function to get the current location
  Future<void> getCurrentPosition() async {
    final Position? position = await _locationServices?.getCurrentPosition();
    if (position != null) {
      _latLng = LatLng(position.latitude, position.longitude);
      if (hasListeners) notifyListeners();
    }
  }

  // Function to get last Known position
  void getLastKnownPosition() async {
    final position = await _locationServices?.getLastKnownPosition();
    if (position != null) {
      _latLng = LatLng(position.latitude, position.longitude);
      if (hasListeners) notifyListeners();
    }
  }

  // Latlng from the screen coordinate
  Future<void> fetchLocationData(GoogleMapController _controller,
      ScreenCoordinate _screenCoordinate) async {
    _latLng = await _controller.getLatLng(_screenCoordinate);
    if (hasListeners) notifyListeners();
    try {
      if (_latLng != null) {
        final placeMarks = await placemarkFromCoordinates(
            _latLng!.latitude, _latLng!.longitude);
        if (placeMarks.isNotEmpty) {
          final placemark = placeMarks[0];
          address = Address(
              id: 1,
              suite: placemark.name,
              street: placemark.street,
              city: placemark.locality,
              zipcode: placemark.postalCode,
              district: placemark.subAdministrativeArea,
              state: placemark.administrativeArea,
              geo: Geo(lat: _latLng?.latitude, lng: _latLng?.longitude),
              receiver: "John Doe",
              phone: "8569915572",
              addressType: "Home");
          cameraMoving(false);
        }
      }
    } on Exception catch (_, e) {
      cameraMoving(false);
    }
  }

  // Updating cameraMoving variable
  void cameraMoving(bool isMoving) {
    _isCameraMoving = isMoving;
    if (hasListeners) notifyListeners();
  }

  // FUnction to update latlng
  void updateLatLng(LatLng latLng) {
    _latLng = latLng;
    if (hasListeners) notifyListeners();
  }
}
