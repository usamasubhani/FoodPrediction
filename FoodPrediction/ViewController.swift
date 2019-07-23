//
//  ViewController.swift
//  Food101Prediction
//
//  Created by Philipp Gabriel on 21.06.17.
//  Copyright © 2017 Philipp Gabriel. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentage: UILabel!
    let recipe = [Recipe]()
    let appID = "8fef80d9"
    let apiKey = "6844f08e11bfed0d4ece7c3b8d0dc65e"
    override func viewDidLoad() {
        super.viewDidLoad()
        let url : String = "https://api.edamam.com/search?q=pasta&app_id=\(appID)&app_key=\(apiKey)&from=0&to=2"
        let recipeUrl: URL = URL(string: url)!
        let task = URLSession.shared.dataTask(with: recipeUrl) { (data,response,error) in
            if error == nil {
                print("well we got this far")
                print(data?.description ?? "what data")
                let stringResponse: String = String(data: data!, encoding: .utf8)!
                print(stringResponse)
                print(response ?? "no data")
            } else {
                fatalError(error.debugDescription)
            }
            
        }
        task.resume()
//        let request : NSMutableURLRequest = NSMutableURLRequest()
//        request.url = NSURL(string: url)! as URL
//        request.httpMethod = "GET"
//
//        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) -> Void in
//            var error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
//            do {
//                let jsonResult: NSDictionary! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                if (jsonResult != nil) {
//                    // process jsonResult
//                } else {
//                    // couldn't load JSON, look at error
//                }
//            } catch {
//                fatalError(" ")
//            }
//
//        })
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self

        alert.addAction(UIAlertAction(title: "Choose Image", style: .default) { _ in
            imagePickerView.sourceType = .photoLibrary
            self.present(imagePickerView, animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Take Image", style: .default) { _ in
            imagePickerView.sourceType = .camera
            self.present(imagePickerView, animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        dismiss(animated: true, completion: nil)

        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }

        processImage(image)
    }

    func processImage(_ image: UIImage) {
        let model = Food101()
        let size = CGSize(width: 299, height: 299)

        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }

        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }

        let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)

        imageView.image = image
        percentage.text = "\(result.classLabel) - \(converted) %"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
