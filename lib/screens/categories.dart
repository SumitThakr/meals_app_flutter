import 'package:flutter/material.dart';
import 'package:meals_app_flutter/data/dummy_data.dart';
import 'package:meals_app_flutter/models/category.dart';
import 'package:meals_app_flutter/screens/meals.dart';
import 'package:meals_app_flutter/widgets/category_grid_item.dart';

import '../models/meal.dart';
import '../providers/filters_provider.dart';
import '../widgets/main_drawer.dart';
import 'filters.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(
      {super.key, required this.availableMeals, required this.title});

  final List<Meal> availableMeals;
  final String title;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  ///For Drawer Navigation start ///
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  ///For Drawer Navigation end ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        child: GridView(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            for (final category in availableCategories)
              CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              )
          ],
        ),
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut),
          ),
          child: child,
        ),
      ),
    );
  }
}
