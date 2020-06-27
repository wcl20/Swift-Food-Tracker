//
//  MealViewController.swift
//  FoodTracker
//
//  Created by LeeAlvis on 21/6/2020.
//

import os.log
import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    var meal: Meal?
    @IBOutlet weak var mealTextField: UITextField!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealRating: RatingController!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set view controller as the delegate of text field
        mealTextField.delegate = self
        // Check unwrap optional meal
        if let meal = meal {
            navigationItem.title = meal.name
            mealTextField.text = meal.name
            mealImageView.image = meal.photo
            mealRating.rating = meal.rating
        }
        // Update save button state
        let text = mealTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Navigations
    
    // Gets called when user taps 'Cancel'
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Currently in modal mode
        let isModalMode = presentingViewController is UINavigationController
        if isModalMode {
            // Dismiss modal view
            dismiss(animated: true, completion: nil)
        } else if let currentNavigationController = navigationController {
            // Currently in push mode, so pop view
            currentNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // Gets called before dismissing modal view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Check 'Save' button is clicked
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed", log: OSLog.default, type:.debug)
            return
        }
        // Create meal
        let name = mealTextField.text ?? ""
        let photo = mealImageView.image
        let rating = mealRating.rating
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    // MARK: Actions

    @IBAction func onSelectImage(_ sender: UITapGestureRecognizer) {
        // Dismiss keyboard properly
        mealTextField.resignFirstResponder()
        // Create image picker controller
        let imagePickerController = UIImagePickerController()
        // Disable camera ability
        imagePickerController.sourceType = .photoLibrary
        // Notify view controller
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate protocol
    
    // Gets called when user taps 'Return' (or 'Done')
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    // Gets called when text field resigns first repsonder status
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        navigationItem.title = text
    }
    
    // MARK: UIImagePickerControllerDelegate protocol
    
    // Gets called when user taps the cancle button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Gets called when user selects a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary with image. But was provided with \(info)")
        }
        // Set image view
        mealImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

}

