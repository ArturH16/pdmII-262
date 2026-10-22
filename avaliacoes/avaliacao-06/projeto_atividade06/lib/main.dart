import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //Cada widget define um método build() que é chamado automaticamente sempre que as circunstâncias do widget mudam, para que ele fique sempre atualizado.
    var appState = context.watch<MyAppState>(); //widget MyHomePage rastreia mudanças no estado atual do app usando o método watch.

    return Scaffold( //Cada método build precisa retornar um widget ou (o que é mais comum) uma árvore aninhada de widgets. Nesse caso, o widget de nível superior é Scaffold. Você não vai trabalhar com Scaffold neste codelab, mas ele é um widget útil e pode ser encontrado na grande maioria dos apps do Flutter do mundo real.
      body: Column( //A Column é um dos widgets de layout mais básicos do Flutter. Ela recebe qualquer número de filhos e os coloca em uma coluna de cima para baixo. Por padrão, a coluna coloca os filhos visualmente no topo. Em breve, você vai mudar isso para que a coluna fique centralizada.
        children: [
          Text('Hello, World!:'), //Você mudou o widget Text na primeira etapa.

          Text(appState.current.asLowerCase), //Este segundo widget Text usa o appState e acessa o único membro dessa classe, current (que é um WordPair). O WordPair fornece vários getters úteis, como asPascalCase ou asSnakeCase. Aqui, usamos asLowerCase, mas você pode alterar isso agora caso prefira uma das alternativas.

	  ElevatedButton(
		onPressed: () {
		   appState.getNext();
		},
		child: Text("Next"),
	      ),	
        ], //Observe como o código do Flutter faz um uso intenso de vírgulas à direita. Essa vírgula específica não precisa estar ali, porque children é o último (e também o único) membro dessa lista de parâmetros Column. No entanto, costuma ser uma boa ideia usar vírgulas à direita: elas facilitam adicionar mais membros e também servem como uma dica para o autoformatador do Dart colocar uma nova linha ali. Para mais informações, consulte Formatação de código (link em inglês).
      ),
    );
  }
}
