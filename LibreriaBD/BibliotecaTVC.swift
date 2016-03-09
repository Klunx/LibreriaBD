//
//  BibliotecaTVC.swift
//  LibreriaBD
//
//  Created by Fernando Renteria on 5/03/2016.
//  Copyright © 2016 Fernando Renteria. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"


class BibliotecaTVC: UITableViewController {
    
    var contexto : NSManagedObjectContext? = nil
    var libros = [Libro]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        refresh(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh(self)
    }
    
    func refresh(sender: AnyObject) {
        // Reload the data
        libros = [Libro]()
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestTemplateForName("petLibros")
        
        do {
            let librosEntidad = try self.contexto?.executeFetchRequest(peticion!)
            for libro in librosEntidad! {
                let titulo = libro.valueForKey("titulo") as! String
                let isbn = libro.valueForKey("isbn") as! String
                let autor = libro.valueForKey("autor") as! String
                let portada = libro.valueForKey("portada") as! String
                libros.append(Libro(titulo: titulo, isbn: isbn, autores: autor, portada: portada))
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.libros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = libros[indexPath.row].titulo

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "bookDetail" {
            let ctrl = segue.destinationViewController as! DetailVC
            let indexPath = tableView.indexPathForSelectedRow
            let libro = libros[indexPath!.row]
            
            ctrl.libroDetail = libro
        }

    }
    

}
