Class {
	#name : #ERLoggedPage,
	#superclass : #WAComponent,
	#instVars : [
		'pageController',
		'navbar',
		'content',
		'attendee'
	],
	#category : #'ESUGApp-View-Page'
}

{ #category : #hooks }
ERLoggedPage >> children [ 
	^ Array with: navbar with: content
]

{ #category : #accessing }
ERLoggedPage >> content [
	^ content
]

{ #category : #accessing }
ERLoggedPage >> content: anObject [
	content := anObject
]

{ #category : #rendering }
ERLoggedPage >> initialize [
	super initialize.
	Transcript show: 'Logged'.
	pageController := ERLoggedController new user: self session user.
	attendee := pageController attendeeFromUser.
	content := ERContent new.
	(ERHomeView
				withContent: content
				withController: pageController).
	self initializeNabvar.
]

{ #category : #rendering }
ERLoggedPage >> initializeNabvar [
	navbar := ERNav new listOptions: self itemList; yourself
]

{ #category : #rendering }
ERLoggedPage >> itemList [
	^ Dictionary new
		at: 'home'
			put: [ "self homeComponent"ERHomeView
				withContent: content
				withController: pageController ];
		at: 'admin'
			put: [ "self adminComponent "ERAdminView
				on: self session user
				withContent: content
				withController: pageController ];
		at: 'logout'
			put: [ self logout ];
		at: 'groupRegistration'
			put: [ "self groupComponent"ERGroupRegistrationView
				attendee: self session user
				content: content ];
		at: 'myRegistration'
			put: [ "self attendeeComponent"ERMyRegistrationView
				attendee: attendee
				content: content ];
		at: 'configuration'
			put: [ "self configComponent"ERConfigurationView
				attendee: attendee
				content: content ];
		yourself
]

{ #category : #rendering }
ERLoggedPage >> listOptionsFor: aMenuFactory [
	| list |
	list := OrderedCollection new.
	list add: aMenuFactory createHomeItem.
	self session user isAttendee
		ifTrue: [ list add: aMenuFactory createMyRegistrationItem ].
	self session user isGroupManager
		ifTrue: [ list add: aMenuFactory createGroupManagerItem ].
	self session user isAdmin
		ifTrue: [ list add: aMenuFactory createConfigurationItem ].
	self session user isStudent
		ifTrue: [  ].
	list add: aMenuFactory createAdminItem.
	list add: aMenuFactory createLogoutItem .
	^ list
]

{ #category : #accessing }
ERLoggedPage >> logout [
	self session logout.
    ^ self requestContext redirectTo: self application url
]

{ #category : #accessing }
ERLoggedPage >> navbar: anObject [
	navbar := anObject
]

{ #category : #accessing }
ERLoggedPage >> pageController [
	^ pageController
]

{ #category : #rendering }
ERLoggedPage >> renderContentOn: html [
	html mdlLayout
		fixedDrawer;
		fixedHeader;
		class: 'demo-layout';
		with: [ 
			html render: navbar .
			html render: content .
		 ]
]

{ #category : #hooks }
ERLoggedPage >> states [
    ^ Array with: self
]
