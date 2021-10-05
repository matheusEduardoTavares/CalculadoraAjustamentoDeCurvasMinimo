import 'package:ajustamento_curva_minimo/extensions/calculator_type/calculator_type.dart';
import 'package:ajustamento_curva_minimo/widgets/table_calculator/table_calculator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ValueNotifier<CalculatorType> _calculatorType;

  @override
  void initState() {
    super.initState();

    _calculatorType = ValueNotifier(CalculatorType.leastSquareCurveFit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: _calculatorType,
          builder: (_, __, ___) => FittedBox(child: Text(_calculatorType.value.stringValue)),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _calculatorType,
            builder: (_, __, ___) => PopupMenuButton(
              itemBuilder: (_) => _calculatorType.value.values.map((e) => PopupMenuItem(child: Text(e.stringValue))).toList(),
            ),
          )
        ],
      ),
      body: TableCalculator(
        calculatorType: _calculatorType,
      ),
    );
  }
}