import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CuisinesWidget1 extends StatelessWidget {
  const CuisinesWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return (cuisineController.cuisineModel != null &&
              cuisineController.cuisineModel!.cuisines!.isEmpty)
          ? const SizedBox()
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TitleWidget(
                    title: 'cuisines'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getCuisineRoute())),
              ),
              SizedBox(
                height: 215, // Adjusted height for two rows
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall),
                  child: cuisineController.cuisineModel != null
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: (cuisineController
                                      .cuisineModel!.cuisines!.length /
                                  2)
                              .ceil(), // Divide items into 2 rows
                          itemBuilder: (context, index) {
                            return _buildCuisineColumn(
                                cuisineController, index, context);
                          },
                        )
                      : CuisineShimmer(cuisineController: cuisineController),
                ),
              ),
            ]);
    });
  }

  /// Builds a column of two cuisine items (one for each row)
  Widget _buildCuisineColumn(
      CuisineController cuisineController, int index, BuildContext context) {
    int firstItemIndex = index * 2;
    int secondItemIndex = firstItemIndex + 1;

    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      child: Column(
        children: [
          _buildCuisineItem(cuisineController, firstItemIndex, context),
          const SizedBox(height: 10), // Space between rows
          if (secondItemIndex <
              cuisineController.cuisineModel!.cuisines!.length)
            _buildCuisineItem(cuisineController, secondItemIndex, context),
        ],
      ),
    );
  }

  /// Builds a single cuisine item
  Widget _buildCuisineItem(
      CuisineController cuisineController, int index, BuildContext context) {
    return SizedBox(
      width: 80, // Reduced width for smaller items
      child: InkWell(
        onTap: () {
          Get.toNamed(RouteHelper.getCuisineRestaurantRoute(
              cuisineController.cuisineModel!.cuisines![index].id,
              cuisineController.cuisineModel!.cuisines![index].name));
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: CuisineImageWidget(
                fit: BoxFit.cover,
                backgroundColor: Colors.grey.shade50,
                image:
                    '${cuisineController.cuisineModel!.cuisines![index].imageFullUrl}',
                height: 80, // Reduced height
                width: 80, // Reduced width
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(
              cuisineController.cuisineModel!.cuisines![index].name!,
              style: robotoMedium.copyWith(fontSize: 10), // Adjusted font size
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CuisineShimmer extends StatelessWidget {
  final CuisineController cuisineController;
  const CuisineShimmer({super.key, required this.cuisineController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // Match the height of the main widget
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 5, // Adjust as needed for shimmer effect
              itemBuilder: (context, index) {
                return _buildShimmerItem(context);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 5, // Adjust as needed for shimmer effect
              itemBuilder: (context, index) {
                return _buildShimmerItem(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
      child: SizedBox(
        width: 80, // Match the width of cuisine items
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: cuisineController.cuisineModel == null,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
