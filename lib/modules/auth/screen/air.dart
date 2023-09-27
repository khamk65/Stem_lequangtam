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


//  DatabaseReference _databaseReference1= FirebaseDatabase.instance.ref().child('chungcu/dulieudoc');
//  DatabaseReference _databaseReference2= FirebaseDatabase.instance.ref().child('chungcu/dulieudoc');
//  DatabaseReference _databaseReference3= FirebaseDatabase.instance.ref().child('chungcu/dulieudoc'); 

final StreamController<Map<String, dynamic>> _airStreamController = StreamController<Map<String, dynamic>>();
//   final StreamController<Map<String, dynamic>> _humidityStreamController = StreamController<Map<String, dynamic>>();
//   final StreamController<Map<String, dynamic>> _temperatureStreamController = StreamController<Map<String, dynamic>>();
  final StreamController<Map<String, dynamic>> _airStreamController1 = StreamController<Map<String, dynamic>>();
final StreamController<Map<String, dynamic>> _airStreamController2 = StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.animateTo(2);
_airStreamController = StreamController<Map<String, dynamic>>();
   


  }
@override
  void dispose() {
    // Giải phóng tài nguyên khi không cần thiết
    _airStreamController.close();
    
     _airStreamController1.close();
      _airStreamController2.close();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   // Hủy đăng ký lắng nghe và giải phóng tài nguyên khi widget bị xóa
  //   _databaseReference1.dispose();
  //   super.dispose();
  // }
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
// @override
//   void dispose() {
// print("1");
//     _databaseReference1.remove();
//         _databaseReference2.remove();
//             _databaseReference3.remove();
//     super.dispose();
//   }
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
  child: StreamBuilder(
    stream: _airStreamController.stream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
Map<dynamic, dynamic> data3 = snapshot.data as Map<dynamic, dynamic>;

        // Trích xuất dữ liệu từ Firebase Realtime Database ở đây và truyền vào widget tương ứng
        String co2 = data3['co2'];
       String bui=data3['bui'];

        // Biến co2 và bui thành danh sách
        List<String> co2List = [co2];
       List<String> buiList=[bui];

        return wigetAir(docCO2: co2List, docPM25: buiList);
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return CircularProgressIndicator();
      }
    },
  )
  ,
),


      Center(
  child: StreamBuilder(
    stream: _airStreamController1.stream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
Map<dynamic, dynamic> data2 = snapshot.data as Map<dynamic, dynamic>;

        // Trích xuất dữ liệu từ Firebase Realtime Database ở đây và truyền vào widget tương ứng
        String doam = data2['doam'];
       

        // Biến co2 và bui thành danh sách
        List<String> nhietdoList = [doam];
       

        return wigetWet(docDoAm: nhietdoList);
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return CircularProgressIndicator();
      }
    },
  ),
),


                Center(
  child: StreamBuilder(
    stream:_airStreamController2.stream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
Map<dynamic, dynamic> data1 = snapshot.data as Map<dynamic, dynamic>;

        // Trích xuất dữ liệu từ Firebase Realtime Database ở đây và truyền vào widget tương ứng
        String nhietdo = data1['nhietdo'];
       

        // Biến co2 và bui thành danh sách
        List<String> nhietdoList = [nhietdo];
       

        return TabTemperature(docNhietDo: nhietdoList);
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