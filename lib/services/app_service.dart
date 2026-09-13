import '../models/budget_user.dart';
import '../models/transaction.dart';

class AppService{
  
  final List<BudgetUser> _users = [ // _users -> _ znaci privatna promenljiva, samo u ovom fajlu moze da se pristupi
    BudgetUser(name: 'Ana', email: 'ana@fon.bg', password: 'ana123'),
  ];

  BudgetUser? login(String email, String password) {   // ? -> moze da return null
    for(final user in _users){    // for-each, npr u javi (BudgetUser user : _users)
      if(user.email == email && user.password == password){
        return user;
      }
    }
    return null; 
  }

  BudgetUser register(String name, String email, String password){
    final newUser = BudgetUser(name: name, email: email, password:  password);
    _users.add(newUser);
    return newUser;
  }

    final Map<String, List<Transaction>> _transactionsByUser = { //mapa je 'kljuc->vrednost' struktura, kljuc je email, vrednost je lista transakcija
    'ana@fon.bg': [
      Transaction(
        title: 'Plata',
        amount: 50000,
        category: 'Plata',
        type: TransactionType.income,
        date: DateTime.now(),
      ),
      Transaction(
        title: 'Kirija',
        amount: 15000,
        category: 'Računi',
        type: TransactionType.expense,
        date: DateTime.now(),
      ),
    ],
  };

  List<Transaction> getTransactions(String email) {
    return _transactionsByUser[email] ?? []; //email u [] kao kljuc za pristup mapi, ?? [] -> ako ne postoji lista zq taj email vrati praznu listu
  }

  void addTransaction(String email, Transaction transaction){
    final list = _transactionsByUser[email] ?? []; 
    list.add(transaction);
    _transactionsByUser[email] = list;
  } // prvo uzimamo listu za taj mejl (ako nema uzimamo prazny), dodamo trans. u tu listu, i onda tu listu vratimo u mapu 

  void deleteTransaction(String email, Transaction transaction){
    final list = _transactionsByUser[email]  ?? [];
    list.remove(transaction);
    _transactionsByUser[email] = list;
  } // isti princip kao addTransaction
}





