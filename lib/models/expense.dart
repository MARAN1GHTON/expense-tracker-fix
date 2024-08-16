//import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:expense_tracker/widgets/expenses.dart';

final formatter = DateFormat('dd.MM.yyyy');
const uuid = Uuid();

enum Group { food, travel, leisure, work }

const groupIcons = {
  Group.food: Icons.apple,
  Group.travel: Icons.accessible_forward_sharp,
  Group.leisure: Icons.auto_stories,
  Group.work: Icons.sentiment_very_dissatisfied
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.group})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Group group;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.expenses, required this.group});

  ExpenseBucket.forGroup(List<Expense> allExpenses, this.group)
      : expenses =
            allExpenses.where((expense) => expense.group == group).toList();

  final Group group;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses
        // var i = 0; i < expense.length; i++
        ) {
      sum += expense.amount;
    }
    return sum;
  }
}
