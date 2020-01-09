import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:system_info/system_info.dart';


class BatteryStats extends StatefulWidget {
  @override
  _BatteryStatsState createState() => _BatteryStatsState();
}

class _BatteryStatsState extends State<BatteryStats> {

  var batteryState;
  int batteryLevel;
  var phoneName;
  var processor;
  int megaByte = 1024 * 1024;

  Battery _battery = Battery();
  BatteryState _batteryState;
  StreamSubscription<BatteryState> _batteryStateSubscription;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
          setState(() {
            _batteryState = state;
            batteryState = _batteryState.toString().split(".")[1];
          });
        });
    getBattery();
    getPhone();
    hardwareDetails();
  }

  @override
  void dispose() {
    _batteryStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
//    getPhone();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Phone Details"),
        backgroundColor: Colors.green,
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Material(
            elevation: 10.0,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Text("Battery Status : $batteryState"),
//                  IconButton(
//                      icon: Icon(Icons.battery_std), onPressed: batteryStat),
                    Text("Battery Level : $batteryLevel%"),
                    Text("Phone Model : $phoneName"),
//                  IconButton(icon: Icon(Icons.phonelink_setup), onPressed: (){hardwareDetails();}),
                    Text("Kernel architecture        : ${SysInfo
                        .kernelArchitecture}"),
                    Text("Kernel name             : ${SysInfo.kernelName}"),
                    Text("Kernel version          : ${SysInfo.kernelVersion}"),
                    Text("Number of processors    : $processor"),
                    Text("Total physical memory   : ${SysInfo
                        .getTotalPhysicalMemory() ~/ megaByte} MB"),
                    Text("Free physical memory    : ${SysInfo
                        .getFreePhysicalMemory() ~/ megaByte} MB"),
                    Text("Total virtual memory    : ${SysInfo
                        .getTotalVirtualMemory() ~/ megaByte} MB"),
                    Text("Free virtual memory     : ${SysInfo
                        .getFreeVirtualMemory() ~/ megaByte} MB"),
//                Text("Virtual memory size     : ${SysInfo.getVirtualMemorySize() ~/ megaByte} MB"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void batteryStat() async {
    final int batteryLevel = await _battery.batteryLevel;
    showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
                content: Text("battery : $batteryLevel%"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ]));
  }

  void getBattery() async {
    batteryLevel = await _battery.batteryLevel;
  }

  void getPhone() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      phoneName = "${androidInfo.model}";

      print(androidInfo.type);
      print(androidInfo.board);
      print(androidInfo.androidId);
      print(androidInfo.bootloader);
      print(androidInfo.brand);
      print(androidInfo.device);
      print(androidInfo.display);
      print(androidInfo.fingerprint);
      print(androidInfo.hardware);
      print(androidInfo.version);
      print(androidInfo.host);
      print(androidInfo.tags);
      print(androidInfo.supportedAbis);
      print(androidInfo.supported32BitAbis);
      print(androidInfo.supported64BitAbis);
      print(androidInfo.product);
      print(androidInfo.id);
      print(androidInfo.isPhysicalDevice);
      print(androidInfo.manufacturer);
      print(androidInfo.model);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      phoneName = "${iosInfo.utsname.machine}";
    }
  }

  void hardwareDetails() {
    print("Kernel architecture     : ${SysInfo.kernelArchitecture}");
    print("Kernel name             : ${SysInfo.kernelName}");
    print("Kernel version          : ${SysInfo.kernelVersion}");
    var processors = SysInfo.processors;
    processor = "${processors.length}";
    print("Number of processors    : ${processors.length}");
    print("Total physical memory   : ${SysInfo.getTotalPhysicalMemory() ~/
        megaByte} MB");
    print("Free physical memory    : ${SysInfo.getFreePhysicalMemory() ~/
        megaByte} MB");
    print("Total virtual memory    : ${SysInfo.getTotalVirtualMemory() ~/
        megaByte} MB");
    print("Free virtual memory     : ${SysInfo.getFreeVirtualMemory() ~/
        megaByte} MB");
//    print("Virtual memory size     : ${SysInfo.getVirtualMemorySize() ~/ megaByte} MB");
  }

  Future<bool> _onBackPressed() {
    return showDialog(context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Do you really want to exit?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No", style: TextStyle(color: Colors.green),),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes", style: TextStyle(color: Colors.red),),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }


}