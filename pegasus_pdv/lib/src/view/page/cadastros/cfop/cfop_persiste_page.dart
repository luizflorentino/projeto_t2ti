/*
Title: T2Ti ERP 3.0                                                                
Description: PersistePage relacionada à tabela [CFOP] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2021 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com                                                   
                                                                                
@author Luiz Florentino (luizflorentino@gmail.com)                    
@version 1.0.0
*******************************************************************************/
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import 'package:pegasus_pdv/src/database/database.dart';

import 'package:pegasus_pdv/src/infra/infra.dart';
import 'package:pegasus_pdv/src/model/cadastros/cfop_model.dart';
import 'package:pegasus_pdv/src/service/cadastros/cfop_service.dart';

import 'package:pegasus_pdv/src/view/shared/view_util_lib.dart';
import 'package:pegasus_pdv/src/view/shared/caixas_de_dialogo.dart';
import 'package:pegasus_pdv/src/infra/atalhos_desktop_web.dart';
import 'package:pegasus_pdv/src/view/shared/botoes.dart';
import 'package:pegasus_pdv/src/view/shared/widgets_input.dart';

class CfopPersistePage extends StatefulWidget {
  final Cfop cfop;
  final String title;
  final String operacao;

  const CfopPersistePage({Key key, this.cfop, this.title, this.operacao})
      : super(key: key);

  @override
  _CfopPersistePageState createState() => _CfopPersistePageState();
}

class _CfopPersistePageState extends State<CfopPersistePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  bool _formFoiAlterado = false;

  Map<LogicalKeySet, Intent> _shortcutMap;
  Map<Type, Action<Intent>> _actionMap;
  final _foco = FocusNode();

  Cfop cfop;

  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(
      gutterSize: Constantes.flutterBootstrapGutterSize,
    );

    _shortcutMap = getAtalhosPersistePage();

    _actionMap = <Type, Action<Intent>>{
      AtalhoTelaIntent: CallbackAction<AtalhoTelaIntent>(
        onInvoke: _tratarAcoesAtalhos,
      ),
    };
    cfop = widget.cfop;
    _foco.requestFocus();
  }

  void _tratarAcoesAtalhos(AtalhoTelaIntent intent) {
    switch (intent.type) {
      case AtalhoTelaType.excluir:
        _excluir();
        break;
      case AtalhoTelaType.salvar:
        _salvar();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      actions: _actionMap,
      shortcuts: _shortcutMap,
      child: Focus(
        autofocus: true,
        child: Scaffold(
          drawerDragStartBehavior: DragStartBehavior.down,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.title),
            actions: widget.operacao == 'I'
                ? getBotoesAppBarPersistePage(
                    context: context,
                    salvar: _salvar,
                  )
                : getBotoesAppBarPersistePageComExclusao(
                    context: context, salvar: _salvar, excluir: _excluir),
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              onWillPop: _avisarUsuarioFormAlterado,
              child: Scrollbar(
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  child: BootstrapContainer(
                    fluid: true,
                    decoration: BoxDecoration(color: Colors.white),
                    padding: Biblioteca.isTelaPequena(context) == true
                        ? ViewUtilLib.paddingBootstrapContainerTelaPequena
                        : ViewUtilLib
                            .paddingBootstrapContainerTelaGrande, // children: [
                    children: <Widget>[
                      Divider(
                        color: Colors.white,
                      ),
                      BootstrapRow(
                        height: 60,
                        children: <BootstrapCol>[
                          BootstrapCol(
                            sizes: 'col-12 col-md-8',
                            child: Padding(
                              padding:
                                  Biblioteca.distanciaEntreColunasQuebraLinha(
                                      context),
                              child: TextFormField(
                                focusNode: _foco,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator:
                                    ValidaCampoFormulario.validarNumerico,
                                maxLength: 4,
                                maxLines: 1,
                                initialValue: cfop?.codigo?.toString(),
                                decoration: getInputDecoration(
                                    'Conteúdo para o campo Código',
                                    'Código',
                                    true,
                                    paddingVertical: 18),
                                onSaved: (String value) {},
                                onChanged: (value) {
                                  cfop =
                                      cfop.copyWith(codigo: int.parse(value));
                                  _formFoiAlterado = true;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      BootstrapRow(
                        height: 60,
                        children: <BootstrapCol>[
                          BootstrapCol(
                            sizes: 'col-12 col-md-6',
                            child: Padding(
                              padding:
                                  Biblioteca.distanciaEntreColunasQuebraLinha(
                                      context),
                              child: TextFormField(
                                validator: ValidaCampoFormulario
                                    .validarObrigatorioAlfanumerico,
                                maxLength: 250,
                                maxLines: 1,
                                initialValue: cfop?.descricao ?? '',
                                decoration: getInputDecoration(
                                    'Conteúdo para o campo Descrição',
                                    'Descrição',
                                    false),
                                onSaved: (String value) {},
                                onChanged: (text) {
                                  cfop = cfop.copyWith(descricao: text);
                                  _formFoiAlterado = true;
                                },
                              ),
                            ),
                          ),
                          BootstrapCol(
                            sizes: 'col-12 col-md-6',
                            child: Padding(
                              padding:
                                  Biblioteca.distanciaEntreColunasQuebraLinha(
                                      context),
                              child: TextFormField(
                                maxLength: 250,
                                maxLines: 1,
                                initialValue: cfop?.aplicacao ?? '',
                                decoration: getInputDecoration(
                                    'Conteúdo para o campo Aplicação',
                                    'Aplicação',
                                    false),
                                onSaved: (String value) {},
                                onChanged: (text) {
                                  cfop = cfop.copyWith(aplicacao: text);
                                  _formFoiAlterado = true;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = AutovalidateMode.always;
      showInSnackBar(Constantes.mensagemCorrijaErrosFormSalvar, context);
    } else {
      gerarDialogBoxConfirmacao(context, Constantes.perguntaSalvarAlteracoes,
          () async {
        form.save();
        CfopModel cfopModel;
        CfopService servico = CfopService();
        gerarDialogBoxEspera(context);

        if (widget.operacao == 'I') {
          // insere no banco local
          final pId = await Sessao.db.cfopDao.inserir(cfop);
          final c = await Sessao.db.cfopDao.consultarObjeto(pId);
          // insere no servidor
          cfopModel = await servico.inserir(CfopModel.fromDB(c));
        } else {
          // update no banco local
          await Sessao.db.cfopDao.alterar(cfop);
          final c = await Sessao.db.cfopDao.consultarObjeto(cfop.id);
          // update no servidor
          cfopModel = await servico.alterar(CfopModel.fromDB(c));
        }
        Sessao.fecharDialogBoxEspera(context);

        if (cfopModel == null) {
          showInSnackBar(
              'Ocorreu um problema ao tentar salvar o CFOP no Servidor.',
              context,
              corFundo: Colors.red);
        }

        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _avisarUsuarioFormAlterado() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formFoiAlterado) return true;

    return await gerarDialogBoxFormAlterado(context);
  }

  void _excluir() async {
    gerarDialogBoxExclusao(context, () async {
      CfopModel cfopModel = CfopModel.fromDB(cfop);
      CfopService servico = CfopService();
      gerarDialogBoxEspera(context);

      // exclui do banco local
      await Sessao.db.cfopDao.excluir(widget.cfop);
      // exclui do servidor
      cfopModel = await servico.excluir(cfopModel);

      Sessao.fecharDialogBoxEspera(context);

      if (cfopModel != null) {
        showInSnackBar(
            'Ocorreu um problema ao tentar excluir o CFOP no Servidor.',
            context,
            corFundo: Colors.red);
      }

      Navigator.of(context).pop();
    });
  }
}
