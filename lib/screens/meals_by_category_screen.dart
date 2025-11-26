import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import '../models/meal.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService api = ApiService();
  late Future<List<Meal>> _future;
  List<Meal> meals = [];
  bool searching = false;

  @override
  void initState() {
    super.initState();
    _future = api.fetchMealsByCategory(widget.category);
  }

  void _searchMeals(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searching = false;
        _future = api.fetchMealsByCategory(widget.category);
      });
      return;
    }

    searching = true;
    final results = await api.searchMeals(query.trim());

    // Filter results so they match the current category
    results.removeWhere((m) => m.category != widget.category);

    setState(() {
      meals = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.withOpacity(0.1), Colors.amber.withOpacity(0.1)],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchMeals,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                labelText: "Search meals...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: searching
                ? _buildGrid(meals)
                : FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return _buildGrid(snapshot.data!);
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildGrid(List<Meal> data) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
      ),
      itemCount: data.length,
      itemBuilder: (context, i) => MealCard(meal: data[i]),
    );
  }
}
