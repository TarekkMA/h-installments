import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:installments/data/hive_store.dart';
import 'package:installments/ui/screens/edit_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:installments/models/installment_entry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            Text("Add New Installment"),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditScreen.newEntry()),
          );
        },
      ),
      body: ValueListenableBuilder<Box<InstallmentEntry>>(
          valueListenable: HiveStore.instance.installmentEntryBox.listenable(),
          builder: (context, box, _) {
            final items = box.values.toList();
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InstallmentCard(
                  installmentEntry: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditScreen(entry: item)),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}

class InstallmentCard extends StatelessWidget {
  final InstallmentEntry installmentEntry;
  final Function onTap;
  const InstallmentCard({
    Key key,
    @required this.onTap,
    @required this.installmentEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(40),
                  1: FlexColumnWidth(0.5),
                },
                children: [
                  getRow(Icons.person, "Name", installmentEntry.name),
                  getRow(Icons.phone_iphone, "Mobile Number",
                      installmentEntry.mobile),
                  getRow(Icons.attach_money, "Remaining",
                      "${installmentEntry.remaining.round()} EGP"),
                  getRow(Icons.attach_money, "Per Month",
                      "${installmentEntry.costPerMonth.round()} EGP"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow getRow(
    IconData icon,
    String header,
    String data,
  ) {
    return TableRow(children: [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          icon,
          size: 20,
        ),
      ),
      Text(
        header,
      ),
      Text(
        data,
        textAlign: TextAlign.center,
      )
    ]);
  }
}
