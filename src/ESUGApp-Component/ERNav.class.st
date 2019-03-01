Class {
	#name : #ERNav,
	#superclass : #WAComponent,
	#instVars : [
		'title',
		'listOptions'
	],
	#category : #'ESUGApp-Component'
}

{ #category : #hooks }
ERNav >> children [
	^ Array withAll: self listOfAvailableOptions
]

{ #category : #accessing }
ERNav >> createAdminItem [
	^ ERItemNav 
		label: 'Admin' 
		icon: 'person' 
		callback: (listOptions at: 'admin')
]

{ #category : #accessing }
ERNav >> createConfigurationItem [
	^ ERItemNav
		label: 'Configuration'
		icon: 'settings'
		callback: (listOptions at: 'configuration')
]

{ #category : #accessing }
ERNav >> createGroupManagerItem [
	^ ERItemNav 
		label: 'Group Registration' 
		icon: 'group' 
		callback: (listOptions at: 'groupRegistration')
]

{ #category : #accessing }
ERNav >> createHomeItem [
	^ ERItemNav 
		label: 'Home' 
		icon: 'home' 
		callback: (listOptions at: 'home')
]

{ #category : #accessing }
ERNav >> createLogoutItem [
	^ ERItemNav label: 'Logout' icon: 'backspace' callback: (listOptions at: 'logout')
]

{ #category : #accessing }
ERNav >> createMyRegistrationItem [
	^ ERItemNav 
		label: 'My Registration' 
		icon: 'assignment' 
		callback: (listOptions at: 'myRegistration')
]

{ #category : #initialization }
ERNav >> initialize [
	super initialize.
	title := 'Home'.
	listOptions := OrderedCollection new
]

{ #category : #accessing }
ERNav >> listOfAvailableOptions [
	| list |
	list := OrderedCollection new.
	list add: self createHomeItem.
	self session user isAttendee
		ifTrue: [ list add: self createMyRegistrationItem ].
	self session user isGroupManager
		ifTrue: [ list add: self createGroupManagerItem ].
	self session user isAdmin
		ifTrue: [ list add: self createConfigurationItem ].
	self session user isStudent
		ifTrue: [  ].
	list add: self createAdminItem.
	list add: self createLogoutItem .
	^ list
]

{ #category : #accessing }
ERNav >> listOptions: anObject [
	listOptions := anObject
]

{ #category : #rendering }
ERNav >> renderContentOn: html [
	self renderHeaderOn: html.
	html mdlLayoutDrawer
		class:
			'demo-drawer mdl-color--blue-grey-900 mdl-color-text--blue-grey-50';
		with: [ self renderHeaderESUGOn: html.
			html mdlNavigation
				class: 'demo-navigation mdl-color--blue-grey-800';
				with: [ self listOfAvailableOptions do: [ :each | html render: each ] ] ]
]

{ #category : #rendering }
ERNav >> renderHeaderESUGOn: html [
	html header class: 'demo-drawer-header';
	with: [ 
			html heading level4 with: 'ESUG'	
	]
]

{ #category : #rendering }
ERNav >> renderHeaderOn: html [
	html mdlLayoutHeader
	class: 'demo-header mdl-layout__header mdl-color--blue-grey-800 mdl-color-text--white';
	with: [ 
		html mdlLayoutHeaderRow with: [ 
			html span class: 'mdl-layout-title';
			with: title.
			html mdlLayoutSpacer.
		]	
	].
]

{ #category : #accessing }
ERNav >> title: aString [
	title := aString
]
