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

class CalculateSums {
  final double Function(double x, double y) calculate;
  CalculateSums({
    required this.calculate,
    required this.label,
  });
  final String label;
}

class _TableCalculatorState extends State<TableCalculator> {

  final _formKey = GlobalKey<FormState>();

  List<List<String?>> _generateNewColumn({int? qtyFields}) {
    return List.from(_rowDefinition.value.map((e) => [
      ...e,
      ...List.filled(qtyFields ?? 0, '', growable: true),
    ]).toList());
  }

  late ValueNotifier<List<List<List<String?>>>> _items;
  late ValueNotifier<List<List<String?>>> _rowDefinition;
  late ValueNotifier<String?> _result;

  @override
  void initState() {
    super.initState();

    _result = ValueNotifier(null);

    _rowDefinition = ValueNotifier(widget.calculatorType.value.rowDefinitionValue);

    _items = ValueNotifier<List<List<List<String?>>>>([
      _generateNewColumn(),
    ]);
  }

  List<DataRow> _getRows() {
    final rows = <DataRow>[];

    for (var rowIndex = 0; rowIndex < _items.value[0].length; rowIndex++) {
      rows.add(DataRow(
        cells: _items.value[0][rowIndex].asMap().map(
          (cellIndex, numberValue) => MapEntry(
            cellIndex, 
            DataCell(
              ColumnCell(
                isEditable: widget.calculatorType.value.isEditable(
                  ValidEditValueViewModel(rowIndex: rowIndex, cellIndex: cellIndex)
                ),
                onChanged: (newValue) => _items.value[0][rowIndex][cellIndex] = newValue,
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
    final row = _items.value[0][index];
    print(row);
    final numbers = row.map((e) => double.tryParse(e!));
    print(numbers);
    final sum = numbers.fold<double>(0, (accumulator, currentValue) => accumulator + (currentValue ?? 0.0));
    print(sum);

    return sum;
  }

  void _completeTable() {
    // final newList = List<List<List<String?>>>.from(_items.value);
            
    // for (var i = 0; i < _items.value.length; i++) {
    //   for (var j = 0; j < _items.value[i].length; j++) {
    //     final cellItems = List<String?>.from(_items.value[i][j]);
    //     for (var k = 0; k < _items.value[i][j].length; k++) {
    //       cellItems[k] = (cellItems[k]?.isEmpty ?? true) ?  : cellItems[k];
    //     }
        
    //     newList[i][j] = cellItems;
    //   }
    // }

    // _items.value = newList..add(_generateNewColumn(qtyFields: _items.value.length));
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
                                    final newList = List<List<List<String?>>>.from(_items.value);
            
                                    for (var i = 0; i < _items.value.length; i++) {
                                      for (var j = 0; j < _items.value[i].length; j++) {
                                        final cellItems = List<String?>.from(_items.value[i][j]);
                                        cellItems.add('');
                                        
                                        newList[i][j] = cellItems;
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
                                            final newList = List<List<List<String?>>>.from(_items.value);
            
                                            for (var i = 0; i < _items.value.length; i++) {
                                              for (var j = 0; j < _items.value[i].length; j++) {
                                                final cellItems = List<String?>.from(_items.value[i][j]);
                                                cellItems.removeAt(index);
                                                
                                                newList[i][j] = cellItems;
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

                              // final 

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