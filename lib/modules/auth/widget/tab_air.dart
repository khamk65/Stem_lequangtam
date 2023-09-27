import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../themes/spacing.dart';

class wigetAir extends StatelessWidget {
  wigetAir({Key? key, required this.docCO2,  required this.docPM25, DateTime? lastUpdateTime}) : super(key: key);

  final List<String> docCO2;
  
  final List<String> docPM25;

  double? calculateAQIFromPM25(double pm25, double conversionFactor) {
    double? aqi;

    // Define the representative values of concentration levels and corresponding AQI
    double i_lo = 0;
    double i_hi = 50;
    double c_lo = 0;
    double c_hi = 12;

    // Convert PM2.5 concentration from ppm to μg/m³
    double concentration = pm25 * conversionFactor/1000;

    // Calculate AQI using the formula
    aqi = ((i_hi - i_lo) / (c_hi - c_lo)) * (concentration - c_lo) + i_lo;

    return aqi;
  }

  @override
  Widget build(BuildContext context) {
    double conversionFactor = 25; // Conversion factor from ppm to μg/m³

    double pm25 = double.tryParse(docPM25.first) ?? 0; // Get the first PM2.5 concentration value

    double? aqi = calculateAQIFromPM25(pm25, conversionFactor); // Calculate AQI

    return Column(
      children: [
        Container(
          width: 400,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(24, 153, 71, 1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                alignment: Alignment.center,
                width: 400,
                height: 77,
                child: Text(
                  '\t\t\t\t\t\t\t\t\tBách Khoa\n Hai Bà Trưng, Hà Nội',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                color: Color.fromRGBO(28, 190, 87, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('US AQI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        Text( aqi != null ? aqi.toStringAsFixed(1) : ''),
                      ],
                    ),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/like.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'good!',
                      style: TextStyle(color: Color.fromARGB(255, 226, 175, 8), fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    Spacing.h12,
                    Text(''),
                    Spacing.h12,
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text('CO2(ug/m^3)', style: TextStyle(color: Colors.blue)),
                              Text(docCO2.isNotEmpty ? docCO2.first : ''),
                            ],
                          ),
                          Column(
                            children: [
                              Text('bụi(ppm)', style: TextStyle(color: Colors.blue)),
                              Text(docPM25.isNotEmpty ? docPM25.first : ''),
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     Text('CO(ug/m^3)', style: TextStyle(color: Colors.blue)),
                          //     Text(docCO.isNotEmpty ? docCO.first : ''),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacing.h4,
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 500,
              interval: 50,
              ranges: <GaugeRange>[
                GaugeRange(startValue: 0, endValue: 50, color: Color.fromRGBO(0, 230, 0, 1)),
                GaugeRange(startValue: 50, endValue: 100, color: Color.fromRGBO(255, 251, 0, 1)),
                GaugeRange(startValue: 100, endValue: 150, color: Color.fromRGBO(255, 126, 1, 1)),
                GaugeRange(startValue: 150, endValue: 200, color: Color.fromRGBO(254, 37, 1, 1)),
                GaugeRange(startValue: 200, endValue: 300, color: Color.fromRGBO(156, 22, 77, 1)),
                GaugeRange(startValue: 300, endValue: 500, color: Color.fromRGBO(128, 14, 30, 1)),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(value: aqi ?? 0, enableAnimation: true),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(
                    aqi != null ? aqi.toStringAsFixed(1) : '',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  positionFactor: 0.5,
                  angle: 90,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Công tơ đo chỉ số AQI',
              style: TextStyle(color: Color.fromARGB(255, 128, 97, 4), fontSize: 18, fontWeight: FontWeight.w700),
            ),
            FloatingActionButton(
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}