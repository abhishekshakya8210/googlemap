import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myCurrentLocation = LatLng(27.3826, 79.5970); 
  late GoogleMapController googleMapController;
  Set<Marker> marker = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map Example")),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('marker id'),
            position: myCurrentLocation,
            draggable: true,
            onDragEnd: (value) {},
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: 'Farrukhabad',
              snippet: 'This is Farrukhabad location',
            ),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          Position position = await currentPosition();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  zoom: 15,
                  target: LatLng(position.latitude, position.longitude)),
            ),
          );
          setState(() {
            marker.clear();
            marker.add(Marker(
              markerId: MarkerId('this is my location'),
              position: LatLng(position.latitude, position.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), 
            ));
          });
        },
        child: Icon(
          Icons.my_location,
          size: 30,
        ),
      ),
    );
  }

  Future<Position> currentPosition() async {
    bool serviceEnable;
    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('location service are deseble');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return Future.error('location permition denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
