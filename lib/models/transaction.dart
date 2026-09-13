enum TransactionType {
  income,
  expense,
}

class Transaction{
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });
}