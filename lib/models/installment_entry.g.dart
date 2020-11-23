// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstallmentEntryAdapter extends TypeAdapter<InstallmentEntry> {
  @override
  final int typeId = 1;

  @override
  InstallmentEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstallmentEntry(
      id: fields[0] as String,
      name: fields[1] as String,
      nationalId: fields[2] as String,
      mobile: fields[3] as String,
      item: fields[4] as String,
      totalPrice: fields[5] as double,
      initial: fields[6] as double,
      numberOfMonths: fields[7] as int,
      percentage: fields[8] as double,
      startDate: fields[9] as String,
      isArchived: fields[10] as bool,
      paied: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InstallmentEntry obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nationalId)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.item)
      ..writeByte(5)
      ..write(obj.totalPrice)
      ..writeByte(6)
      ..write(obj.initial)
      ..writeByte(7)
      ..write(obj.numberOfMonths)
      ..writeByte(8)
      ..write(obj.percentage)
      ..writeByte(9)
      ..write(obj.startDate)
      ..writeByte(10)
      ..write(obj.isArchived)
      ..writeByte(11)
      ..write(obj.paied);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstallmentEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
