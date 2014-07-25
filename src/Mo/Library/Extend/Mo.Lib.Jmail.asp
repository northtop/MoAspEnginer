﻿<script language="jscript" runat="server">
/****************************************************
'@DESCRIPTION:	define MoLibJmail object
'****************************************************/
function MoLibJmail(){
	this.Exception="";
	this.jmail=null;
	this.charset="GB2312";
	this.contenttype="text/html";
	
	/****************************************************
	'@DESCRIPTION:	ensure jmail is available.
	'@PARAM:	classid [String] : jmail class id. Default value is 'JMail.Message';
	'@RETURN:	[Boolean] if jmail is available, return true, or return false.
	'****************************************************/
	this.enabled=function(classid){
		classid = classid || "JMail.Message";
		try{
			this.jmail = new ActiveXObject(classid);
			return true;
		}catch(ex){
			return false;
		}
	};
	this.setting={
		"MailAddress":"",
		"LoginName":"",
		"LoginPass":"",
		"Sender":"",
		"Fromer":"",
		"Email":"",
		"DisplayName":""
		};
	/****************************************************
	'@DESCRIPTION:	set login information
	'@PARAM:	server [String] : mail server
	'@PARAM:	username [String] : login username
	'@PARAM:	password [String] : login password
	'****************************************************/
	this.login = function(server,username,password){
		this.setting["MailAddress"]=server||"";
		this.setting["LoginName"]=username||"";
		this.setting["LoginPass"]=password||"";
		this.jmail.MailServerUserName = this.setting["LoginName"];
		this.jmail.MailServerPassword = this.setting["LoginPass"];
	};

	/****************************************************
	'@DESCRIPTION:	set sender
	'@PARAM:	email [String] : email address
	'@PARAM:	display [String] : display name.
	'****************************************************/
	this.from=function(email,display){
		this.setting["Sender"]=display||"";
		this.setting["Fromer"]=email||"";
		this.jmail.From = this.setting["Fromer"];
		this.jmail.FromName = this.setting["Sender"] ;
	};

	/****************************************************
	'@DESCRIPTION:	set receiver
	'@PARAM:	email [String] : email address
	'@PARAM:	display [String] : display name.
	'****************************************************/
	this.to=function(email,display){
		this.setting["Email"]=email||"";
		this.setting["DisplayName"]=display||this.setting["Email"];
		this.jmail.AddRecipient(this.setting["Email"],this.setting["DisplayName"]);
	};

	/****************************************************
	'@DESCRIPTION:	set mail message. if you don't call this method,you must set subject and content when you call 'send' method.
	'@PARAM:	Subject [String] : mail subject
	'@PARAM:	Content [String] : mail content
	'****************************************************/
	this.setMessage = function(Subject,Content){
		this.jmail.Subject = Subject;
		this.jmail.Body = Content; 
	};

	/****************************************************
	'@DESCRIPTION:	ddd recipient email
	'@PARAM:	email [String] : email address
	'@PARAM:	display [String] : display name.
	'****************************************************/
	this.addEmailAddress = function(email,display){
		email = email ||"";
		if(email=="")return;
		display = display || email;
		this.jmail.AddRecipient(email,display);
	};

	/****************************************************
	'@DESCRIPTION:	send email
	'@PARAM:	Subject [String[option]] : mail subject.s
	'@PARAM:	Content [String[option]] : mail content.
	'@RETURN:	[Boolean] if mail was sent successfully, return true, or return false;
	'****************************************************/
	this.send = function(Subject,Content) {
		if(this.jmail==null)return false;
		try{
			this.jmail.silent = true;
			this.jmail.Logging = true
			this.jmail.Charset =this.charset;
			this.jmail.ContentType = this.contenttype;
			if(Subject!=undefined)this.jmail.Subject = Subject;
			if(Content!=undefined)this.jmail.Body = Content;
			this.jmail.Priority = 3;
			var result=null;
			if(!this.jmail.Send(this.setting["MailAddress"])){
				result = false
				this.Exception = this.jmail.Log;
			}else{
				result = true
			}
			this.jmail.Close();
			this.jmail=null;
			return result;
		}catch(ex){this.Exception = ex.description;return false}
	}
}
/****************************************************
'@DESCRIPTION:	create an instance of MoLibJmail
'@RETURN:	[MoLibJmail] instance
'****************************************************/
MoLibJmail.New = function(){return new MoLibJmail();};
</script>