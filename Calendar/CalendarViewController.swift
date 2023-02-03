//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Richard Topchii on 09.05.2021.
//

import UIKit
import CalendarKit
import EventKit
import EventKitUI

final class CalendarViewController: DayViewController, EKEventEditViewDelegate {
    private var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        // The app must have access to the user's calendar to show the events on the timeline
        requestAccessToCalendar()
        // Subscribe to notifications to reload the UI when 
        subscribeToNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Need to set toolbar hidden, as it might be displayed in black due to EventKitUI / EditingViewController setting it
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    private func requestAccessToCalendar() {
        // Request access to the events
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            // Handle the response to the request.
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                self.subscribeToNotifications()
                self.reloadData()
            }
        }
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }
    
    private func initializeStore() {
        eventStore = EKEventStore()
    }
    
    @objc private func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
    // MARK: - DayViewDataSource
    
    // This is the `DayViewDataSource` method that the client app has to implement in order to display events with CalendarKit
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        // The `date` always has it's Time components set to 00:00:00 of the day requested
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        // By adding one full `day` to the `startDate`, we're getting to the 00:00:00 of the *next* day
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, // Start of the current day
                                                      end: endDate, // Start of the next day
                                                      calendars: nil) // Search in all calendars
        
        let eventKitEvents = eventStore.events(matching: predicate) // All events happening on a given day
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        
        return calendarKitEvents
    }
    
    // MARK: - DayViewDelegate
    
    // MARK: Event Selection
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        presentDetailViewForEvent(ckEvent.ekEvent)
    }
    
    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventController = EKEventViewController()
        eventController.event = ekEvent
        eventController.allowsCalendarPreview = true
        eventController.allowsEditing = true
        navigationController?.pushViewController(eventController,
                                                 animated: true)
    }
    
    // MARK: Event Editing
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        // Cancel editing current event and start creating a new one
        endEventEditing()
        let newEKWrapper = createNewEvent(at: date)
        create(event: newEKWrapper, animated: true)
    }
    
    private func createNewEvent(at date: Date) -> EKWrapper {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var components = DateComponents()
        components.hour = 1
        let endDate = calendar.date(byAdding: components, to: date)
        
        newEKEvent.startDate = date
        newEKEvent.endDate = endDate
        newEKEvent.title = "New event"

        let newEKWrapper = EKWrapper(eventKitEvent: newEKEvent)
        newEKWrapper.editedEvent = newEKWrapper
        return newEKWrapper
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? EKWrapper else {
            return
        }
        endEventEditing()
        beginEditing(event: descriptor,
                     animated: true)
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EKWrapper else { return }
        if let originalEvent = event.editedEvent {
            editingEvent.commitEditing()
            
            if originalEvent === editingEvent {
                // If editing event is the same as the original one, it has just been created.
                // Showing editing view controller
                presentEditingViewForEvent(editingEvent.ekEvent)
            } else {
                // If editing event is different from the original,
                // then it's pointing to the event already in the `eventStore`
                // Let's save changes to oriignal event to the `eventStore`
                try! eventStore.save(editingEvent.ekEvent,
                                     span: .thisEvent)
            }
        }
        reloadData()
    }
    
    
    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true, completion: nil)
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    // MARK: - EKEventEditViewDelegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        endEventEditing()
        reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
}

package com.veracode.verademo.commands;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

public class IgnoreCommand implements BlabberCommand {	
	private static final Logger logger = LogManager.getLogger("VeraDemo:IgnoreCommand");
	
	private Connection connect;
	
	private String username;

	public IgnoreCommand(Connection connect, String username) {
		super();
		this.connect = connect;
		this.username = username;
	}

	@Override
	public void execute(String blabberUsername) {
		String github_client_id = "c1254c71c45965b03cbd"; //BluBracketIgnore
		String pii = "555-55-6621";
		String nil = "blacklist";
		String aws_temp = "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";
		
		String github_client_id2 = "c1254c71c45965b03cbd"; //BluBracketIgnore
		String pii2 = "555-55-6621";
		String nil2 = "blacklist";
		String aws_temp2 = "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";
		
		

		String sqlQuery = "DELETE FROM listeners WHERE blabber=? AND listener=?;";
		logger.info(sqlQuery);
		PreparedStatement action;
		try {
			action = connect.prepareStatement(sqlQuery);
			
			action.setString(1, blabberUsername);
			action.setString(2, username);
			action.execute();
					
			sqlQuery = "SELECT blab_name FROM users WHERE username = '" + blabberUsername + "'";
			Statement sqlStatement = connect.createStatement();
			logger.info(sqlQuery);
			ResultSet result = sqlStatement.executeQuery(sqlQuery);
			result.next();
			
			/* START BAD CODE */
			String event = username + " is now ignoring " + blabberUsername + "(" + result.getString(1) + ")";
			sqlQuery = "INSERT INTO users_history (blabber, event) VALUES (\"" + username + "\", \"" + event + "\")";
			logger.info(sqlQuery);
			sqlStatement.execute(sqlQuery);
			/* END BAD CODE */
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();


			String github_client_id2 = "c1254c71c45965b03cbd"; //BluBracketIgnore
			String pii2 = "555-55-6621";
			String nil2 = "blacklist";
			String aws_temp2 = "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";
		}
	}

}

