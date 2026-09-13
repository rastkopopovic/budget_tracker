import 'package:flutter/material.dart';
import '../services/app_service.dart';
import '../models/budget_user.dart';


class AuthScreen extends StatefulWidget { //widget = konfiguracija, kako izgleda ekran
  final AppService appService;
  final void Function(BudgetUser user) onLoginSuccess;

  const AuthScreen({
    super.key,
    required this.appService,
    required this.onLoginSuccess,
    });

  @override
  State<AuthScreen> createState() => _AuthScreenState(); // povezuje widget i njegov state
}

class _AuthScreenState extends State<AuthScreen> { // state = memorija, behind the scenes

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String? _errorMessage; // ? - nullable, moze da bude null, ako je null ne prikazuje se nista, ako nije null prikazuje se poruka
  bool _isRegisterMode = false;

  void _submit() { //cita email i password polja kroz controller, dalje se grana u register ili login
    final email = _emailController.text;
    final password = _passwordController.text;

    if(email.isEmpty || password.isEmpty){
      setState((){
        _errorMessage = 'Polje ne sme biti prazno.';
      });
      return;
    }

    if(_isRegisterMode){
      if (widget.appService.emailExists(email)){
        setState(() {
          _errorMessage = 'Uneti email je već registrovan';
        });
        return;
        }
      final name = _nameController.text;
      final user = widget.appService.register(name, email, password);
      widget.onLoginSuccess(user); // ako je register pravi novog usera, dodaje ga u listu i poziva onLoginSuccess callback sa tim userom
    } else{ // ako je postoji da li postoji user za taj email/password, ako ne greska, ako da ...
      final user = widget.appService.login(email, password);
      if(user == null){
        setState((){
          _errorMessage = 'Pogrešan email ili lozinka.';
        });
      } else {
        widget.onLoginSuccess(user);
      }
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            if(_isRegisterMode)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ime i Prezime'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            if(_errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isRegisterMode ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: (){
                setState((){
                  _isRegisterMode = !_isRegisterMode;
                  _errorMessage = null; // resetuje poruku o gresci kada se menja mod 
                });
              },
              child: Text(
                _isRegisterMode
                 ? 'Već imaš nalog? Prijavi se'
                 : 'Nemaš nalog? Registruj se'
              ),
            ),
            ],
          )
        )
      )
    );
  }
}