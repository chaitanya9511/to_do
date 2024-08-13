import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/item_model.dart';
import '../blocks/item_bloc.dart';


class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  ItemFilter _filter = ItemFilter.all;

  final TextEditingController _controller = TextEditingController();
  int? _editingItemId;

  void _toggleCompletion(ItemModel item) {
    context.read<ItemBloc>().add(UpdateItemEvent(ItemModel(id: item.id, name: item.name, completed: !item.completed)));
  }


  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(FetchItemsEvent());
  }

  void _showItemDialog({ItemModel? item}) {
    final TextEditingController _controller = TextEditingController(text: item?.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text( 'Add Task' ),
          content: Container(
height: 200,
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLength: null,
              expands: true,
              minLines: null,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your tasks',
              ),
              controller: _controller,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = _controller.text;
                if (name.isNotEmpty) {
                  if (item == null) {
                    context.read<ItemBloc>().add(AddItemEvent(ItemModel(name: name)));
                  } else {
                    context.read<ItemBloc>().add(UpdateItemEvent(ItemModel(id: item.id, name: name)));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addItem(String name) {
    if (_editingItemId == null) {
      final item = ItemModel(name: name);
      context.read<ItemBloc>().add(AddItemEvent(item));
    } else {
      final item = ItemModel(id: _editingItemId, name: name);
      context.read<ItemBloc>().add(UpdateItemEvent(item));
      _editingItemId = null;
    }
    _controller.clear();
  }

  void _editItem(ItemModel item) {
    _controller.text = item.name;
    _editingItemId = item.id;
  }

  void _deleteItem(int id) {
    context.read<ItemBloc>().add(DeleteItemEvent(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          DropdownButton<ItemFilter>(
            value: _filter,
            onChanged: (filter) {
              if (filter != null) {
                setState(() {
                  _filter = filter;
                });
                context.read<ItemBloc>().add(FilterItemsEvent(filter));
              }
            },
            items: const [
              DropdownMenuItem(
                value: ItemFilter.all,
                child: Text('All'),
              ),
              DropdownMenuItem(
                value: ItemFilter.pending,
                child: Text('Pending'),
              ),
              DropdownMenuItem(
                value: ItemFilter.completed,
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemsLoadedState) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text('No items available.'));
                  }
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.name),
                        leading: Checkbox(
                          value: item.completed,
                          onChanged: (value) => _toggleCompletion(item),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(item.id!),
                        ),
                      );
                    },
                  );
                } else if (state is ItemErrorState) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
