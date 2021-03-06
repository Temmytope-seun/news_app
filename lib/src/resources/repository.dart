import 'dart:async';
import 'news_api_provider.dart';
import './news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source> [
    NewsApiProvider(),
    newsDbProvider,
  ];
  List<Cache> caches = <Cache> [
    newsDbProvider,
  ];


  Future<List<int>> fetchTopIds() {
    return sources[0].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for(source in sources){
      item = await source.fetchItem(id);
      if(item != null){
        break;
      }
    }
    for(var cache in caches) {
      if(cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }

clearCache() async {
  for (var cache in caches) {
    await cache.clear();
  }
}
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}

// class Repository {
//   NewsDbProvider dbProvider = NewsDbProvider();
//   NewsApiProvider apiProvider = NewsApiProvider();

//   Future<List<int>> fetchTopIds() {
//     return apiProvider.fetchTopIds();
//   }

//   Future<ItemModel> fetchItem(int id) async {
//     var item = await dbProvider.fetchItem(id);
//     if (item != null) {
//       return item;
//     }

//     item  = await apiProvider.fetchItem(id);
//     dbProvider.addItem(item);

//     return item;
//   }
// }