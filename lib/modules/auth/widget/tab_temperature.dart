import 'package:app2/themes/spacing.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TabTemperature extends StatelessWidget {
  final List<num> docNhietDo;

  const TabTemperature({Key? key, required this.docNhietDo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num temperature = docNhietDo.isNotEmpty ? docNhietDo.first : 0.0;

    return Column(
      children: [
        Spacing.h24,
        SfLinearGauge(
          labelFormatterCallback: (label) {
            if (label == 0) {
              return 'Start';
            }
            if (label == 15) {
              return 'Cold';
            }
            if (label == 25) {
              return 'Cool';
            }
            if (label == 35) {
              return 'High';
            }
            if (label == 50) {
              return 'Very High';
            }
            return label.toString();
          },
          minimum: 0,
          maximum: 50,
          axisTrackStyle: LinearAxisTrackStyle(
            thickness: 20,
            edgeStyle: LinearEdgeStyle.bothCurve,
          ),
          markerPointers: [
            LinearShapePointer(
              shapeType: LinearShapePointerType.diamond,
              height: 25,
              width: 25,
              value: temperature.toDouble(),
            )
          ],
          orientation: LinearGaugeOrientation.vertical,
          ranges: <LinearGaugeRange>[
            LinearGaugeRange(startValue: 0, endValue: 15, color: Colors.green),
            LinearGaugeRange(startValue: 15, endValue: 25, color: Colors.blue),
            LinearGaugeRange(startValue: 25, endValue: 35, color: Colors.orange),
            LinearGaugeRange(startValue: 35, endValue: 50, color: Colors.red),
          ],
        ),
        Spacing.h16,
        Text(
          'Nhiệt kế',
          style: TextStyle(
            color: Color.fromARGB(255, 128, 97, 4),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text('Temperature: $temperature'),
      ],
    );
  }
}
