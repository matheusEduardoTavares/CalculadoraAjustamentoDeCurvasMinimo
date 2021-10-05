import 'package:ajustamento_curva_minimo/widgets/table_calculator/table_calculator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  static final a11 = ValueNotifier<int>(0);
  static final a12 = ValueNotifier<int>(0);
  static final a13 = ValueNotifier<int>(0);
  static final a21 = ValueNotifier<int>(0);
  static final a22 = ValueNotifier<int>(0);
  static final a23 = ValueNotifier<int>(0);
  static final a31 = ValueNotifier<int>(0);
  static final a32 = ValueNotifier<int>(0);
  static final a33 = ValueNotifier<int>(0);
  static final sum = ValueNotifier<int?>(null);
  static final is3x3 = ValueNotifier<bool>(false);

  String get _qty => is3x3.value ? '3x3' : '2x2';
  static String get invertedQty => is3x3.value ? '2x2' : '3x3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: is3x3,
          builder: (_, __, ___) => Text('Calcular determinante $_qty'),
        ),
        actions: [
          TextButton(
            child: ValueListenableBuilder(
                valueListenable: is3x3,
                builder: (_, __, ___) => Text(
                invertedQty,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              is3x3.value = !is3x3.value;
              sum.value = null;
            },
          ),
        ],
      ),
      body: TableCalculator(),
    );
  }
}