import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, QuerySnapshot;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mytask4/Data/models/product_model.dart';
import 'package:flutter_mytask4/cubit/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  List<ProductData> myList = [];

  Future<void> getProductsData() async {
    try {
      emit(GetProductsLoading());
      QuerySnapshot<Map<String, dynamic>> dataP =
          await FirebaseFirestore.instance.collection('products').get();

      for (var item in dataP.docs) {
        ProductData object1 = ProductData.formDocs(item);
        myList.add(object1);
      }
      emit(GetProductsDone());
    } catch (e) {
      emit(GetProductsError(error: e.toString()));
    }
  }
}
