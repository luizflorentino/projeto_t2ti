/*******************************************************************************
Title: T2Ti ERP 3.0                                                                
Description: Controller relacionado à tabela [EMPRESA] 
                                                                                
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
                                                                                
@author Albert Eije (alberteije@gmail.com)                    
@version 1.0.0
*******************************************************************************/
package com.t2ti.retaguarda_sh.controller.cadastros;

import java.util.List;
import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.t2ti.retaguarda_sh.exception.ExcecaoGenericaServidorException;
import com.t2ti.retaguarda_sh.exception.RecursoNaoEncontradoException;
import com.t2ti.retaguarda_sh.exception.RequisicaoRuimException;
import com.t2ti.retaguarda_sh.model.cadastros.Cfop;
import com.t2ti.retaguarda_sh.model.transiente.Filtro;
import com.t2ti.retaguarda_sh.service.cadastros.CfopService;

@RestController
@RequestMapping(value = "/cfop", produces = "application/json;charset=UTF-8")
public class CfopController {

    @Autowired
    private CfopService service;

    @GetMapping
    public List<Cfop> consultarLista(@RequestParam(required = false) String filter) {
	try {
	    if (filter == null) {
		return service.consultarLista();
	    } else {
		Filtro filtro = new Filtro(filter);
		return service.consultarLista(filtro);
	    }
	} catch (Exception e) {
	    throw new ExcecaoGenericaServidorException(
		    "Erro no Servidor [Consultar Lista Cfop] - Exceção: " + e.getMessage());
	}
    }

    @GetMapping("/{codigo}")
    public Cfop consultarObjeto(@PathVariable Integer codigo) {
	try {
	    return service.consultarObjetoFiltro("CODIGO = '" + codigo + "'");
	} catch (NoSuchElementException e) {
	    throw new RecursoNaoEncontradoException("Registro não localizado [Consultar Objeto Cfop].");
	} catch (Exception e) {
	    throw new ExcecaoGenericaServidorException(
		    "Erro no Servidor [Consultar Objeto Cfop] - Exceção: " + e.getMessage());
	}
    }

    @PostMapping
    public Cfop inserir(@RequestBody Cfop objJson) {
	try {
	    return service.salvar(objJson);
	} catch (Exception e) {
	    throw new ExcecaoGenericaServidorException("Erro no Servidor [Inserir Cfop] - Exceção: " + e.getMessage());
	}
    }

    @PutMapping("/{codigo}")
    public Cfop atualizar(@RequestBody Cfop objJson, @PathVariable Integer codigo) {
	try {
	    if (!objJson.getCodigo().equals(codigo)) {
		throw new RequisicaoRuimException(
			"Objeto inválido [Alterar Cfop] - CODIGO do objeto difere do CODIGO da URL.");
	    }
	    Cfop cfop = service.salvar(objJson);
	    return cfop;
	} catch (Exception e) {
	    throw new ExcecaoGenericaServidorException("Erro no Servidor [Alterar Cfop] - Exceção: " + e.getMessage());
	}
    }

    @DeleteMapping("/{codigo}")
    public void excluir(@PathVariable Integer codigo) {
	try {
	    Cfop produtoCfop = service.consultarObjetoFiltro("CODIGO = '" + codigo + "'");
	    if (produtoCfop == null) {
		throw new RequisicaoRuimException(
			"Objeto inválido [Excluir Cfop] - CFOP não existe no banco com o CODIGO informado.");
	    } else {
		service.excluir(produtoCfop.getId());
	    }

	} catch (Exception e) {
	    throw new ExcecaoGenericaServidorException("Erro no Servidor [Excluir Cfop] - Exceção: " + e.getMessage());
	}
    }

}