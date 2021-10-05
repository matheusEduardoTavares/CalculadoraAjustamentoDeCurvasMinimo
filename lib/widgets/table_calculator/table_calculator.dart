import 'package:flutter/material.dart';

import 'package:ajustamento_curva_minimo/extensions/calculator_type/calculator_type.dart';
import 'package:ajustamento_curva_minimo/widgets/column_cell/column_cell.dart';

class TableCalculator extends StatefulWidget {
  const TableCalculator({
    required this.calculatorType,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<CalculatorType> calculatorType;

  @override
  State<TableCalculator> createState() => _TableCalculatorState();
}

class RowsTable {
  RowsTable({
    required this.calculate,
    required this.items,
  });

  final double Function(double x, double y) calculate;
  List<String?> items;
}

class ColumnsTable {
  ColumnsTable({
    required this.rows,
    required this.title,
  });
  List<RowsTable> rows;
  final String title;
}

class _TableCalculatorState extends State<TableCalculator> {

  final _formKey = GlobalKey<FormState>();

  ColumnsTable _generateNewColumn({int? qtyFields}) {
    return ColumnsTable(
      rows: List<RowsTable>.from(_rowDefinition.value.map((e) => RowsTable(calculate: e.calculate, items: [
          ...e.items,
          ...List.filled(qtyFields ?? 0, '', growable: true)
        ])).toList()), 
      title: 'Coluna $qtyFields',
    );
  }

  late ValueNotifier<List<ColumnsTable>> _items;
  late ValueNotifier<List<RowsTable>> _rowDefinition;
  late ValueNotifier<String?> _result;

  @override
  void initState() {
    super.initState();

    _result = ValueNotifier(null);

    _rowDefinition = ValueNotifier(widget.calculatorType.value.rowDefinitionValue);

    _items = ValueNotifier<List<ColumnsTable>>([
      _generateNewColumn(),
    ]);
  }

  List<DataRow> _getRows() {
    final rows = <DataRow>[];

    for (var rowIndex = 0; rowIndex < _items.value[0].rows.length; rowIndex++) {
      rows.add(DataRow(
        cells: _items.value[0].rows[rowIndex].items.asMap().map(
          (cellIndex, numberValue) => MapEntry(
            cellIndex, 
            DataCell(
              ColumnCell(
                isEditable: widget.calculatorType.value.isEditable(
                  ValidEditValueViewModel(rowIndex: rowIndex, cellIndex: cellIndex)
                ),
                onChanged: (newValue) => _items.value[0].rows[rowIndex].items[cellIndex] = newValue,
                value: numberValue,
              ),
            )
          )
        ).values.toList(),
      ));
    }

    return rows;
  }

  double _getSumRow(int index) {
    final row = _items.value[0].rows[index];
    print(row);
    final numbers = row.items.map((e) => double.tryParse(e!));
    print(numbers);
    final sum = numbers.fold<double>(0, (accumulator, currentValue) => accumulator + (currentValue ?? 0.0));
    print(sum);

    return sum;
  }

  void _completeTable() {
    final newList = List<ColumnsTable>.from(_items.value);
            
    for (var i = 0; i < _items.value.length; i++) {
      for (var j = 0; j < _items.value[i].rows.length; j++) {
        final cellItems = List<String?>.from(_items.value[i].rows[j].items);
        for (var k = 0; k < cellItems.length; k++) {
          final yValue = double.tryParse(_items.value[i].rows[0].items[k] ?? '') ?? 0.0;
          final xValue = double.tryParse(_items.value[i].rows[1].items[k] ?? '') ?? 0.0;
          cellItems[k] = (cellItems[k]?.isEmpty ?? true) ? _items.value[i].rows[j].calculate(xValue, yValue).toString() : cellItems[k];
        }
        
        newList[i].rows[j].items = cellItems;
      }
    }

    _items.value = newList;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.calculatorType,
              builder: (_, __, ___) {
                return ValueListenableBuilder(
                    valueListenable: _items,
                    builder: (_, __, ___) => Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ElevatedButton(
                                  child: const Text('Adicionar coluna'),
                                  onPressed: () {
                                    final newList = List<ColumnsTable>.from(_items.value);
            
                                    for (var i = 0; i < _items.value.length; i++) {
                                      for (var j = 0; j < _items.value[i].rows.length; j++) {
                                        final cellItems = List<String?>.from(_items.value[i].rows[j].items);
                                        cellItems.add('');
                                        
                                        newList[i].rows[j].items = cellItems;
                                      }
                                    }
            
                                    _items.value = newList..add(_generateNewColumn(qtyFields: _items.value.length));
                                  },
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: DataTable(
                                  columnSpacing: 10,
                                  columns: _items.value.asMap().map(
                                    (index, value) => MapEntry(
                                      index, 
                                      DataColumn(
                                        label: Text(
                                          'Coluna ${index + 1}',
                                          style: const TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                        onSort: (index, __) {
                                          if (index > 0) {
                                            final newList = List<ColumnsTable>.from(_items.value);
            
                                            for (var i = 0; i < _items.value.length; i++) {
                                              for (var j = 0; j < _items.value[i].rows.length; j++) {
                                                final cellItems = List<String?>.from(_items.value[i].rows[j].items);
                                                cellItems.removeAt(index);
                                                
                                                newList[i].rows[j].items = cellItems;
                                              }
                                            }
            
                                            _items.value = newList..removeAt(index);
                                          }
                                        }
                                      )
                                    )
                                  ).values.toList(),
                                  rows: _getRows(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final sumY = _getSumRow(0);
                              print('sumY = $sumY');

                              final sumX = _getSumRow(1);
                              print('sumX = $sumX');

                              _completeTable();

                              final sumXSquareMultiplyY = _getSumRow(2);
                              print('sumXSquareMultiplyY = $sumXSquareMultiplyY');

                              final sumXElevate4 = _getSumRow(3);
                              print('sumXElevate4 = $sumXElevate4');

                              final sumXElevate3 = _getSumRow(4);
                              print('sumXElevate3 = $sumXElevate3');

                              final sumXElevate2 = _getSumRow(5);
                              print('sumXElevate2 = $sumXElevate2');

                              final sumXMultiplyY = _getSumRow(6);
                              print('sumXMultiplyY = $sumXMultiplyY');

                              final sumZ = _getSumRow(7);
                              print('sumZ = $sumZ');

                              final matrix = [
                                [sumXElevate4, sumXElevate3, sumXElevate2, sumXSquareMultiplyY],
                                [sumXElevate3, sumXElevate2, sumX, sumXMultiplyY],
                                [sumXElevate2, sumX, sumZ, sumY],
                              ];

                            }
                          }, 
                          child: const Text('Calcular')
                        ),
                        const SizedBox(height: 10,),
                        ValueListenableBuilder(
                          valueListenable: _result, 
                          builder: (_, __, ___) => Text(
                            _result.value != null ? 'O resultado é ${_result.value}' : '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}