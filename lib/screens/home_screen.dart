import 'package:flutter/material.dart';
import '../models/budget_user.dart';
import '../services/app_service.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  final BudgetUser user;
  final AppService appservice;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.user,
    required this.appservice,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [];

  @override
  void initState() { // initState se poziva kada se widget kreira, pre build metode, i koristi se za inicijalizaciju stanja
    super.initState();
    _transactions = widget.appservice.getTransactions(widget.user.email);
  }
  
  double get _totalIncome {
    double sum = 0;
    for(final t in _transactions){
      if(t.type == TransactionType.income)
        {sum += t.amount;}
      }
    return sum;
    }

    double get _totalExpense {
      double sum = 0;
      for(final t in _transactions){
        if(t.type == TransactionType.expense)
          {sum += t.amount;}
      }
      return sum;
    }

    double get _balance => _totalIncome - _totalExpense;


  void _addTransaction(Transaction transaction){
    setState(() {
      widget.appservice.addTransaction(widget.user.email, transaction);
      _transactions = widget.appservice.getTransactions(widget.user.email);
    });
  }

  void _deleteTransaction(Transaction transaction){
    setState((){
      widget.appservice.deleteTransaction(widget.user.email, transaction);
      _transactions = widget.appservice.getTransactions(widget.user.email);
    });
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: Icon(Icons.logout)
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dobrodošli, ${widget.user.name}!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Prihod: ${_totalIncome.toStringAsFixed(2)} RSD'),
            Text('Rashod: ${_totalExpense.toStringAsFixed(2)} RSD'),
            Text('Stanje: ${_balance.toStringAsFixed(2)} RSD'), 
            SizedBox(height: 20),
            Expanded( // listview trazi beskonacno prostora, expanded ga ogranicava na preostali column prostor nakon sto se ostali elementi postave
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) { // indeksira elemente liste (ovde sve transakcije)
                  final t = _transactions[index];
                  final isIncome = t.type == TransactionType.income;
                  return ListTile(
                    leading: Icon(
                      isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                    title: Text(t.title),
                    subtitle: Text('${t.category} • ${t.date.day}.${t.date.month}.${t.date.year}.'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${isIncome ? '+' : '-'}${t.amount.toStringAsFixed(2)} RSD',
                          style: TextStyle(
                            color: isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () => _deleteTransaction(t),
                        ),
                      ],
                    )
                  );
                },
              ),
            ),
            
          ],
          
        )
      ),

      floatingActionButton: FloatingActionButton( // dugme koji pluta preko ekrana
        onPressed: () {
          Navigator.push( // Navigator je widget koji omogucava navigaciju izmedju ekrana, push dodaje novi ekran na vrh stack-a
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                onAddTransaction: _addTransaction,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      )
    );
  }
}