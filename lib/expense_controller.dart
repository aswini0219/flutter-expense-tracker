import 'expense_storage.dart';

class ExpenseController {
  List<Map<String, dynamic>> expenses = [];

  Future<void> loadExpenses() async {
    expenses = await ExpenseStorage.loadExpenses();
  }

  void addExpense(String title, double amount, String category) {
    expenses.add({
      'title': title,
      'amount': amount,
      'category': category,
      'date': DateTime.now().toString(),
    });
    ExpenseStorage.saveExpenses(expenses);
  }

  void deleteExpense(int index) {
    expenses.removeAt(index);
    ExpenseStorage.saveExpenses(expenses);
  }

  // New method for editing
  void editExpense(int index, String title, double amount, String category) {
    expenses[index] = {
      'title': title,
      'amount': amount,
      'category': category,
      'date': expenses[index]['date'], // keep old date
    };
    ExpenseStorage.saveExpenses(expenses);
  }

  double get totalExpenses {
    return expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  Map<String, double> get categoryTotals {
    Map<String, double> totals = {};
    for (var expense in expenses) {
      String cat = expense['category'];
      double amount = expense['amount'];
      totals[cat] = (totals[cat] ?? 0) + amount;
    }
    return totals;
  }
}
