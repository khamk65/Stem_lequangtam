import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../themes/spacing.dart';
import '../widget/tab_air.dart';
import '../widget/tab_temperature.dart';
import '../widget/tab_wet.dart';


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
  Stream<QuerySnapshot> dataStreamAir = FirebaseFirestore.instance.collection('DataAir').snapshots();
  Stream<QuerySnapshot> dataStreamWet = FirebaseFirestore.instance.collection('DataAir').snapshots();
  Stream<QuerySnapshot> dataStreamTemperature = FirebaseFirestore.instance.collection('DataAir').snapshots();

  List<String> previousDocCO2 = [];
  List<String> previousDocCO = [];
  List<String> previousDocPM25 = [];
  List<String> previousDocDoAm = [];
  List<String> previousDocNhietDo = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(2);
  }

  static const List<Tab> _tabs = [
    Tab(icon: Icon(Icons.air), child: Text('Không khí')),
    Tab(icon: Icon(Icons.water_drop_outlined), text: 'Độ ẩm'),
    Tab(icon: Icon(Icons.thermostat), text: 'Nhiệt độ'),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: dataStreamAir,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> docCO2 = [];
                  List<String> docCO = [];
                  List<String> docPM25 = [];

                  for (QueryDocumentSnapshot document in snapshot.data!.docs) {
                    docCO2.add(document['CO2']);
                    docCO.add(document['CO']);
                    docPM25.add(document['bui']);
                  }

                  // Lưu trữ dữ liệu hiện tại để sử dụng khi không có dữ liệu mới
                  previousDocCO2 = docCO2;
                  previousDocCO = docCO;
                  previousDocPM25 = docPM25;

                  return wigetAir(docCO2: docCO2, docCO: docCO, docPM25: docPM25);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (previousDocCO2.isNotEmpty && previousDocCO.isNotEmpty && previousDocPM25.isNotEmpty) {
                    return wigetAir(docCO2: previousDocCO2, docCO: previousDocCO, docPM25: previousDocPM25);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              },
            ),
          ),
          Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: dataStreamWet,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> docDoAm = [];

                  for (QueryDocumentSnapshot document in snapshot.data!.docs) {
                    docDoAm.add(document['doam']);
                  }

                  // Lưu trữ dữ liệu hiện tại để sử dụng khi không có dữ liệu mới
                  previousDocDoAm = docDoAm;

                  return wigetWet(docDoAm: docDoAm);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (previousDocDoAm.isNotEmpty) {
                    return wigetWet(docDoAm: previousDocDoAm);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              },
            ),
          ),
          Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: dataStreamTemperature,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> docNhietDo = [];

                  for (QueryDocumentSnapshot document in snapshot.data!.docs) {
                    docNhietDo.add(document['nhietdo']);
                  }

                  // Lưu trữ dữ liệu hiện tại để sử dụng khi không có dữ liệu mới
                  previousDocNhietDo = docNhietDo;

                  return TabTemperature(docNhietDo: docNhietDo);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (previousDocNhietDo.isNotEmpty) {
                    return TabTemperature(docNhietDo: previousDocNhietDo);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

