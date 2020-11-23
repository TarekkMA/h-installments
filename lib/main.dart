import 'package:flutter/material.dart';
import 'package:installments/data/hive_store.dart';

import 'package:installments/ui/app.dart';

void main() async {
  await HiveStore.instance.init();
  runApp(App());
}
