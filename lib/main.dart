import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService {
  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);

  var chaves = ["name", "sector", "price"];
  var colunas = ["Nome", "Setor", "Preço"];

  void carregar(index) {
    var funcoes = [
      carregarCasa,
      carregarMesa,
      carregarBanho,
    ];

    funcoes[index]();
  }

  void columnCasa() {
    chaves = ["name", "sector", "price"];
    colunas = ["Nome 1", "Setor 1", "Preço 1"];
  }

  void columnMesa() {
    chaves = ["name", "sector", "price"];
    colunas = ["Nome 2", "Setor 2", "Preço 2"];
  }

  void columnBanho() {
    chaves = ["name", "sector", "price"];
    colunas = ["Nome 3", "Setor 3", "Preço 3"];
  }

  void carregarCasa() {
    columnCasa();

    tableStateNotifier.value = [
      {"name": "Tapete para sala", "sector": "Casa", "price": "R\$34,99"},
      {"name": "Jogo de cama Queen", "sector": "Casa", "price": "R\$119,90"},
      {"name": "Cortina blackout", "sector": "Casa", "price": "R\$79,99"},
      {"name": "Tapete para sala", "sector": "Casa", "price": "R\$34,99"},
      {"name": "Vaso de plantas decorativo", "sector": "Casa", "price": "R\$69,90"},
      {"name": "Capa de almofada", "sector": "Casa", "price": "R\$19,99"},
      {"name": "Luminária de mesa", "sector": "Casa", "price": "R\$59,90"},
      {"name": "Porta-treco de cerâmica", "sector": "Casa", "price": "R\$19,90"},
      {"name": "Travesseiro de plumas", "sector": "Casa", "price": "R\$89,99"},
      {"name": "Almofada decorativa", "sector": "Casa", "price": "R\$49,90"},
      {"name": "Porta-retrato decorativo", "sector": "Casa", "price": "R\$29,90"},
    ];
  }

  void carregarMesa() {
    columnMesa();

    tableStateNotifier.value = [
      {"name": "Toalha de mesa florida", "sector": "Mesa", "price": "R\$49,99"},
      {"name": "Conjunto de panelas", "sector": "Mesa", "price": "R\$189,99"},
      {"name": "Toalha de mesa xadrez", "sector": "Mesa", "price": "R\$39,99"},
      {"name": "Aparelho de jantar", "sector": "Mesa", "price": "R\$299,90"},
      {"name": "Jogo americano de tecido", "sector": "Mesa", "price": "R\$19,99"},
      {"name": "Kit de talheres", "sector": "Mesa", "price": "R\$29,99"},
      {"name": "Pano de prato estampado", "sector": "Mesa", "price": "R\$9,99"},
    ];
  }

  void carregarBanho() {
    columnBanho();

    tableStateNotifier.value = [
      {"name": "Kit toalhas corpo/rosto", "sector": "Banho", "price": "R\$59,00"},
      {"name": "Jogo de banho bordado", "sector": "Banho", "price": "R\$79,90"},
      {"name": "Espelho de parede", "sector": "Banho", "price": "R\$99,99"},
      {"name": "Kit de toalhas para lavabo", "sector": "Banho", "price": "R\$29,90"},
      {"name": "Tapete para banheiro", "sector": "Banho", "price": "R\$24,99"},
    ];
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Decorações!"),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.8),
                  Colors.green.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  "https://i.imgur.com/QCDr6gq.jpeg",
                ),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTableWidget(
                      jsonObjects: value,
                      propertyNames: dataService.chaves,
                      columnNames: dataService.colunas,
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        )
    );
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    
    var state = useState(1);
    List<String> buttonNames = ["Casa", "Mesa", "Banho"];
    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        itemSelectedCallback(index);
        print('Botão ${buttonNames[index]} foi tocado.');
        print('no build da classe ${runtimeType}');
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Casa",
          icon: Icon(Icons.house,),
        ),
        BottomNavigationBarItem(
            label: "Mesa", icon: Icon(Icons.table_bar)),
        BottomNavigationBarItem(
            label: "Banho", icon: Icon(Icons.bathtub))
      ]
    );
  }
}


class DataTableWidget extends StatelessWidget {

  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget( {this.jsonObjects = const [], this.columnNames = const ["Nome","Setor","Preço"], this.propertyNames= const ["name", "sector", "price"]});

  @override

  Widget build(BuildContext context) {

    return DataTable(
      columns: columnNames.map( 
        (name) => DataColumn(
          label: Expanded(
            child: Text(name, style: TextStyle(fontWeight: FontWeight.bold))
          )
        )
    ).toList(),
      rows: jsonObjects.map( 
        (obj) => DataRow(
            cells: propertyNames.map(
              (propName) => DataCell(Text(obj[propName]))
            ).toList()
          )
        ).toList());
  }
}