// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class databtl {
   String CO2="2090";
   String CO="222";
   String PM25="33";
   String doam="22";
   String nhietdo="333";
  databtl({
    required this.CO2,
    required this.CO,
    required this.PM25,
    required this.doam,
    required this.nhietdo,
  });
 


  databtl copyWith({
    String? CO2,
    String? CO,
    String? PM25,
    String? doam,
    String? nhietdo,
  }) {
    return databtl(
      CO2: CO2 ?? this.CO2,
      CO: CO ?? this.CO,
      PM25: PM25 ?? this.PM25,
      doam: doam ?? this.doam,
      nhietdo: nhietdo ?? this.nhietdo,
    );
  }

  factory databtl.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data=snapshot.data();
    return databtl(
      CO2: data?['CO2'],
      CO:data?['CO'],
      PM25:data?['PM25'],
      doam:data?['doam'],
      nhietdo:data?['nhietdo'],
      
      );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (CO2 != null) "CO2": CO2,
      if (CO != null) "CO": CO,
      if (PM25 != null) "PM25":PM25,
      if (doam != null) "doam": doam,
      if (nhietdo != null) "nhietdo": nhietdo,
    
    };
  }
}
