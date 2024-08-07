import 'package:flutter/material.dart';

class ComparatorDropButtonFormWidget extends StatelessWidget {
  const ComparatorDropButtonFormWidget({
    super.key,
    required this.label, required this.items, required this.onChanged,
  });
  final String label;
  final List<dynamic> items;
  final Function(dynamic) onChanged;


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      
      items: items.map<DropdownMenuItem<dynamic>>((value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: onChanged,
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