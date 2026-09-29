import 'dart:convert';
import 'dart:io';

void main() async {
  final client = HttpClient();
  
  try {
    // 1. Acessa os alunos registrados no Servidor Web
    final request = await client.getUrl(Uri.parse('http://localhost:8080/api/alunos'));
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final stringData = await response.transform(utf8.decoder).join();
      final data = jsonDecode(stringData);
      final List listaAlunos = data['dados'];
      
      print('ID   NOME            DISCIPLINA                MEDIA  FALTAS  MENSAGEM');
      print('-' * 85);
      
      // 2. Lista-os e testa as condições
      for (var aluno in listaAlunos) {
        final id = aluno['id'].toString();
        final nome = aluno['nome'].toString();
        final disciplina = aluno['disciplina'].toString();
        final media = aluno['media'] as double;
        final faltas = aluno['faltas'] as int;
        
        String mensagem;
        
        // Avaliação de aprovação/reprovação
        if (faltas > 20) {
          mensagem = "Reprovado por Faltas";
        } else if (media < 6.0) {
          mensagem = "Reprovado";
        } else {
          mensagem = "Aprovado";
        }
        
        // 3. Imprime no formato exigido
        // Correção: Interpolação de string ajustada com os cifrões correctos
        String pId = id.padRight(4);
        String pNome = nome.padRight(15);
        String pDisc = disciplina.padRight(25);
        String pMed = media.toString().padRight(6);
        String pFalt = faltas.toString().padRight(7);

  print(pId + ' ' + pNome + ' ' + pDisc + ' ' + pMed + ' ' + pFalt + ' ' + mensagem);
      }
    } else {
      print('Erro ao acessar a API. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Falha de conexão: $e. Certifique-se de que o servidor local está a correr.');
  } finally {
    client.close();
  }
}