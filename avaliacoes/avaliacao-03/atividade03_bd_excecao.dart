import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() async {
  // Inicializa o FFI (necessário para Dart puro/CLI)
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  // Define o caminho na raiz do projeto
  String dbPath = '${Directory.current.path}/alunos.db';
  Database? db;

  try {
    print('1. Conectando/Criando o banco de dados em: $dbPath');
    
    db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // 2. Criação da tabela tb_alunos
          try {
            print('   -> Banco novo detectado. Criando tabela tb_alunos...');
            await db.execute('''
              CREATE TABLE tb_alunos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                curso TEXT NOT NULL
              )
            ''');
            print('   -> Tabela tb_alunos criada com sucesso.');
          } catch (e) {
            print('Erro Crítico: Falha ao criar a tabela. Detalhes: $e');
          }
        },
      ),
    );

    // 3. Inserção de 3 alunos
    print('\n3. Inserindo alunos na tabela...');
    try {
      await db.insert('tb_alunos', {'nome': 'Ana Souza', 'curso': 'Engenharia'});
      await db.insert('tb_alunos', {'nome': 'Carlos Silva', 'curso': 'Computação'});
      await db.insert('tb_alunos', {'nome': 'Beatriz Lima', 'curso': 'Matemática'});
      print('   -> Alunos inseridos com sucesso.');
    } catch (e) {
      print('Erro: Falha ao inserir registros. Detalhes: $e');
    }

    // 4. Listagem do conteúdo da tabela
    print('\n4. Listando conteúdo da tb_alunos:');
    try {
      List<Map<String, dynamic>> alunos = await db.query('tb_alunos');
      
      if (alunos.isEmpty) {
        print('   -> A tabela está vazia.');
      } else {
        for (var aluno in alunos) {
          print('   [ID: ${aluno['id']}] Nome: ${aluno['nome']} | Curso: ${aluno['curso']}');
        }
      }
    } catch (e) {
      print('Erro: Falha ao consultar os dados. Detalhes: $e');
    }

  } catch (e) {
    print('\nErro fatal ao acessar o banco de dados: $e');
  } finally {
    // Garante que o banco seja fechado corretamente
    if (db != null) {
      try {
        await db.close();
        print('\nConexão encerrada com sucesso.');
      } catch (e) {
        print('\nErro ao fechar o banco de dados: $e');
      }
    }
  }
}