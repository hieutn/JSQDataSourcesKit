//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://www.jessesquires.com/JSQDataSourcesKit/
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit
import CoreData


///  An instance conforming to `TableViewCellFactoryType` is responsible for initializing
///  and configuring table view cells to be consumed by an instance of `TableViewDataSourceProvider`.
///  The `TableViewCellFactoryType` protocol has two associated types, `DataItem` and `Cell`.
///  These associated types describe the type of model instances backing the table view
///  and the type of cells in the table view, respectively.
public protocol TableViewCellFactoryType {

    ///  The type of elements backing the table view.
    typealias DataItem

    ///  The type of `UITableViewCell` that the factory produces.
    typealias Cell: UITableViewCell

    ///  Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.
    ///
    ///  :param: item      The model instance (data object) at `indexPath`.
    ///  :param: tableView The table view requesting this information.
    ///  :param: indexPath The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: An initialized or dequeued `UITableViewCell` of type `Cell`.
    func cellForItem(item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell

    ///  Configures and returns the specified cell.
    ///
    ///  :param: cell      The cell to configure.
    ///  :param: item      The model instance (data object) at `indexPath`.
    ///  :param: tableView The table view requesting this information.
    ///  :param: indexPath The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: A configured `UITableViewCell` of type `Cell`.
    func configureCell(cell: Cell, forItem item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell
}


///  A `TableViewCellFactory` is a concrete `TableViewCellFactoryType`.
///  This factory is responsible for producing and configuring table view cells for a specific data item.
///  <br/><br/>
///  **The factory has the following type parameters:**
///  <br/>
///  ````
///  <Cell: UITableViewCell, DataItem>
///  ````
public struct TableViewCellFactory <Cell: UITableViewCell, DataItem>: TableViewCellFactoryType {

    ///  Configures the cell for the specified data item, table view and index path.
    ///
    ///  :param: Cell        The cell to be configured at the index path.
    ///  :param: DataItem    The data item at the index path.
    ///  :param: UITableView The table view requesting this information.
    ///  :param: NSIndexPath The index path at which the cell will be displayed.
    ///
    ///  :returns: The configured cell.
    public typealias ConfigurationHandler = (Cell, DataItem, UITableView, NSIndexPath) -> Cell

    ///  A unique identifier that describes the purpose of the cells that the factory produces.
    ///  The factory dequeues cells from the table view with this reuse identifier.
    ///  Clients are responsible for registering a cell for this identifier with the table view.
    public let reuseIdentifier: String

    private let cellConfigurator: ConfigurationHandler

    ///  Constructs a new table view cell factory.
    ///
    ///  :param: reuseIdentifier  The reuse identifier with which the factory will dequeue cells.
    ///  :param: cellConfigurator The closure with which the factory will configure cells.
    ///
    ///  :returns: A new `TableViewCellFactory` instance.
    public init(reuseIdentifier: String, cellConfigurator: ConfigurationHandler) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    ///  Creates and returns a new `Cell` instance, or dequeues an existing cell for reuse.
    ///
    ///  :param: item      The model instance (data object) at `indexPath`.
    ///  :param: tableView The table view requesting this information.
    ///  :param: indexPath The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: An initialized or dequeued `UITableViewCell` of type `Cell`.
    public func cellForItem(item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
    }

    ///  Configures and returns the specified cell.
    ///
    ///  :param: cell      The cell to configure.
    ///  :param: item      The model instance (data object) at `indexPath`.
    ///  :param: tableView The table view requesting this information.
    ///  :param: indexPath The index path that specifies the location of `cell` and `item`.
    ///
    ///  :returns: A configured `UITableViewCell` of type `Cell`.
    public func configureCell(cell: Cell, forItem item: DataItem, inTableView tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> Cell {
        return cellConfigurator(cell, item, tableView, indexPath)
    }
}


///  An instance conforming to `TableViewSectionInfo` represents a section of items in a table view.
public protocol TableViewSectionInfo {

    ///  The type of elements stored in the section.
    typealias DataItem

    ///  Returns the elements in the table view section.
    var dataItems: [DataItem] { get }

    ///  Returns the header title for the section.
    var headerTitle: String? { get }

    ///  Returns the footer title for the section.
    var footerTitle: String? { get }
}


///  A `TableViewSection` is a concrete `TableViewSectionInfo`.
///  A section instance is responsible for managing the elements in a section.
///  Elements in the section may be accessed or replaced via its subscripting interface.
///  <br/><br/>
///  **The section has the following type parameters:**
///  <br/>
///  ````
///  <DataItem>
///  ````
public struct TableViewSection <DataItem>: TableViewSectionInfo {

    ///  The elements in the collection view section.
    public var dataItems: [DataItem]

    ///  The header title for the section.
    public let headerTitle: String?

    ///  The footer title for the section.
    public let footerTitle: String?

    ///  Returns the number of elements in the section.
    public var count: Int {
        return dataItems.count
    }

    ///  Constructs a new table view section.
    ///
    ///  :param: dataItems   The elements in the section.
    ///  :param: headerTitle The section header title.
    ///  :param: footerTitle The section footer title.
    ///
    ///  :returns: A new `TableViewSection` instance.
    public init(dataItems: [DataItem], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.dataItems = dataItems
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    public subscript (index: Int) -> DataItem {
        get {
            return dataItems[index]
        }
        set {
            dataItems[index] = newValue
        }
    }
}


public final class TableViewDataSourceProvider <DataItem, SectionInfo: TableViewSectionInfo, CellFactory: TableViewCellFactoryType
                                                where
                                                SectionInfo.DataItem == DataItem,
                                                CellFactory.DataItem == DataItem> {

    public var sections: [SectionInfo]

    public let cellFactory: CellFactory

    public var dataSource: UITableViewDataSource { return bridgedDataSource }

    public init(sections: [SectionInfo], cellFactory: CellFactory, tableView: UITableView? = nil) {
        self.sections = sections
        self.cellFactory = cellFactory

        tableView?.dataSource = dataSource
    }

    public subscript (index: Int) -> SectionInfo {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    private lazy var bridgedDataSource: BridgedTableViewDataSource = BridgedTableViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.sections.count
        },
        numberOfRowsInSection: { [unowned self] (section) -> Int in
            self.sections[section].dataItems.count
        },
        cellForRowAtIndexPath: { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let dataItem = self.sections[indexPath.section].dataItems[indexPath.row]
            let cell = self.cellFactory.cellForItem(dataItem, inTableView: tableView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: dataItem, inTableView: tableView, atIndexPath: indexPath)
        },
        titleForHeaderInSection: { [unowned self] (section) -> String? in
            self.sections[section].headerTitle
        },
        titleForFooterInSection: { [unowned self] (section) -> String? in
            self.sections[section].footerTitle
        })
}


public final class TableViewFetchedResultsDataSourceProvider <DataItem, CellFactory: TableViewCellFactoryType
                                                              where CellFactory.DataItem == DataItem> {

    public let fetchedResultsController: NSFetchedResultsController

    public let cellFactory: CellFactory

    public var dataSource: UITableViewDataSource { return bridgedDataSource }

    public init(fetchedResultsController: NSFetchedResultsController, cellFactory: CellFactory, tableView: UITableView? = nil) {
        self.fetchedResultsController = fetchedResultsController
        self.cellFactory = cellFactory

        tableView?.dataSource = dataSource
    }

    public func performFetch(error: NSErrorPointer = nil) -> Bool {
        let success = self.fetchedResultsController.performFetch(error)
        if !success {
            println("*** ERROR: \(toString(TableViewFetchedResultsDataSourceProvider.self))"
                + "\n\t [\(__LINE__)] \(__FUNCTION__) Could not perform fetch error: \(error)")
        }
        return success
    }

    private lazy var bridgedDataSource: BridgedTableViewDataSource = BridgedTableViewDataSource(
        numberOfSections: { [unowned self] () -> Int in
            self.fetchedResultsController.sections?.count ?? 0
        },
        numberOfRowsInSection: { [unowned self] (section) -> Int in
            let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo
            return sectionInfo?.numberOfObjects ?? 0
        },
        cellForRowAtIndexPath: { [unowned self] (tableView, indexPath) -> UITableViewCell in
            let dataItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as! DataItem
            let cell = self.cellFactory.cellForItem(dataItem, inTableView: tableView, atIndexPath: indexPath)
            return self.cellFactory.configureCell(cell, forItem: dataItem, inTableView: tableView, atIndexPath: indexPath)
        },
        titleForHeaderInSection: { [unowned self] (section) -> String? in
            let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo
            return sectionInfo?.name
        },
        titleForFooterInSection: { (section) -> String? in
            return nil
        })
}


/**
*   This separate type is required for Objective-C interoperability (interacting with Cocoa).
*   Because the DataSourceProvider is generic it cannot be bridged to Objective-C. 
*   That is, it cannot be assigned to `UITableView.dataSource`.
*/
@objc private final class BridgedTableViewDataSource: NSObject, UITableViewDataSource {

    typealias NumberOfSectionsHandler = () -> Int
    typealias NumberOfRowsInSectionHandler = (Int) -> Int
    typealias CellForRowAtIndexPathHandler = (UITableView, NSIndexPath) -> UITableViewCell
    typealias TitleForHeaderInSectionHandler = (Int) -> String?
    typealias TitleForFooterInSectionHandler = (Int) -> String?

    let numberOfSections: NumberOfSectionsHandler
    let numberOfRowsInSection: NumberOfRowsInSectionHandler
    let cellForRowAtIndexPath: CellForRowAtIndexPathHandler
    let titleForHeaderInSection: TitleForHeaderInSectionHandler
    let titleForFooterInSection: TitleForFooterInSectionHandler

    init(numberOfSections: NumberOfSectionsHandler,
        numberOfRowsInSection: NumberOfRowsInSectionHandler,
        cellForRowAtIndexPath: CellForRowAtIndexPathHandler,
        titleForHeaderInSection: TitleForHeaderInSectionHandler,
        titleForFooterInSection: TitleForFooterInSectionHandler) {

            self.numberOfSections = numberOfSections
            self.numberOfRowsInSection = numberOfRowsInSection
            self.cellForRowAtIndexPath = cellForRowAtIndexPath
            self.titleForHeaderInSection = titleForHeaderInSection
            self.titleForFooterInSection = titleForFooterInSection
    }

    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection(section)
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellForRowAtIndexPath(tableView, indexPath)
    }

    @objc func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(section)
    }

    @objc func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection(section)
    }
}
