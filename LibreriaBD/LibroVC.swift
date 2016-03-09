//
//  LibroVC.swift
//  LibreriaBD
//
//  Created by Fernando Renteria on 5/03/2016.
//  Copyright © 2016 Fernando Renteria. All rights reserved.
//

import UIKit
import CoreData

class LibroVC: UIViewController {

    // Variables
    @IBOutlet weak var isbnTxt: UITextField!
    @IBOutlet weak var tituloLbl: UILabel!
    @IBOutlet weak var portadaLibro: UIImageView!
    @IBOutlet weak var autoresLbl: UITextView!
    
    var contexto : NSManagedObjectContext? = nil

    @IBAction func agregarLibro(sender: UIButton) {
        let isbnStr = self.isbnTxt.text!
        if isbnStr == "" {
            alertaError("Agrega un isbn por favor.")
        } else {
            buscarLibro(isbnStr)
            //self.tableView.reloadData()
        }
        self.isbnTxt.text = nil
    }
    
    func alertaError(mensaje : String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alerta, animated: true, completion: nil)
        
    }
    
    func buscarLibro(isbn: String) {
        
        var tmpAutores: String = ""
        var tmpPortada : String = ""
        
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn" : isbn])
        
        do {
            let libroEntidadExistente = try self.contexto?.executeFetchRequest(peticion!)
            if (libroEntidadExistente?.count > 0) {
                return
            }
        
        } catch {
        
        }
        
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        let mainObject : String = "ISBN:" + isbn
        let url = NSURL(string: urls)
        let JSONData : NSData? = NSData(contentsOfURL: url!)
        if (JSONData == nil) {
            alertaError("Recurso no accesible.")
        }
        else {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(JSONData!, options:NSJSONReadingOptions.MutableLeaves)
                //let diccionario = json[mainObject] as! NSDictionary
                guard let diccionario :NSDictionary = json[mainObject] as? NSDictionary else {
                    alertaError("Recurso no accesible.")
                    // put in function
                    return
                }
                let titulo = diccionario["title"] as! NSString as String
                //let publishers = diccionario["publishers"] as! NSArray
                let autores = diccionario["authors"] as! NSArray
                for autor in autores {
                    let tmpAutor : String = autor["name"] as! NSString as String
                    tmpAutores = tmpAutores.stringByAppendingString(tmpAutor + "\n")
                }
                if diccionario["cover"] != nil {
                    let img = diccionario["cover"] as! NSDictionary
                    tmpPortada = img["medium"] as! NSString as String
                }
                
                self.tituloLbl.text = titulo
                self.autoresLbl.text = tmpAutores
                
                if (tmpPortada != "") {
                    let urlImg = NSURL(string: tmpPortada)
                    let imagenData = NSData(contentsOfURL: urlImg!)
                    portadaLibro.image = UIImage(data: imagenData!)
                }
                
               // libros.append(Libro(titulo: titulo, isbn: isbn, autores: tmpAutores, portada: tmpPortada))
                // Guardar Libro
                let nuevoLibro = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: self.contexto!)
                nuevoLibro.setValue(isbn, forKey: "isbn")
                nuevoLibro.setValue(tmpPortada, forKey: "portada")
                nuevoLibro.setValue(titulo, forKey: "titulo")
                nuevoLibro.setValue(tmpAutores, forKey: "autor")
                
                do {
                    try self.contexto?.save()
                } catch {
                
                }
                
                
                
            }
            catch let JSONError as NSError {
                let errorString : String = "\(JSONError)"
                alertaError(errorString)
                
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
