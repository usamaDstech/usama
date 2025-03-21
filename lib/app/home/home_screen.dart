import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:usama/app/provider/home_provider.dart';
import 'package:usama/app/utils/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xfff0f6f8)
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.fromLTRB(16,4,4,4),
          child: SvgPicture.asset(Images.drawer),
        ),
        leadingWidth: 70,
        centerTitle: true,
        title: SvgPicture.asset(Images.logo3),
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xfff0f6f8)
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(Images.search)),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            _buildCategoryChips(provider),
            SizedBox(
                height: 115,
                child: _buildCategoryIcons(provider)),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text("Products",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            ),
            Expanded(child: _buildProductGrid(provider)),
            _buildFreeShippingBanner(),
                    ],
                  ),
          ),
    );
  }

  Widget _buildCategoryChips(HomeProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          ...provider.categories.map((category) {
            int productCount = provider.getCategoryProductCount(category);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  ChoiceChip(
                    label: Text(category.name ?? ""),
                    selectedColor: Colors.white,
                    backgroundColor: Colors.white,
                    selectedShadowColor: Colors.white,
                    showCheckmark: false,
                    selected: provider.selectedCategory == category,
                    onSelected: (val) {
                      provider.setSelectedCategory(category);
                    },

                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: provider.selectedCategory == category
                            ? const Color(0xffB9202B)
                            : const Color(0xffD9E4E8),
                        width: 2.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: const Color(0xffD9E4E8)),
                          color: Colors.white
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Text("$productCount",style: const TextStyle(fontSize: 10),),
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }



  Widget _buildCategoryIcons(HomeProvider provider) {
    if (provider.selectedCategory == null) {
      return const Center(child: Text("Select a category"));
    }

    final subCategories = provider.selectedCategory!.subCategory ?? [];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];
        final isSelected = provider.selectedSubCategory == subCategory;
        final quantity = provider.getTotalSubCategoryQuantity(subCategory);
        return GestureDetector(
          onTap: () => provider.setSelectedSubCategory(subCategory,int.parse(provider.selectedCategory?.id.toString()??"0")),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: isSelected?Colors.red.shade900:Colors.grey.shade300,width:isSelected? 3:2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(subCategory.image ?? ""),
                          radius: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: isSelected?Colors.red.shade900:const Color(0xffD9E4E8)),
                            color: Colors.white
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Text("$quantity",style: const TextStyle(fontSize: 10),),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(subCategory.name ?? "", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(HomeProvider provider) {
    final products = provider.products;

    if (products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }



  Widget _buildProductCard(product) {
    log(product.name.toString());
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: Image.network(product.image ?? "", height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              if (product.discountPercentage != null && product.discountPercentage! > 0)
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    color: Colors.green,
                    child: Text("-${product.discountPercentage}%", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Category", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text("\$${product.price}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    if (product.discountPercentage != null && product.discountPercentage! > 0)
                      Text("\$${product.price + (product.price * (product.discountPercentage! / 100))}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  ],
                ),
                const SizedBox(height: 5),
                product.quantity! > 0
                    ? const Text("In Stock", style: TextStyle(color: Colors.green))
                    : Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(5)),
                  child: const Text("Sold Out", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeShippingBanner() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xff17A2B8), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white
                ),
                child: Image.asset(Images.rider, height: 40, width: 40)),
            const SizedBox(width: 20),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Free Shipping Over \$0", style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.bold)),
                Text("Free returns and exchange", style: TextStyle(color: Colors.white)),
              ],
            )),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SvgPicture.asset(Images.call),
            )
          ],
        ),
      ),
    );
  }
}