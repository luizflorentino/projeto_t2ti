import 'package:moor/moor.dart';

import 'package:pegasus_pdv/src/database/database.dart';

class MigracaoParaSchema5 extends DatabaseAccessor<AppDatabase> {

  final AppDatabase db;
  MigracaoParaSchema5(this.db) : super(db);

  // pega referencia das tabelas existentes
  $CfopsTable get cfops => attachedDatabase.cfops;
  
  // pega referencia das novas tabelas
  $NfcePlanoPagamentosTable get	nfcePlanoPagamentos => attachedDatabase.nfcePlanoPagamentos;

  Future<void> migrarParaSchema5(Migrator m, int from, int to) async {
    // adicionando novas colunas em tabelas existentes
    await m.addColumn(cfops, cfops.atualizadoEm);

    // criando novas tabelas
    await m.createTable(nfcePlanoPagamentos);        
  }
}