//
//  Libro.swift
//  LibreriaBD
//
//  Created by Fernando Renteria on 7/03/2016.
//  Copyright © 2016 Fernando Renteria. All rights reserved.
//

import Foundation

class Libro {
    var titulo : String = ""
    var isbn : String = ""
    var autores : String = ""
    var portada : String = ""
    
    init() {}
    
    init (titulo : String, isbn : String, autores : String, portada : String) {
        self.titulo = titulo
        self.isbn   = isbn
        self.autores = autores
        self.portada = portada
    }
    
}