import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  final String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$base/categories.php');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final js = json.decode(res.body);
      final List data = js['categories'] ?? [];
      return data.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$base/filter.php?c=$category');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final js = json.decode(res.body);
      final List data = js['meals'] ?? [];
      return data.map((e) => Meal.fromJson(e)).toList();
    }

    throw Exception('Failed to load meals');
  }

Future<Meal> lookupMealById(String id) async {
  final url = Uri.parse('$base/lookup.php?i=$id');
  final res = await http.get(url);

  if (res.statusCode == 200) {
    final js = json.decode(res.body);
    final data = js['meals'][0];
    return Meal.fromJson(data);
  }

  throw Exception("Failed to load meal detail");
}


  Future<Meal> fetchRandomMeal() async {
    final url = Uri.parse('$base/random.php');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final js = json.decode(res.body);
      final List data = js['meals'] ?? [];
      return Meal.fromJson(data.first);
    }

    throw Exception('Failed to load random meal');
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse('$base/search.php?s=$query');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final js = json.decode(res.body);
      final List data = js['meals'] ?? [];
      return data.map((e) => Meal.fromJson(e)).toList();
    }

    throw Exception('Failed to search meals');
  }
}

