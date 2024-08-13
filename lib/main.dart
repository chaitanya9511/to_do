import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/presentation/blocks/item_bloc.dart';
import 'package:to_do_list/presentation/screen/item_page.dart';

import 'data/data_sources/item_datasource.dart';
import 'domain/repository/item_repository.dart';



void main() {
  final itemRepository = ItemRepository(ItemDataSource());
  runApp(MyApp(itemRepository: itemRepository));
}

class MyApp extends StatelessWidget {
  final ItemRepository itemRepository;

  const MyApp({Key? key, required this.itemRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ItemBloc(itemRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ItemPage(),
      ),
    );
  }
}
