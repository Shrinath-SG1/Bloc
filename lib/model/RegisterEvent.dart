import 'package:flutter_bloc/flutter_bloc.dart';

import '../Register.dart';

class FormScreenBloc extends Bloc<FormScreenEvent, FormScreenState>
    with ValidationMixin {
  FormScreenBloc();

  @override
  FormScreenState get initialState => FormScreenState();

  @override
  Stream<FormScreenState> mapEventToState(FormScreenEvent event) async* {
    if (event is FormScreenEventSubmit) {
      yield FormScreenState(isBusy: true);

      if (this.isFieldEmpty(event.email)) {
        yield FormScreenState(emailError: FieldError.Empty);
        return;
      }

      if (!this.validateEmailAddress(event.email)) {
        yield FormScreenState(emailError: FieldError.Invalid);
        return;
      }

      yield FormScreenState(submissionSuccess: true);
    }
  }
}