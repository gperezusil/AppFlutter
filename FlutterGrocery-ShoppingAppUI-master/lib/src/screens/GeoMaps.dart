import 'package:flutter/rendering.dart';
import 'package:fryo/src/api/apiCalls.dart';
import 'package:fryo/src/models/country.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoMaps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CourseListState();
}

class CourseListState extends State<GeoMaps> {
  PermissionStatus _status;
  String buscarDireccion;
  GoogleMapController mapController;
  final ApiCalls apiCalls = ApiCalls();

  @override
  void initState() {
    super.initState();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);
    //_askPermission();
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _askPermission() {
    PermissionHandler().requestPermissions(
        [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.locationWhenInUse];
    if (status != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapa(),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigateToDetail(Course('', 1, 4, ''));
        },
        tooltip: "Add new Course",
        child: new Icon(Icons.add),
      ),*/
    );
  }

  Stack mapa() {
    return Stack(
      children: <Widget>[
        FutureBuilder<List<Country>>(
           future: apiCalls.getCountries(),
            builder: (BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
               if(!snapshot.hasData){
                return CircularProgressIndicator();
              }else {
        return GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
              target: LatLng(-12.0431800,-77.0282400), zoom: 5.0),
                  markers: {
                  for (Country country in snapshot.data)
                    if (country.latlng.length > 0)
                      Marker(
                        markerId: MarkerId(country.name),
                        /*onTap: () {
                          setState(() {
                            details.clear();
                            _bottomSize = _screenHeight * .5;
                          });
                        },*/
                        position: LatLng(
                          country.latlng[0],
                          country.latlng[1],
                        ),
                      ),
                },
                myLocationButtonEnabled: false,
        );}}
        ),
        Positioned(
          top: 10.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.white),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Ingrese Establecimiento',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: barraBusqueda,
                      iconSize: 30.0,
                      padding: EdgeInsets.only(bottom: 5.0),
                    ), onPressed: () {},
                  )
                  ),
              onChanged: (val) {
                setState(() {
                  buscarDireccion = val;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  

  barraBusqueda() {
    prefix0.Geolocator().placemarkFromAddress(buscarDireccion).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
