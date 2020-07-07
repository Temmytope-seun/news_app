import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int itemId;
  
  NewsListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder:(context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot){
        if(!snapshot.hasData) {
          return LoadingContainer();
        }
          return FutureBuilder(
            future: snapshot.data[itemId],
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot){
              if (!itemSnapshot.hasData) {
                return LoadingContainer();
              }
              return buildTile(context, itemSnapshot.data);
            },
          );
      },);
   }

  Widget buildTile(context, ItemModel item) {
    return Column(
      children: [
         ListTile(
          onTap:() {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item.title),
          subtitle: Text('${item.score} votes'),
          trailing: Column(
            children: [
              Icon(Icons.comment),
              Text('${item.descendants}'),
            ]
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ],
    );
   
  }
}