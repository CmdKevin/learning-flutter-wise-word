import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test Drive',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 135, 143, 47))
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];
  void getNext() {
    current = WordPair.random();
    history.add(current); //untuk menambahkan setiap kata ag tergenerate ke historypage
    notifyListeners();
  }

  var favorites = <WordPair>[];
   

  void toogleFavorite() {
  if (favorites.contains(current)) {
    favorites.remove(current);
  } else {
    favorites.add(current);
  }
   
  notifyListeners();
  }

  void removeFromFavorites(WordPair wordPair) {
    favorites.remove(wordPair); // untuk menghapus kata dari favorite yang di klik
    notifyListeners();
  }

  void removeAllHistory() {
    history.clear(); // untuk menghapus kata dari favorite yang di klik
    notifyListeners();
  }
}  


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // add this property.

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
      case 1:
        page = const FavoritePage();
      case 2:
        page = const HistoryPage();
      default:
        page = const Placeholder();
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home'),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite'),
          NavigationDestination(
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'History'),
        ],
      ),  
      appBar: AppBar(
        title: const Text('Test Drive'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(child: page,),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("My Random Idea:"),
          BigCard(pair: pair),
          SizedBox(height: 20,),
          const Divider(),
          const Text(
            "Find!!",
            style: TextStyle(color: Colors.greenAccent, fontSize: 25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(onPressed: () {
                appState.toogleFavorite();

                ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Fav/UnFav word ${appState.current}'),
                  ),
                );
              },
                icon:  Icon(icon),
                label: const Text("Favorite"),
              ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: const Text('Give it'),
          ),
            ],
          ),
        ],
      ),
    );
  }
}

class 
BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 30.0
    );

    return Card(
      color: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pair.asLowerCase,
          style: style,
        ),
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key});

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    return Container(
      child: ListView(
        children: [
          Text('You have ${appState.favorites.length} Favorite Words: ',
          style: Theme.of(context).textTheme.titleLarge),

          ...appState.favorites.map(
            (wp)=> ListTile(
              title: Text(wp.asCamelCase),
              onTap: (){
                ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('My Favorite Word is ${wp.asCamelCase}'),
                  ),
                );           
                appState.removeFromFavorites(wp); // remove favorites yang di klik    
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key});

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    return Scaffold(
      body: Container(      
        child: ListView(
          children: [
            Text('You have ${appState.history.length} History of Random Words: ',
            style: Theme.of(context).textTheme.titleLarge),
        
            ...appState.history.map(
              (wp)=> ListTile(
                title: Text(wp.asCamelCase),
                onTap: (){
                  ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('It`s ${wp.asCamelCase}'),
                    ),
                  );                
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: 
      ElevatedButton.icon(
            label: Text("Delete History"),
            icon: Icon(Icons.delete),
            onPressed: () {
                appState.removeAllHistory();

                ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('History Deleted'),
                  ),
                );
              },
          ),
    );
  }
}