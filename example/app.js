// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor : 'white'
});

var pdfgenerator = require('com.kuchbee.pdfgenerator');
Ti.API.info("module is => " + pdfgenerator);
// Create a temperatory view which will be converted into bytes data and will pass as data
// the createPDFWithData will create pdf with this bytes data
var view = Ti.UI.createView({
	width: 612 - 60,
	height: 1464,
	//backgroundColor:'yellow',
});
// This is first page of the document
// Default width and height of the document is 612x792  
// we are providing 30px margin from left, right , top and bottom

var page1 = Ti.UI.createView({
	top:0,
	left:0,
	backgroundColor: 'yellow',
	width: 612 - 60,			// widht of this page is 60px less than total width because of 30px margin from left and right
	height: 792 - 60,			// height of the page is 60px less than total width because of 30px margin from top and bottom
	borderWidth: 2
});
view.add(page1);
// this is page2 of the pdf document
// its width and height are same as of page1 but different in color
var page2 = Ti.UI.createView({
	top:792-60,
	left:0,
	backgroundColor: 'red',
	width: 612 - 60,
	height: 792 - 60,
	borderWidth:2
});
view.add(page2);
// add a text label on page1
var label1 = Ti.UI.createLabel({
	text : 'This is text label with text........ with text..... with text.... with text.... testing label..... testing pdf',
	top:30,
	left:5,
	right:5,
	width : 612 - 70,
});
page1.add(label1);
// add a text label on page2
var label2 = Ti.UI.createLabel({
	text : 'This is text label with text........ with text..... with text.... with text.... testing label..... testing pdf',
	top:30,
	left:5,
	right:5,
	width : 612 - 70,
});
page2.add(label2);

// create bytes data from view
var pdfData = view.toImage();
// Generate PDF with data and provide file name to save
pdfgenerator.generatePDFWithData({
	data: pdfData,
	file: 'fahad.pdf',// File name to save in document directory
	top:30,		// top margin in the document
	left:30,	// left margin in the document
	right:30,	// right margin in the document
	bottom:30,	// bottom margin in the document
	complete: function(e){
		// This callback function will be called when file has saved in the document directory
		Ti.API.info('File saved at path: '+ e.filePath);
	}
});
// This function will generate pdf from url
// provide a url to convert into pdf document and a file name to save in the document directory
pdfgenerator.generatePDFFromURL({
	url: 'http://www.msn.com',
	file: 'google.pdf',
	complete: function(e){
		// this callback function will be called when file saved succesfully
		Ti.API.info('File saved at path: '+ e.filePath);
	},
	error: function(e){
		// This callback function will be called when error in generating pdf
		alert('error generating pdf');
	}
});

win.open();
