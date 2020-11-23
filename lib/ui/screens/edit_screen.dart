import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:installments/data/hive_store.dart';
import 'package:installments/models/installment_entry.dart';

import 'package:uuid/uuid.dart';

class PairFieldController<T> {
  final TextFormField field;
  final TextEditingController controller;
  final T Function(String) transformer;

  String get sValue => controller.text;
  T get tValue => transformer?.call(controller.text);

  PairFieldController(
    this.field,
    this.controller, {
    this.transformer,
  });
}

PairFieldController<T> useEditFormField<T>({
  String value,
  String hint,
  bool enabled = true,
  String Function(String value) validation,
  TextInputType textInputType,
  T Function(String) transformer,
}) {
  final controller = useTextEditingController(text: value);
  return PairFieldController<T>(
    TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: hint,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter value';
        }
        if (validation != null) {
          final res = validation(value);
          if (res != null) {
            return res;
          }
        }
        return null;
      },
    ),
    controller,
    transformer: transformer,
  );
}

class EditScreen extends HookWidget {
  final InstallmentEntry entry;
  final bool isNewEntry;

  const EditScreen({
    Key key,
    @required this.entry,
  })  : isNewEntry = false,
        super(key: key);

  const EditScreen.newEntry({
    Key key,
  })  : isNewEntry = true,
        entry = null,
        super(key: key);

  String _doubleValidation(String stringValue) {
    double value = double.tryParse(stringValue);
    if (value == null) return "Value must be a number";
    return null;
  }

  String _intValidation(String stringValue) {
    int value = int.tryParse(stringValue);
    if (value == null) return "Value must be a whole number";
    return null;
  }

  int _intTrans(String input) {
    return int.tryParse(input);
  }

  double _doubleTrans(String input) {
    return double.tryParse(input);
  }

  @override
  Widget build(BuildContext context) {
    final addMoneyController = useTextEditingController(text: "0");
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final namePair = useEditFormField(
      hint: "Name",
      value: isNewEntry ? "" : entry.name,
    );
    final natIdPair = useEditFormField(
      hint: "Natioal ID",
      value: isNewEntry ? "" : entry.nationalId,
    );
    final phonePair = useEditFormField(
      hint: "Phone",
      value: isNewEntry ? "" : entry.mobile,
    );
    final itemPair = useEditFormField(
      hint: "Item",
      value: isNewEntry ? "" : entry.item,
    );
    final itemPricePair = useEditFormField<double>(
      hint: "Item Price",
      value: isNewEntry ? "" : entry.totalPrice.toString(),
      validation: _doubleValidation,
      transformer: _doubleTrans,
    );
    final initialPair = useEditFormField<double>(
      hint: "Initial",
      value: isNewEntry ? "" : entry.initial.toString(),
      validation: _doubleValidation,
      transformer: _doubleTrans,
    );
    final paiedPair = useEditFormField<double>(
      hint: "Paied",
      value: isNewEntry ? "0" : entry.paied.toString(),
      enabled: isNewEntry ? false : true,
      validation: _doubleValidation,
      transformer: _doubleTrans,
    );
    final numberOfMonthsPair = useEditFormField<int>(
      hint: "Number of Months",
      value: isNewEntry ? "" : entry.numberOfMonths.toString(),
      validation: _intValidation,
      transformer: _intTrans,
    );
    final percentagePair = useEditFormField<double>(
      hint: "Percentage %",
      value: isNewEntry ? "" : (entry.percentage * 100).toString(),
      validation: _doubleValidation,
      transformer: _doubleTrans,
    );
    final startDatePair = useEditFormField(
      hint: "Start date",
      value: isNewEntry ? "" : entry.startDate,
    );

    Future<void> deleteEntry() async {
      if (isNewEntry) return;

      await HiveStore.instance.installmentEntryBox.delete(entry.id);

      Navigator.of(context).pop();
    }

    Future<void> modifyEntry() async {
      if (!formKey.currentState.validate()) return;

      final id = isNewEntry ? Uuid().v4() : entry.id;
      final name = namePair.sValue;
      final natId = natIdPair.sValue;
      final phone = phonePair.sValue;
      final item = itemPair.sValue;
      final itemPrice = itemPricePair.tValue;
      final initialPrice = initialPair.tValue;
      final paied = paiedPair.tValue;
      final numberOfMonthes = numberOfMonthsPair.tValue;
      final percentage = percentagePair.tValue;
      final startDate = startDatePair.sValue;

      final newEntry = InstallmentEntry(
        id: id,
        name: name,
        nationalId: natId,
        mobile: phone,
        item: item,
        totalPrice: itemPrice,
        initial: initialPrice,
        paied: paied,
        numberOfMonths: numberOfMonthes,
        startDate: startDate,
        isArchived: false,
        percentage: percentage / 100,
      );

      await HiveStore.instance.installmentEntryBox.put(id, newEntry);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isNewEntry ? "New Entry" : "Edit Entry"),
        actions: [
          if (!isNewEntry)
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  final shouldDelete = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure you want to delete"),
                        content: Text("asdasdasdasdasdasd"),
                        actions: [
                          FlatButton(
                            child: Text("YES"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          FlatButton(
                            child: Text("NO"),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (shouldDelete == true) {
                    deleteEntry();
                  }
                }),
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                modifyEntry();
              }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isNewEntry) ...[
              Text(
                "Remaining: ${entry.remaining.round()}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addMoneyController,
                      decoration: InputDecoration(labelText: "Add Money"),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Update"),
                    onPressed: () {
                      double value = double.tryParse(addMoneyController.text);
                      if (value != null) {
                        paiedPair.controller.text =
                            (paiedPair.tValue + value).toString();
                        modifyEntry();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Add mony should be a number");
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 35),
            ],
            Form(
              key: formKey,
              child: Column(
                children: [
                  ...[
                    namePair,
                    natIdPair,
                    phonePair,
                    itemPair,
                    itemPricePair,
                    initialPair,
                    paiedPair,
                    numberOfMonthsPair,
                    percentagePair,
                    startDatePair
                  ].map((e) => e.field),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
