import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../themes/spacing.dart';
import '../widget/tab_air.dart';
import '../widget/tab_temperature.dart';
import '../widget/tab_wet.dart';
import '../widget/controlWater.dart';
import '../widget/control.dart';
import '../widget/tab_gas.dart';
import '../widget/quat.dart';
class Air extends StatelessWidget {
  const Air({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabAir(),
    );
  }
}

class TabAir extends StatefulWidget {
  @override
  _TabAirState createState() => _TabAirState();
  
}

class _TabAirState extends State<TabAir> with TickerProviderStateMixin {
  late TabController _tabController;
   late DatabaseReference _databaseReference;
 final StreamController<Map<String, dynamic>> _dataStreamController =
      StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.animateTo(2);
    _databaseReference = FirebaseDatabase.instance.ref().child('chungcu/dulieudoc');
    _setupDataStream();
  }
   void _setupDataStream() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        final data = event.snapshot.value as Map<String, dynamic>;
        // Trích xuất các giá trị bạn cần và đưa chúng vào stream
        final co2 = data['co2'] as num;Color.fromARGB(255, 35, 167, 40);
        final bui = data['bui'] as num;
        final doam = data['doam'] as num;
        final gas = data['gas'] as num;
        final nhietdo = data['nhietdo'] as num;

        _dataStreamController.add({
          'co2': co2,
          'bui': bui,
          'doam': doam,
          'gas': gas,
          'nhietdo': nhietdo,
        });
      }
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }
void updateSensorStatus(String sensorName, int newValue) {
    DatabaseReference statusSensorReference = FirebaseDatabase.instance.ref().child('chungcu/statusSensor');
    statusSensorReference.update({sensorName: newValue});
  }
  void updatePumpStatus(bool isPumpOn) {
  DatabaseReference statusSensorReference = FirebaseDatabase.instance.ref().child('chungcu/statusSensor');
  statusSensorReference.update({'bom': isPumpOn ? 1 : 0});
}
  static const List<Tab> _tabs = [
    Tab(icon: Icon(Icons.air), child: Text('Không khí')),
    Tab(icon: Icon(Icons.water_drop_outlined), text: 'Độ ẩm'),
    Tab(icon: Icon(Icons.thermostat), text: 'Nhiệt độ'),
    Tab(icon: Icon(Icons.grain_sharp), text: 'gas'),
    Tab(icon: Icon(Icons.plumbing), text: 'Quản lý bơm'),
    Tab(icon: Icon(Icons.heat_pump), text: 'Quản lý quạt'),
    Tab(icon: Icon(Icons.control_point), text: 'control'),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          labelColor: Color.fromARGB(255, 13, 99, 197),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
          overlayColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue;
            }
            if (states.contains(MaterialState.focused)) {
              return Colors.orange;
            } else if (states.contains(MaterialState.hovered)) {
              return Colors.pinkAccent;
            }

            return Colors.transparent;
          }),
          indicatorWeight: 10,
          indicatorColor: Colors.red,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(5),
          indicator: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
            color: Colors.pinkAccent,
          ),
          isScrollable: true,
          physics: BouncingScrollPhysics(),
          onTap: (int index) {
            print('Tab $index is tapped');
          },
          enableFeedback: true,
          controller: _tabController,
          tabs: _tabs,
        ),
        title: const Text(
          '\t\t\t\t\t\t\t\t\t\tChúc bạn một ngày tốt lành',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
 Center(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _dataStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final co2 = data['co2'] as num;
                  final bui = data['bui'] as num;
                  // Truyền giá trị co2 và bui vào widget tương ứng
                  return wigetAir(docCO2: co2, docPM25: bui);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),


      Center(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _dataStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final doam = data['doam'] as num;
                  // Truyền giá trị độ ẩm vào widget tương ứng
                  return WetWidget(doam: doam);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Center(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: _dataStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final nhietdo = data['nhietdo'] as num;
                  // Truyền giá trị nhiệt độ vào widget tương ứng
                  return TabTemperature(docNhietDo: nhietdo);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
           Center(
            child:  GasScreen()               
          ),
           Center(
      child: WaterPumpControlScreen(
        updatePumpStatusCallback: updatePumpStatus,
      ),
    ),
        
          Center(
            child:  Quat( updateQuatStatusCallback: updatePumpStatus,)
                
            ),
         
         Center(
            child: SensorControlScreen(
              updateSensorStatusCallback: updateSensorStatus,
            ),
          ),

        ],
      ),
    );
  }
}