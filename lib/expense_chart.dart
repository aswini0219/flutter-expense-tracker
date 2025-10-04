import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, double> categoryTotals;

  ExpenseChart({required this.categoryTotals});

  final Map<String, Color> categoryColors = {
    "Food": Colors.red,
    "Travel": Colors.blue,
    "Shopping": Colors.green,
    "Bills": Colors.orange,
    "Other": Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Center(child: Text("No data for chart"));
    }

    // Calculate total for percentages
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    final sections = categoryTotals.entries.map((entry) {
      final percent = (entry.value / total * 100).toStringAsFixed(1);
      return PieChartSectionData(
        value: entry.value,
        title: "$percent%", // Show percentage inside
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: categoryColors[entry.key] ?? Colors.grey,
        radius: 60,
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: categoryTotals.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  color: categoryColors[entry.key] ?? Colors.grey,
                ),
                const SizedBox(width: 6),
                Text("${entry.key}: ₹${entry.value.toStringAsFixed(0)}"),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
