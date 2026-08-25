// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  // 1. ADICIONE O TOJSON NA CLASSE DEPENDENTE:
  Map<String, dynamic> toJson() => {
    'nome': _nome,
  };
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  // 2. CORRIJA O TOJSON DE FUNCIONARIO PARA MAPEAR OS DEPENDENTES:
  Map<String, dynamic> toJson() => {
    'nome': _nome,
    'dependentes': _dependentes.map((d) => d.toJson()).toList(), // <--- Correção aqui
  };
}

class EquipeProjeto {
  String nome;
  List<Funcionario> funcionarios;

  EquipeProjeto(this.nome, this.funcionarios);

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'funcionarios': funcionarios.map((f) => f.toJson()).toList(),
  };
}

void main() {
  Dependente dependente1 = new Dependente("dependente1");
  Dependente dependente2 = new Dependente("dependente2");
  Dependente dependente3 = new Dependente("dependente3");
  Dependente dependente4 = new Dependente("dependente4");

  Funcionario funcionario1 = new Funcionario("funcionario1", [
    dependente1,
    dependente2,
  ]);
  Funcionario funcionario2 = new Funcionario("funcionario2", [
    dependente3,
    dependente4,
  ]);

  List<Funcionario> funcionarios = [funcionario1, funcionario2];
  EquipeProjeto equipeProjeto = new EquipeProjeto("projeto1", funcionarios);

  // Agora vai funcionar perfeitamente!
  print(jsonEncode(equipeProjeto));
}
