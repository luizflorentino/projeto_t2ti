/*******************************************************************************
Title: T2Ti ERP 3.0                                                                
Description: Service relacionado à tabela [EMPRESA] 
                                                                                
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
package com.t2ti.retaguarda_sh.service.cadastros;

import java.time.Instant;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.t2ti.retaguarda_sh.model.cadastros.Cfop;
import com.t2ti.retaguarda_sh.model.transiente.Filtro;
import com.t2ti.retaguarda_sh.repository.cadastros.CfopRepository;

@Service
public class CfopService {

    @Autowired
    private CfopRepository repository;

    @PersistenceContext
    private EntityManager entityManager;

    public List<Cfop> consultarLista() {
	return repository.findAll();
    }

    @SuppressWarnings("unchecked")
    public List<Cfop> consultarLista(Filtro filtro) {
	String sql = "select * from CFOP where " + filtro.getWhere();
	Query query = entityManager.createNativeQuery(sql, Cfop.class);
	return query.getResultList();
    }

    public Cfop consultarObjetoFiltro(String filtro) {
	String sql = "select * from CFOP where " + filtro;
	Query query = entityManager.createNativeQuery(sql, Cfop.class);
	if (query.getResultList().size() > 0) {
	    return (Cfop) query.getResultList().get(0);
	} else {
	    return null;
	}
    }

    public Cfop consultarObjeto(Integer id) {
	return repository.findById(id).get();
    }

    public Cfop salvar(Cfop objeto) {
	Cfop produtoCfop = consultarObjetoFiltro("CODIGO = '" + objeto.getCodigo() + "'");
	if (produtoCfop != null) {
	    objeto.setId(produtoCfop.getId());
	}
	objeto.setAtualizadoEm(Instant.now());

	return repository.save(objeto);
    }

    public void excluir(Integer id) {
	Cfop objeto = consultarObjeto(id);
	repository.delete(objeto);
    }

}