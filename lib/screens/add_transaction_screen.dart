import 'package:flutter/material.dart';
import '../models/transaction.dart';


class AddTransactionScreen extends StatefulWidget {
  final void Function(Transaction transaction) onAddTransaction;

  const AddTransactionScreen({super.key, required this.onAddTransaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  
  final _formKey = GlobalKey<FormState>(); // GlobalKey<FormState> je kljuc koji se koristi za identifikaciju forme i pristupanje njenom stanju, npr. validacija
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense; 

  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['Hrana', 'Računi', 'Zabava', 'Transport', 'Plata', 'Ostalo'];
  String _selectedCategory = 'Hrana';

  Future<void> _pickDate() async { // future - void koji kasnije vraca rezultat
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) { // svaki validator koji prodje daje null, dakle ako ni jedan nije null, currentState! vraca true
      final transaction = Transaction(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text), //nije tryParse jer je vec prosao validatore, znamo da je validan broj
        category: _selectedCategory,
        type: _selectedType,
        date: _selectedDate,
      );
      widget.onAddTransaction(transaction); //callback funkcija koja se poziva kada se doda transakcija, prosledjuje se iz HomeScreen-a
      Navigator.pop(context);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova transakcija')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Opis'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Unesite opis';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Iznos'),
              validator: (value) {
                if(value == null || double.tryParse(value)==null){
                  return 'Unesite validan iznos';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            SegmentedButton<TransactionType>( // grupa dugmadi, samo jedno moze biti selektovano
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Rashod'),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Prihod'),
                ),
          ],
          selected: {_selectedType},
              onSelectionChanged: (newSelection){
                setState((){
                  _selectedType = newSelection.first;
                });
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Kategorija'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
            SizedBox(height: 12),
              Row(
                children: [
                  Text('Datum: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}.'),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Promeni datum'),
                  ),
                ],
              ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Dodaj transakciju'),
            ),
          ],
        ) // Column
      )
    ),
    );
  }
}