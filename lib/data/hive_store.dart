import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:installments/models/installment_entry.dart';

class HiveStore {
  HiveStore._();
  static HiveStore _instance = HiveStore._();
  static HiveStore get instance => _instance;

  Box<InstallmentEntry> _installmentEntryBox;
  Box<InstallmentEntry> get installmentEntryBox => _installmentEntryBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(InstallmentEntryAdapter());
    _installmentEntryBox = await Hive.openBox<InstallmentEntry>('installment');
  }
}
