"
Description
--------------------

Tab to render all proposal talks of ESUG page in a table.

I can delete talks, export all talks in the database
"
Class {
	#name : #ERTalksTab,
	#superclass : #ERConfigurationTab,
	#category : #'ESUGApp-View-Tab'
}

{ #category : #actions }
ERTalksTab >> exportTalks [
	| file |
	file := controller conference exportTalks: 'talks'.
	self exportFile: file wihtName: 'talks.csv'
]

{ #category : #accessing }
ERTalksTab >> headers [ 	
	^ #('Name'	'Submitted By'	'Presentation Download URL' '')
]

{ #category : #rendering }
ERTalksTab >> listDataToRenderButton [
	^ OrderedCollection new
		add:
			(Array
				with: 'delete'
				with: [ :talk | self deleteTalk: talk.
					self updateStateTab: self tabName. ]
				with: [ :talk | talk id , '-delete' ]
				with: 'Delete'
				with: 'return confirm(''Are you sure you want to delete this item?'');'
				with: false);
		yourself
]

{ #category : #rendering }
ERTalksTab >> renderButtonOn: html [
	html mdlAnchorButton
		colored;
		id: 'exportTalks';
		callback: [ self exportTalks ];
		with: 'Export'
]

{ #category : #rendering }
ERTalksTab >> renderContainerOn: html [
	self renderButtonOn: html.
	html horizontalRule.
	self renderTableOfTalksOn: html
]

{ #category : #rendering }
ERTalksTab >> renderTableOfTalksOn: html [
	table := ERTable new
		headers: self headers;
		levelTotal: 6;
		listObject: self talks;
		blockToExecute: self blockTableTalksToExecute;
		listToRenderButton: self listDataToRenderButton.
	html render: table
]

{ #category : #accessing }
ERTalksTab >> tabId [
	^ 'talks'
]

{ #category : #accessing }
ERTalksTab >> tabName [
	^ 'Talks'
]

{ #category : #accessing }
ERTalksTab >> talks [
	^ controller conference submittedTalks
]

{ #category : #accessing }
ERTalksTab >> title [
	^ 'Submitted Talks'
]
