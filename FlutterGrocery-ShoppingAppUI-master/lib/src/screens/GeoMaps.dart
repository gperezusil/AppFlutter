
import 'dart:convert';
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

  @override
  void initState(){
    super.initState();
    PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse)
    .then(_updateStatus);
    _askPermission();
  }

  void _updateStatus(PermissionStatus status){
    if(status!=_status){
      setState(() {
       _status=status; 
      });
    }
  }

  void _askPermission(){
     PermissionHandler().requestPermissions(
       [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
  }

void _onStatusRequested(Map<PermissionGroup,PermissionStatus> statuses){
  final status = statuses[PermissionGroup.locationWhenInUse];
  if(status!=PermissionStatus.granted){
    PermissionHandler().openAppSettings();
  }else{
  _updateStatus(status);
  }

}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapa(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
         // navigateToDetail(Course('', 1, 4, ''));
        }
        ,
        tooltip: "Add new Course",
        child: new Icon(Icons.add),
      ),
    );
  }
  GoogleMap mapa(){
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(40.7128,74.0060),
        zoom: 15.0
      ),
    );
  
  }

  ListView courseListItems() {
    return ListView.builder(
      //itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
             // backgroundColor: getColor(this.courses[position].semester),
              //child:Text(this.courses[position].semester.toString()),
            ),
          //title: Text(this.courses[position].name),
          //subtitle: Text(this.courses[position].credits.toString()),
          onTap: () {
           // debugPrint("Tapped on " + this.courses[position].id.toString());
            //navigateToDetail(this.courses[position]);
          },
          ),
        );
      },
    );
  }
  
  




}
