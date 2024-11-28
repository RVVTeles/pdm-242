// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }
  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes

  var dependente1 = Dependente("João");
  var dependente2 = Dependente("Maria");
  var dependente3 = Dependente("José");
  var dependente4 = Dependente("Paulo");
  var dependente5 = Dependente("Mauricio");
  var dependente6 = Dependente("Lucas");
  var dependente7 = Dependente("Herbert");
  var dependente8 = Dependente("Felipe");
  var dependente9 = Dependente("Carlos");
  var dependente10 = Dependente("Tales");

  // 2. Criar varios objetos Funcionario

  var funcionario1 = Funcionario("Fabricio", []);
  var funcionario2 = Funcionario("Renata", []);
  var funcionario3 = Funcionario("Oblong", []);
  var funcionario4 = Funcionario("Querbert", []);

  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios

  funcionario1 = Funcionario("Fabricio", [dependente1, dependente2, dependente3, dependente4 ]);
  funcionario2 = Funcionario("Renata", [dependente1, dependente2, dependente3, dependente4]);
  funcionario3 = Funcionario("Oblong", [dependente5, dependente6]);
  funcionario4 = Funcionario("Querbert", [dependente7, dependente8, dependente9, dependente10]);

  // 4. Criar uma lista de Funcionarios

  var listaFuncionarios = [funcionario1, funcionario2, funcionario3, funcionario4];

  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario

  var equipeProjeto = EquipeProjeto("Projeto PDM 2024", listaFuncionarios);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  String projetoJson = jsonEncode(equipeProjeto.toJson());
print(projetoJson);
}



