import 'package:flutter/material.dart';

class ColumnCell extends StatelessWidget {
  const ColumnCell({ 
    required this.onChanged,
    required this.value,
    required this.isEditable,
    Key? key,
  }) : super(key: key);

  final void Function(String) onChanged;
  final String? value;
  final bool isEditable;

  String? _validateDouble(String? value) {
    if (double.tryParse(value!) != null) {
      return null;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isEditable ? TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
        ),
        initialValue: value.toString(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (newValue) {
          if (_validateDouble(newValue) == null) {
            onChanged(newValue);
          }
        },
        validator: _validateDouble,
        textInputAction: TextInputAction.next,
      ) : Text(value?? ''),
    );
  }
}