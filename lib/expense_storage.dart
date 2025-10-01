import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseStorage {
  static const String _key = 'expenses';

  static Future<List<Map<String, dynamic>>> loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_key);
    if (data != null) {
      return List<Map<String, dynamic>>.from(json.decode(data));
    }
    return [];
  }

  static Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(expenses));
  }
}
