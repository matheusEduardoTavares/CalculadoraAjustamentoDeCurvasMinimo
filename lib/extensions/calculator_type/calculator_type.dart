enum CalculatorType {
  leastSquareCurveFit,
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
  };

  static final _rowDefinition = {
    CalculatorType.leastSquareCurveFit: [
      ['Y'],
      ['X'],
      ['X^2 * Y'],
      ['X^4'],
      ['X^3'],
      ['X^3'],
      ['X * Y'],
      ['Z1'],
    ],
  };

  static final _conditionDefinition = {
    CalculatorType.leastSquareCurveFit: _conditionIsEditableOnLeastSquareCurveFit,
  };

  static bool _conditionIsEditableOnLeastSquareCurveFit(ValidEditValueViewModel model) {
    return !(model.cellIndex == 0 || model.rowIndex > 1);
  }

  String get stringValue => _stringValue[this]!;
  List<List<String?>> get rowDefinitionValue => _rowDefinition[this]!;
  ConditionTypedef get isEditable => _conditionDefinition[this]!;
  List<CalculatorType> get values => CalculatorType.values;
}