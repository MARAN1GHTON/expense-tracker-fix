import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
// import 'package:expense_tracker/widgets/expenses.dart';

final formatter = DateFormat('dd.MM.yyyy');

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Group _selectedGroup = Group.leisure;

  void _presentDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amoubtIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amoubtIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ты тупой?'),
          content:
              const Text('Проверьте корректность заполнения всех пунктов!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('ОК'),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          group: _selectedGroup),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(children: [
              if (width >= 600)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child: TextField(
                    //     controller: _amountController,
                    //     keyboardType: const TextInputType.numberWithOptions(),
                    //     decoration: const InputDecoration(
                    //       prefixText: '\$ ',
                    //       label: Text(
                    //           'Ты бля могзги не еби, я спрашиваю сколько'),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('Инвестиция'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Сумма'),
                        ),
                      ),
                    ),
                  ],
                )
              else
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Инвестиция'),
                  ),
                ),
              if (width >= 600)
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedGroup,
                      items: Group.values
                          .map(
                            (group) => DropdownMenuItem(
                              value: group,
                              child: Text(
                                group.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(
                          () {
                            _selectedGroup = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Дата'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDate,
                            icon: const Icon(Icons.calendar_month_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Сумма'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Дата'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDate,
                            icon: const Icon(Icons.calendar_month_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              // if (width >= 600)
              const SizedBox(
                width: 16,
              ),
              // Row(
              //   children: [
              //     const Spacer(),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       child: const Text('Закрыть'),
              //     ),
              //     ElevatedButton(
              //       onPressed: _submitExpenseData,
              //       child: const Text('Сохранить'),
              //     )
              //   ],
              // ),
              if (width >= 600)
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Закрыть'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Сохранить'),
                    )
                  ],
                )
              else
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedGroup,
                      items: Group.values
                          .map(
                            (group) => DropdownMenuItem(
                              value: group,
                              child: Text(
                                group.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(
                          () {
                            _selectedGroup = value;
                          },
                        );
                      },
                    ),
                    //     const SizedBox(
                    //       width: 24,
                    //     ),
                    //     Expanded(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             _selectedDate == null
                    //                 ? 'Какая дата, хуесос'
                    //                 : formatter.format(_selectedDate!),
                    //           ),
                    //           IconButton(
                    //             onPressed: _presentDate,
                    //             icon: const Icon(Icons.calendar_month_outlined),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ]),
                    // Expanded(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         _selectedDate == null
                    //             ? 'Какая дата, хуесос'
                    //             : formatter.format(_selectedDate!),
                    //       ),
                    //       IconButton(
                    //         onPressed: _presentDate,
                    //         icon: const Icon(Icons.calendar_month_outlined),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // Row(
                    //   children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Закрыть'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Сохранить'),
                    )
                  ],
                ),
            ]),
          ),
        ),
      );
    });
  }
}
