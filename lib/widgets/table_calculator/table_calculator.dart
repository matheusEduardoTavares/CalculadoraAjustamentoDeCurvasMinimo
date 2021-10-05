import 'package:ajustamento_curva_minimo/pages/home_page/home_page.dart';
import 'package:ajustamento_curva_minimo/widgets/column_cell/column_cell.dart';
import 'package:flutter/material.dart';

class TableCalculator extends StatelessWidget {
  TableCalculator({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: HomePage.is3x3,
                builder: (_, __, ___) => Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Form(
                        key: _formKey,
                        child: DataTable(
                          columnSpacing: 10,
                          columns: <DataColumn>[
                            const DataColumn(
                              label: Text(
                                'Coluna 1',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            const DataColumn(
                              label: Text(
                                'Coluna 2',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            if (HomePage.is3x3.value)
                              const DataColumn(
                                label: Text(
                                  'Coluna 3',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                          rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  ColumnCell(
                                    onChanged: (value) {
                                      if (int.tryParse(value) != null) {
                                        HomePage.a11.value = int.parse(value);
                                      }
                                    },
                                  ),
                                ),
                                DataCell(
                                  ColumnCell(
                                    onChanged: (value) {
                                      if (int.tryParse(value) != null) {
                                        HomePage.a12.value = int.parse(value);
                                      }
                                    },
                                  ),
                                ),
                                if (HomePage.is3x3.value)
                                  DataCell(
                                  ColumnCell(
                                    onChanged: (value) {
                                      if (int.tryParse(value) != null) {
                                        HomePage.a13.value = int.parse(value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  ColumnCell(
                                    onChanged: (value) {
                                      if (int.tryParse(value) != null) {
                                        HomePage.a21.value = int.parse(value);
                                      }
                                    },
                                  ),
                                ),
                                DataCell(
                                  ColumnCell(
                                    onChanged: (value) {
                                      if (int.tryParse(value) != null) {
                                        HomePage.a22.value = int.parse(value);
                                      }
                                    },
                                  ),
                                ),
                                if (HomePage.is3x3.value)
                                  DataCell(
                                    ColumnCell(
                                      onChanged: (value) {
                                        if (int.tryParse(value) != null) {
                                          HomePage.a23.value = int.parse(value);
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            if (HomePage.is3x3.value)
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    ColumnCell(
                                      onChanged: (value) {
                                        if (int.tryParse(value) != null) {
                                          HomePage.a31.value = int.parse(value);
                                        }
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    ColumnCell(
                                      onChanged: (value) {
                                        if (int.tryParse(value) != null) {
                                          HomePage.a32.value = int.parse(value);
                                        }
                                      },
                                    ),
                                  ),
                                  if (HomePage.is3x3.value)
                                    DataCell(
                                    ColumnCell(
                                      onChanged: (value) {
                                        if (int.tryParse(value) != null) {
                                          HomePage.a33.value = int.parse(value);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        HomePage.sum.value = null;
                        if (_formKey.currentState!.validate()) {
                          if (HomePage.is3x3.value) {
                            final value = (HomePage.a11.value * HomePage.a22.value * HomePage.a33.value) + 
                              (HomePage.a12.value * HomePage.a23.value * HomePage.a31.value) + 
                                (HomePage.a13.value * HomePage.a21.value * HomePage.a32.value) - 
                                  (HomePage.a13.value * HomePage.a22.value * HomePage.a31.value) - 
                                    (HomePage.a11.value * HomePage.a23.value * HomePage.a32.value) - 
                                      (HomePage.a12.value * HomePage.a21.value * HomePage.a33.value);

                            HomePage.sum.value = value;
                          }
                          else {
                            final value = (HomePage.a11.value * HomePage.a22.value) - 
                              (HomePage.a12.value * HomePage.a21.value);

                            HomePage.sum.value = value;
                          }
                        }
                      }, 
                      child: const Text('Calcular')
                    ),
                    const SizedBox(height: 10,),
                    ValueListenableBuilder(
                      valueListenable: HomePage.sum, 
                      builder: (_, __, ___) => Text(
                        HomePage.sum.value != null ? 'Determinante = ${HomePage.sum.value}' : '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}