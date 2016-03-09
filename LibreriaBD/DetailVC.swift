//
//  DetailVC.swift
//  LibreriaBD
//
//  Created by Fernando Renteria on 8/03/2016.
//  Copyright © 2016 Fernando Renteria. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var libroDetail = Libro()

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPortada: UIImageView!
    @IBOutlet weak var lblAutores: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = self.libroDetail.titulo
        self.lblAutores.text = self.libroDetail.autores
        if (self.libroDetail.portada != "") {
            let urlImg = NSURL(string: self.libroDetail.portada)
            let imagenData = NSData(contentsOfURL: urlImg!)
            imgPortada.image = UIImage(data: imagenData!)
        }


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
