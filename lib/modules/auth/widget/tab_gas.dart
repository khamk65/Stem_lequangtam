import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GasScreen extends StatelessWidget {
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
              'Nồng độ khí gas: 0.00',
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
                  maxX: 10,
                  minY: 0,
                  maxY: 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 0.2),
                        FlSpot(1, 0.5),
                        FlSpot(2, 0.8),
                        // Thêm các điểm dữ liệu thời gian và nồng độ khí gas ở đây
                      ],
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
