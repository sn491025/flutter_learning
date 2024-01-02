import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapp/bloc.dart';

sealed class CounterEvent {}

class BlocCounterIncrementPressed extends CounterEvent {}

class BlocCounterDecrementPressed extends CounterEvent {}

class Counter extends Bloc<CounterEvent, int> {
  Counter() : super(0) {
    on<BlocCounterIncrementPressed>((event, emit) => emit(state + 1));
    on<BlocCounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}
