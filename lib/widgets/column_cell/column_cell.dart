import 'package:flutter/material.dart';

class ColumnCell extends StatelessWidget {
  const ColumnCell({ 
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final void Function(String) onChanged;

  String? _validateInt(String? value) {
    if (int.tryParse(value!) != null) {
      return null;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        validator: _validateInt,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}