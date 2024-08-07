import 'dart:developer';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class CurrencyPtBrInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ ${formatter.format(value/100)}";
    log(newText);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length));
  }
}

class ComparatorFormFieldWidget extends StatelessWidget {
  const ComparatorFormFieldWidget({
    super.key,
    required this.label, required this.controller, required this.onChanged,
  });
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      validator: Validatorless.multiple([
        Validatorless.required('Este campo é obrigatório!'),
        (value) {
          double doubleValue = UtilBrasilFields.converterMoedaParaDouble(value ?? 'R\$ 00.0');
          log(doubleValue.toString());
          if(doubleValue < 1  || doubleValue > 1000000000) {
            return 'Não é possivel simular esse valor';
          }
          return null;
        }
      ]),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyPtBrInputFormatter()],
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.orange, style: BorderStyle.solid),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
      ),
    );
  }
}