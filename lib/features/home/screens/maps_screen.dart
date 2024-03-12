import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:open_route_service/open_route_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.location});
  final List<double> location;
  @override
  State<MapScreen> createState() => _MapViewState();
}

class _MapViewState extends State<MapScreen> {
  final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf62488949a2cc67b0445da3975afeaca9813e',
      defaultProfile: ORSProfile.drivingCar);

  double endLat = 28.612157;
  double endLng = 77.047718;

  MapController controller = MapController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    route();
    // getCurrentLocation();
    // setState(() {
    //     controller=  getCurrentLocation(context, controller);

    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Container(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(widget.location[0], widget.location[1]),
                initialZoom: 18,
              ),
              mapController: controller,
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(20, 78),
                      width: 80,
                      height: 80,
                      child: FlutterLogo(),
                    ),
                  ],
                ),
                FutureBuilder(
                    future: route(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // Checking if future is resolved

                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: TextStyle(fontSize: 18),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object

                          return Center(
                            child: PolylineLayer(
                              polylines: [snapshot.data],
                            ),
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                      return CircularProgressIndicator();
                    }),
                // MarkerLayer(markers: [
                //      Marker(
                //        point: _center,
                //        builder: (ctx) => Container(
                //          child: Icon(
                //            Icons.account_circle,
                //            color: Colors.red.shade900,
                //          ),
                //        ),
                //      ),
                //    ],)
                // RichAttributionWidget(
                //   attributions: [
                //     TextSourceAttribution(
                //       'OpenStreetMap contributors',
                //       onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Future<Polyline> route() async {
    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: widget.location[0], longitude: widget.location[1]),
      endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
    );
    routeCoordinates.forEach(print);
    final List<LatLng> routePoints = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();
    // Create Polyline (requires Material UI for Color)
    final Polyline routePolyline = Polyline(
      strokeWidth: 10,
      points: routePoints,
      color: Colors.blue,
    );
    return routePolyline;
    // final manager = OSRMManager();
    // final road = await manager.getRoad(
    //   waypoints: waypoints,
    //   geometries: Geometries.polyline,
    //   steps: true,
    //   language: Languages.en,
    // );
    // setState(() {
    //   roads = road.polyline!.cast<LatLng>();
    // });
  }

  getCurrentLocation() async {
    Location location = Location();

    LocationData _locationData;

    _locationData = await location.getLocation();

    setState(() {
      //_center = LatLng(_locationData.latitude, _locationData.longitude);
      controller.move(
          LatLng(_locationData.latitude!, _locationData.longitude!), 13.0);
    });
  }

  Future<String> login() async {
    try {
      Response response = await get(
        Uri.parse(
            "https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62488949a2cc67b0445da3975afeaca9813e&start=8.681495,49.41461&end=8.687872,49.420318"),
        headers: {
          'Content-Type': "application/json",
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        print('Login successfully');
        return "Success";
      } else {
        print('failed');
        print(response.statusCode);
        return "Fail";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
