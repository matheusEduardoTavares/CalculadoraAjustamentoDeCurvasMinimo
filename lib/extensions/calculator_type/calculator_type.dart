import 'package:ajustamento_curva_minimo/widgets/table_calculator/table_calculator.dart';

enum CalculatorType {
  leastSquareCurveFit,
  linearMinimumCurveFit,
}

class ValidEditValueViewModel {
  ValidEditValueViewModel({
    required this.rowIndex,
    required this.cellIndex,
  });
  final int rowIndex;
  final int cellIndex;
}

typedef ConditionTypedef = bool Function(ValidEditValueViewModel);

extension CalculatorTypeExt on CalculatorType {
  static final _stringValue = {
    CalculatorType.leastSquareCurveFit: 'Ajustamento de curva mínimo quadrado',
    CalculatorType.linearMinimumCurveFit: 'Ajustamento de curva mínimo linear',
  };

  static final _rowDefinition = {
    CalculatorType.leastSquareCurveFit: [
      RowsTable(calculate: (x, y) => y, items: ['Y']),
      RowsTable(calculate: (x, y) => x, items: ['X']),
      RowsTable(calculate: (x, y) => (x*x) * y, items: ['X^2 * Y']),
      RowsTable(calculate: (x, y) => x * x * x * x, items: ['X^4']),
      RowsTable(calculate: (x, y) => x * x * x, items: ['X^3']),
      RowsTable(calculate: (x, y) => x * x, items: ['X^2']),
      RowsTable(calculate: (x, y) => x * y, items: ['X * Y']),
      RowsTable(calculate: (x, y) => 1, items: ['Z1']),
    ],
    CalculatorType.linearMinimumCurveFit: [
      RowsTable(calculate: (x, y) => y, items: ['Y']),
      RowsTable(calculate: (x, y) => x, items: ['X']),
      RowsTable(calculate: (x, y) => x * y, items: ['X * Y']),
      RowsTable(calculate: (x, y) => x * x, items: ['X^2']),
      RowsTable(calculate: (x, y) => 1, items: ['Z1']),
    ],
  };

  static final _conditionDefinition = {
    CalculatorType.leastSquareCurveFit: _conditionIsEditableOnLeastSquareCurveFit,
    CalculatorType.linearMinimumCurveFit: _conditionIsEditableOnLinearMinimumCurveFit,
  };

  static bool _conditionIsEditableOnLeastSquareCurveFit(ValidEditValueViewModel model) {
    return !(model.cellIndex == 0 || model.rowIndex > 1);
  }

  static bool _conditionIsEditableOnLinearMinimumCurveFit(ValidEditValueViewModel model) {
    return !(model.cellIndex == 0 || model.rowIndex > 1);
  }

  String get stringValue => _stringValue[this]!;
  List<RowsTable> get rowDefinitionValue => _rowDefinition[this]!;
  ConditionTypedef get isEditable => _conditionDefinition[this]!;
  List<CalculatorType> get values => CalculatorType.values;
}