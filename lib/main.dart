import 'package:flutter/material.dart';
import 'expense_controller.dart';
import 'expense_chart.dart';


void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ExpenseHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExpenseHomeScreen extends StatefulWidget {
  @override
  _ExpenseHomeScreenState createState() => _ExpenseHomeScreenState ();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  final ExpenseController _controller = ExpenseController();

  @override
  void initState() {
    super.initState();
    _controller.loadExpenses().then((_) {
      setState(() {});
    });
  }

  void _showExpenseDialog({int? index}) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedCategory = "Food" ;

    if (index != null) {
      var expense = _controller.expenses[index];
      titleController.text = expense['title'];
      amountController.text = expense['amount'].toString();
      selectedCategory = expense['category'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(index == null ? 'Add Expense' : 'Edit Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: ["Food", "Travel", "Shopping", "Bills", "Other"]
                        .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      if (index == null) {
                        _controller.addExpense(
                          titleController.text,
                          double.parse(amountController.text),
                          selectedCategory,
                        );
                      } else {
                        _controller.editExpense(
                          index,
                          titleController.text,
                          double.parse(amountController.text),
                          selectedCategory,
                        );
                      }
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: Text(index == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _controller.expenses;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expense Tracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: expenses.isEmpty
          ? Center(child: Text("No expenses yet."))
          : ListView(
        padding: EdgeInsets.all(8),
        children: [
          // ✅ Total expenses
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Text(
              "Total: ₹${_controller.totalExpenses.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ Pie Chart (with % and legend from separate file)
          ExpenseChart(categoryTotals: _controller.categoryTotals),

          const SizedBox(height: 20),
          // ✅ Expense list
          ...expenses.map((expense) {
            int index = expenses.indexOf(expense);
            return Card(
              color: Colors.teal.shade100,
              child: ListTile(
                title: Text(expense['title'],style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "₹${expense['amount']} - ${expense['category']} - ${expense['date'].split(' ')[0]}",style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showExpenseDialog(index: index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _controller.deleteExpense(index);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseDialog(),
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
