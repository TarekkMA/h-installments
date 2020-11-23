import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'installment_entry.g.dart';

@HiveType(typeId: 1)
class InstallmentEntry {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String nationalId;
  @HiveField(3)
  final String mobile;
  @HiveField(4)
  final String item;
  @HiveField(5)
  final double totalPrice;
  @HiveField(6)
  final double initial;
  @HiveField(7)
  final int numberOfMonths;
  @HiveField(8)
  final double percentage;
  @HiveField(9)
  final String startDate;
  @HiveField(10)
  final bool isArchived;
  @HiveField(11)
  final double paied;

  InstallmentEntry({
    @required this.id,
    this.name,
    this.nationalId,
    this.mobile,
    this.item,
    this.totalPrice,
    this.initial,
    this.numberOfMonths,
    this.percentage,
    this.startDate,
    this.isArchived,
    this.paied,
  });

  double get total => (totalPrice - initial) * (1 + percentage);

  double get remaining => total - paied;

  double get costPerMonth => total / numberOfMonths;
}
