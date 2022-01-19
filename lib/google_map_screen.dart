import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_google_map_project/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  bool isIdle = true;
  late GoogleMapController _mapController;
  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: LatLng(12.9683, 77.6019), zoom: 15.0);

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<LocationProvider>(context, listen: false)
          .handleLocationPermission();
    });
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width * mq.devicePixelRatio;
    final height = mq.size.height * mq.devicePixelRatio;

    var x = width / 2;
    var y = height / 3.5;

    return Consumer<LocationProvider>(
      builder: (_, provider, child) {
        final permissionGranted = provider.permissionGranted;
        final _address = provider.address;
        return permissionGranted != null && permissionGranted
            ? Stack(
                children: [
                  SizedBox(
                    height: mq.size.height,
                    width: mq.size.width,
                    child: GoogleMap(
                      // mapType: MapType.normal,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      onCameraMove: (position) {
                        if (!provider.isCameraMoving) {
                          provider.cameraMoving(true);
                        }
                      },
                      onCameraIdle: () async {
                        provider.fetchLocationData(_mapController,
                            ScreenCoordinate(x: x.round(), y: y.round()));
                      },
                      markers: {
                        Marker(
                            markerId: const MarkerId("chosen_location"),
                            position: provider.latLng ?? const LatLng(12.9683, 77.6019))
                      },
                    ),
                  ),
                  if (!provider.isCameraMoving)
                    Positioned(
                        top: ((mq.size.height) / 3.5) - 10,
                        left: (mq.size.width / 2) - 10,
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.50),
                              borderRadius: BorderRadius.circular(20.0)),
                          transform: Matrix4.rotationX(1.0),
                        )),
                  Positioned(
                      top: ((mq.size.height) / 3.5) - 50,
                      left: (mq.size.width / 2) - 25,
                      child: const Icon(
                        Icons.location_pin,
                        size: 50,
                        color: Colors.deepOrange,
                      )),
                  DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    maxChildSize: 0.50,
                    minChildSize: 0.3,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Material(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20.0)),
                        color: Colors.black,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: provider.isCameraMoving
                                ? const SizedBox(
                                    height: 320.0,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _tile(
                                            label: "Street",
                                            value: _address?.street ?? ""),
                                        _tile(
                                            label: "City",
                                            value: _address?.city ?? ""),
                                        _tile(
                                            label: "District",
                                            value: _address?.district ?? ""),
                                        _tile(
                                            label: "State",
                                            value: _address?.state ?? ""),
                                        _tile(
                                            label: "Postal Code",
                                            value: _address?.zipcode ?? ""),
                                        _tile(
                                            label: "Latitude",
                                            value: "${_address?.geo?.lat}"),
                                        _tile(
                                            label: "Longitude",
                                            value: "${_address?.geo?.lng}"),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            : Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        permissionGranted == null ? "Permission Not Granted!!" : "You denied for permission!!",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                          onPressed: provider.requestPermission,
                          child: const Text("Grant Permission"))
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _tile({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.place_outlined,
                color: Colors.white70,
              ),
              const SizedBox(
                height: 1.0,
              ),
              Container(
                width: 2.0,
                height: 25.0,
                color: Colors.white70,
              )
            ],
          ),
          const SizedBox(
            width: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                    ),
              ),
              Text(
                ":",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          )
        ],
      ),
    );
  }
}
