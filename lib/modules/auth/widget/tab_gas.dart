import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GasScreen extends StatefulWidget {
  @override
  _GasScreenState createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> {
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('chungcu/dulieudoc');
  late double gasValue;
  List<FlSpot> gasData = []; // Danh sách chứa dữ liệu khí gas

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  void _setupStream() {
    _databaseReference.child('khigas').onValue.listen((event) {
      final dynamic data = event.snapshot.value;

      if (data != null) {
        setState(() {
          gasValue = data.toDouble();
         

          // Thêm dữ liệu mới vào danh sách và giới hạn số lượng điểm
          gasData.add(FlSpot(gasData.length.toDouble(), gasValue));
          if (gasData.length > 10) {
            gasData.removeAt(0);
          }
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đo nồng độ khí gas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nồng độ khí gas: ${gasValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 300,
              width: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: 100,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: gasData, // Sử dụng danh sách dữ liệu khí gas
                      isCurved: true,
                      colors: [Colors.blue],
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý cập nhật giá trị khí gas ở đây (nếu cần)
              },
              child: Text('Cập nhật giá trị khí gas'),
            ),
          ],
        ),
      ),
    );
  }
}
