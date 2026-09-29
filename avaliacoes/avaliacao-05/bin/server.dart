import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class Aluno {
  final int id;
  final String nome;
  final double media;
  final String disciplina;
  final int faltas;

  const Aluno({
    required this.id,
    required this.nome,
    required this.media,
    required this.disciplina,
    required this.faltas
  });

  Map toJson() => {
        'id': id,
        'nome': nome,
        'media': media,
        'disciplina': disciplina,
        'faltas': faltas
      };

  static Aluno fromJson(Map json) => Aluno(
        id: json['id'] as int,
        nome: json['nome'] as String,
        media: (json['media'] as num).toDouble(),
        disciplina: json['disciplina'] as String,
        faltas: json["faltas"] as int
      );
}

final List alunos = [
  const Aluno(
    id: 1,
    nome: 'Ana Souza',
    media: 8.7,
    disciplina: "POO",
    faltas: 10
  ),
  const Aluno(
    id: 2,
    nome: 'Bruno Lima',
    media: 7.9,
    disciplina: "Fun Pro II",
    faltas: 2
  ),
  const Aluno(
    id: 3,
    nome: 'Carla Mendes',
    media: 9.2,
    disciplina: "Cálculo II",
    faltas: 100
  ),
  const Aluno(
    id: 4,
    nome: 'Diego Alves',
    media: 6.8,
    disciplina: "PW I",
    faltas: 0
  ),
];

Response jsonResponse(
  Object body, {
  int status = 200,
}) {
  return Response(
    status,
    body: jsonEncode(body),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

Response _listarAlunos(Request request) {
  return jsonResponse({
    'total': alunos.length,
    'dados': alunos.map((aluno) => aluno.toJson()).toList(),
  });
}

Response _buscarAluno(Request request, String id) {
  final idNumerico = int.tryParse(id);
  if (idNumerico == null) {
    return jsonResponse({'erro': 'O id deve ser um número inteiro.'}, status: 400);
  }

  final aluno = alunos.where((item) => item.id == idNumerico).firstOrNull;
  if (aluno == null) {
    return jsonResponse({'erro': 'Aluno não encontrado.'}, status: 404);
  }

  return jsonResponse(aluno.toJson());
}

Future _criarAluno(Request request) async {
  try {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map;
    final novoAluno = Aluno.fromJson({
      ...json,
      'id': alunos.isEmpty ? 1 : alunos.last.id + 1,
    });

    alunos.add(novoAluno);
    return jsonResponse(novoAluno.toJson(), status: 201);
  } catch (_) {
    return jsonResponse({'erro': 'Dados inválidos.'}, status: 400);
  }
}

Router createRouter() {
  final router = Router()
    ..get('/api/alunos', _listarAlunos)
    // Correção: Adicionado o  de volta na rota
    ..get('/api/alunos/', _buscarAluno) 
    ..post('/api/alunos', _criarAluno);
  return router;
}

Future main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final address = InternetAddress.anyIPv4;

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(createRouter().call);

  final server = await shelf_io.serve(handler, address, port);
  // Correção: Interpolação de string ajustada para usar ${ }
  print('Servidor iniciado em http://\({server.address.host}:\){server.port}'); 
}