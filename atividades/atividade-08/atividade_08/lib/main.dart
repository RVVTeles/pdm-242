import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Formulário de Validação')),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic>? formattedData;

  final _dateController = TextEditingController();
  final _cpfController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_formatDate);
    _cpfController.addListener(_formatCPF);
    _valueController.addListener(_formatValue);
  }

  @override
  void dispose() {
    _dateController.removeListener(_formatDate);
    _cpfController.removeListener(_formatCPF);
    _valueController.removeListener(_formatValue);
    _dateController.dispose();
    _cpfController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }
    try {
      DateFormat('dd/MM/yyyy').parseStrict(value);
    } catch (e) {
      return 'Formato de data inválido';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    if (!CPFValidator.isValid(value)) {
      return 'CPF inválido';
    }
    return null;
  }

  String? validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Valor é obrigatório';
    }
    final doubleValue = double.tryParse(value.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));
    if (doubleValue == null || doubleValue < 0) {
      return 'Valor inválido';
    }
    return null;
  }

  void _formatDate() {
    String text = _dateController.text.replaceAll('/', '');
    int textLength = text.length;

    if (textLength > 8) {
      text = text.substring(0, 8);
      textLength = text.length;
    }

    String formatted = "";
    if (textLength > 0) {
      if (textLength > 2) {
        formatted += text.substring(0, 2) + "/";
      } else {
        formatted += text;
      }
      if (textLength > 4) {
        formatted += text.substring(2, 4) + "/";
      } else if (textLength > 2) {
        formatted += text.substring(2);
      }
      if (textLength > 4) {
        formatted += text.substring(4);
      }
    }

    _dateController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _formatCPF() {
    String text = _cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    int textLength = text.length;

    if (textLength > 11) {
      text = text.substring(0, 11);
      textLength = text.length;
    }

    String formatted = "";
    if (textLength > 0) {
      if (textLength > 3) {
        formatted += text.substring(0, 3) + ".";
      } else {
        formatted += text;
      }
      if (textLength > 6) {
        formatted += text.substring(3, 6) + ".";
      } else if (textLength > 3) {
        formatted += text.substring(3);
      }
      if (textLength > 9) {
        formatted += text.substring(6, 9) + "-";
      } else if (textLength > 6) {
        formatted += text.substring(6);
      }
      if (textLength > 9) {
        formatted += text.substring(9);
      }
    }

    _cpfController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _formatValue() {
    String text = _valueController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      _valueController.value = TextEditingValue(
        text: 'R\$ 0,00',
        selection: TextSelection.collapsed(offset: 6),
      );
      return;
    }

    // Garantir que o valor tenha no máximo 11 dígitos (para evitar overflow)
    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    // Adicionar zeros à esquerda para garantir 2 casas decimais
    while (text.length < 3) {
      text = '0' + text;
    }

    // Separar a parte inteira e a parte decimal
    String integerPart = text.substring(0, text.length - 2);
    String decimalPart = text.substring(text.length - 2);

    // Remover zeros à esquerda da parte inteira, exceto quando o valor for menor que 1
    if (integerPart.isNotEmpty) {
      integerPart = int.parse(integerPart).toString();
    }

    // Formatar o valor final
    String formatted = 'R\$ $integerPart,$decimalPart';

    _valueController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'data',
              decoration: InputDecoration(labelText: 'Data (DD/MM/YYYY)'),
              validator: validateDate,
              controller: _dateController,
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              name: 'email',
              decoration: InputDecoration(labelText: 'Email'),
              validator: validateEmail,
            ),
            FormBuilderTextField(
              name: 'cpf',
              decoration: InputDecoration(labelText: 'CPF'),
              validator: validateCPF,
              controller: _cpfController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value != null) {
                  _formatCPF();
                  _formKey.currentState?.fields['cpf']?.validate();
                }
              },
            ),
            FormBuilderTextField(
              name: 'valor',
              decoration: InputDecoration(labelText: 'Valor'),
              validator: validateValue,
              controller: _valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                if (value != null) {
                  _formatValue();
                  _formKey.currentState?.fields['valor']?.validate();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  final formData = _formKey.currentState?.value;

                  if (formData != null) {
                    formattedData = {
                      'data': formData['data'],
                      'email': formData['email'],
                      'cpf': formData['cpf'],
                      'valor': formData['valor'],
                    };

                    print(formattedData);

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Dados inseridos com sucesso'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}