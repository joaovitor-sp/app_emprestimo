
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownSearchWidget extends StatelessWidget {
  const DropDownSearchWidget({
    super.key,
    required this.label,
    required this.items, required this.onChanged,
  });
  final String label;
  final List<String?> items;
  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch.multiSelection(
      onChanged: onChanged,
      itemAsString: (item) => item.toString(),
      items: items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
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
      ),
    );
  }
}
