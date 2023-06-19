import 'package:cloud_firestore/cloud_firestore.dart';

String timeFormat(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  return '$day/$month/$year';
}
