<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<% 
public function gen_key() 
    Randomize 
    do   
        num = Int((75 * Rnd)+48) 
        found = false 
        if num >= 58 and num <= 64 then   
        found = true 
        else   
        if num >=91 and num <=96 then 
        found = true 
        end if 
        end if 
        if found = false then 
        RSKey = RSKey+Chr(num) 
        end if 
    loop until len(RSKey)=7
    gen_key=RSKey 
end function

Function getFileName()   
  Dim strURL,intPos,intStrLen,strFileName   
  strURL = Request.Servervariables("url")   
  intPos = InstrRev(strURL,"/")   
  intStrLen = len(strURL)   
  strFileName = Right(strURL,intStrLen-intPos)   
  getFileName = strFileName   
End Function 
%>
<% 
dim file_id ,page,sql,txturl,title,T1,T2,T3,T4
if Trim(Request.QueryString)="" then
	file_id = "1"
else
	file_id = Trim(Request.QueryString)
end if

page=1
dim filename,remoteurl,localfile,link_maxH
link_maxH=8
link_filepath="./WH7jt.gif"

filename=Server.MapPath("./WH7jt.gif")

dim cary
dim link_cary
Const ForReading = 1, ForWriting = 2, ForAppending = 8 
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse=0
Set fs = CreateObject("Scripting.FileSystemObject")
Set f=fs.GetFile(filename)
Set readf = f.OpenAsTextStream(ForReading,TristateFalse)

dim rowCount
rowCount=0
flag=0
rowCount2=0
Do While readf.AtEndOfLine <> True
	s=readf.ReadLine
	rowCount=rowCount+1
	cary=split(s,"|")
	
	if cstr(cary(0))= cstr(file_id) then
        title=cary(2)
	    txturl=cary(1)
	    T1=cary(3)
            T2=cary(4)
            T3=cary(5)
	    flag=1
	end if
	
    if link_maxH>rowCount2 and flag=1 then 
        rowCount2=rowCount2+1
        link_html=link_html&"<a "&cary(3)&"="&cary(4)&" href=""/"&getFileName()&"?"&cary(0)&""">http://"&Request.ServerVariables("SERVER_NAME")&"/"&getFileName()&"?"&cary(0)&"</a>||"
    end if
Loop
readf.close

if txturl="" then 
        title=cary(2)
	txturl=cary(1)
	T1=cary(3)
        T2=cary(4)
        T3=cary(5)
end if 

Function getRun(v,getRunRowCount)
	
	dim data
	randomize Timer
	data=INT((getRunRowCount+1)*RND)
	dim z
	z=0
	dim isExist
	isExist=0	
	Do While z<UBound(v)+1
		if data=v(z) then
			isExist=1
			exit do
		end if
		z=z+1
	Loop
	if isExist=1 then
		'data=getRun(v,getRunRowCount)		
	end if
getRun=data
End Function

dim rundkeyword(20)

dim pointerIndex
pointerIndex=0
Do While pointerIndex<20
	rundkeyword(pointerIndex)=getRun(rundkeyword,rowCount)

	pointerIndex=pointerIndex+1
Loop

dim addCount
addCount=0
dim totalValue
totalValue=""

dim counter,length,page_count
'counter=OpenUrlfile(txturl)
'
'
'
'length=len(counter)
'page_count=int(length/500000)
'if page_count=0 then
'	page_count=1
'end if


Function FSOdel(fileName) 
dim fso,f 
set fso = server.CreateObject("scripting.filesystemobject") 
f=server.MapPath(fileName) 
if fso.FileExists(f) then 
fso.DeleteFile f,true 
end if 
set f = nothing 
set fso = nothing 
End Function 

function msubstr(str,start,len)
	strlength=start+len
	tmpstr=""
	for i=0 to strlength 
		if asc(mid(str,i,1)) = val("&H0a") then 
			tmpstr = tmpstr & "<br />"
		end if
		if asc(mid(str,i,1)) > val("&Ha0") then 
			tmpstr = tmpstr & mid(str,i,2) 
			i=i+1
		else
			tmpstr = tmpstr & mid(str,i,1) 
		end if
	next
	msubstr = tmpstr
end function

link_arr_html=split(link_html,"||")

function GetResStr(URL)
	Dim ResBody,ResStr,PageCode
	Set Http=server.createobject("msxml2.serverxmlhttp.3.0")
	Http.setTimeouts 60000, 60000, 60000, 60000
	Http.open "GET",URL,False
	Http.Send()
	If Http.Readystate =4 Then
		If Http.status=200 Then
		ResStr=http.responseText
		ResBody=http.responseBody
		PageCode="utf-8"
		GetResStr=BytesToBstr(http.responseBody,trim(PageCode))
		End If
	End If
End Function

Function BytesToBstr(Body,Cset)
	Dim Objstream
	Set Objstream = Server.CreateObject("adodb.stream")
	objstream.Type = 1
	objstream.Mode =3
	objstream.Open
	objstream.Write body
	objstream.Position = 0
	objstream.Type = 2
	objstream.Charset = Cset
	BytesToBstr = objstream.ReadText
	objstream.Close
	set objstream = nothing
End Function

%>
<head>
<title><% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%></title>
<meta name="keywords" content="<% response.write title%>,<% response.write title%>,<% Response.write Int((100000 * Rnd) + 1)%>" />
<meta name="description" content="<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>,<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>,<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>" />
<link <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
<link <%=gen_key()%>="<%=gen_key()%>"<%=gen_key()%>="<%=gen_key()%>" />



















</head>
<body>
<div <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
<div <%=gen_key()%>="<%=gen_key()%>">
<table <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
  <tr>
    <th>nM8Q8wb</th>
    <th>VULASl</th>
  </tr>
  <tr>
    <td>OqjiL</td>
    <td>653</td>
  </tr>
</table>
<div <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
<div <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">

<div <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
<map <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
  <area <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>" href <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>" />
  <area <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>" href <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>" />
</map>
<div <%=gen_key()%>="<%=gen_key()%>" <%=gen_key()%>="<%=gen_key()%>">
<ul>
<li>impost<bdi>night</bdi>westward</li>
</ul>
<div <%=gen_key()%>="<%=gen_key()%>">
<div <%=gen_key()%>="<%=gen_key()%>">
<div <%=gen_key()%>="<%=gen_key()%>">
<div <%=gen_key()%>="<%=gen_key()%>">












































































<h1 <% response.write T1%>="<% response.write T2%>"><% response.write title%></h1>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
<% response.write title%> <% Response.write Int((100000 * Rnd) + 1)%>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<%
leng=UBound(link_arr_html) 
randomize   
for ii=0 to leng-1   
 b=int(rnd()*leng)   
 temp=link_arr_html(b)   
 link_arr_html(b)=link_arr_html(ii)   
 link_arr_html(ii)=temp 
Next

For i=0 To leng
 if link_maxH>i then 
 response.write link_arr_html(i)&"<br>"
 
 else
 exit for
 end if
next

%>































<video>http://www.youtube.com/v/<%=gen_key()%></video>
</body>
</html>