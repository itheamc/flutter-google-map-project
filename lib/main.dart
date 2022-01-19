import 'package:flutter/material.dart';
import 'package:flutter_google_map_project/location_provider.dart';
import 'package:provider/provider.dart';

import 'google_map_screen.dart';

void main() {
  runApp(const GoogleMapApp());
}

class GoogleMapApp extends StatelessWidget {
  const GoogleMapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider())
      ],
      child: const MaterialApp(
        title: "Google Map App",
        home: GoogleMapScreen(),
      ),
    );
  }
}
