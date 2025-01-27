import 'package:flutter/material.dart';

void main() {
  runApp(const Navegacao());
}

class Navegacao extends StatelessWidget {
  const Navegacao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.shopping_cart), text: "Produtos"),
                Tab(icon: Icon(Icons.account_box_rounded), text: "Clientes"),
                Tab(icon: Icon(Icons.account_balance_wallet), text: "Pedidos"),
              ],
            ),
            title: const Text('Atividade 05 PDM'),
          ),
          body: const TabBarView(
            children: [
              ItemList(
                icon: Icons.shopping_cart,
                title: "Produto",
              ),
              ItemList(
                icon: Icons.account_box_rounded,
                title: "Cliente",
              ),
              ItemList(
                icon: Icons.account_balance_wallet,
                title: "Pedido",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final IconData icon;
  final String title;

  const ItemList({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(icon),
          title: Text('$title ${index + 1}'),
        );
      },
    );
  }
}
