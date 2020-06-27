//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by LeeAlvis on 26/6/2020.
//

import os.log
import UIKit

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add special bar button with edit functionalities
        navigationItem.leftBarButtonItem = editButtonItem
        // Load meals
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MealTableViewCell"
        // Downcast cell to MealTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Get meal at row index
        let meal = meals[indexPath.row]
        // Configure the cell
        cell.mealLabel.text = meal.name
        cell.mealImageView.image = meal.photo
        cell.mealRating.rating = meal.rating
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            // Get destination controller of segue
            guard let controller = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            // Get the sender of the segue
            guard let cell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: cell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            // Set meal to display in MealViewController
            let selected = meals[indexPath.row]
            controller.meal = selected
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // Get the sender of the segue
        if let controller = sender.source as? MealViewController, let meal = controller.meal {
            // If a cell is selected, it is in edit mode
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Edit meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadData()
            } else {
                // Otherwise, it is in add mode
                let indexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            saveMeals()
        }
    }
    
    // MARK: Private Actions
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
         
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
         
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        // Create archive data
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) else {
            os_log("Failed to create archive data", log: OSLog.default, type: .error)
            return
        }
        // Write archive data to file
        if (try? data.write(to: Meal.ArchiveURL)) != nil {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        // Get archive data from file
        if let archivedData = try? Data(contentsOf: Meal.ArchiveURL), let meals = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [Meal] {
            // Return unarchived data
            return meals
        }
        return nil
    }

}
