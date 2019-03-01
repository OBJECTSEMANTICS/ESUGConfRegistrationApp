Class {
	#name : #ERLoggedPage,
	#superclass : #WAComponent,
	#instVars : [
		'pageController',
		'navbar',
		'content',
		'attendee',
		'home',
		'admin',
		'group',
		'myReg',
		'config'
	],
	#category : #'ESUGApp-View-Page'
}

{ #category : #rendering }
ERLoggedPage >> adminView [
	admin ifNil: 
		[ admin := ERAdminView
				on: self session user
				withContent: content
				withController: pageController ].
	admin content: content.
	^ admin
]

{ #category : #hooks }
ERLoggedPage >> children [ 
	^ Array with: navbar with: content
]

{ #category : #rendering }
ERLoggedPage >> configView [
	config ifNil: [ config := ERConfigurationView
				attendee: attendee
				content: content ].
	config content: content.
	^ config
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
ERLoggedPage >> groupView [
	group ifNil: 	
		[ group := ERGroupRegistrationView
				attendee: self session user
				content: content ].
	group content: content.
	^ group
]

{ #category : #rendering }
ERLoggedPage >> homeView [
	home ifNil: 
		[ home := ERHomeView
				withContent: content
				withController: pageController ].
	home content: content.
	^ home
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
			put: [ self homeView ];
		at: 'admin'
			put: [ self adminView ];
		at: 'logout'
			put: [ self logout ];
		at: 'groupRegistration'
			put: [ self groupView ];
		at: 'myRegistration'
			put: [ self myRegView];
		at: 'configuration'
			put: [ self configView ];
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

{ #category : #rendering }
ERLoggedPage >> myRegView [
	myReg ifNil: [ myReg := ERMyRegistrationView
				attendee: attendee
				content: content  ].
	myReg content: content.
	^ myReg
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
