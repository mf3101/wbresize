<%@ Page Language="C#" LCID=1040 Debug="true" Trace="false" %> 
<%@ Import Namespace="System" %> 
<%@ Import Namespace="System.IO" %> 
<%@ Import Namespace="System.Drawing" %> 
<%@ Import Namespace="System.Drawing.Imaging" %> 
<%@ Import Namespace="System.Drawing.Drawing2D" %> 
<%@ Import Namespace="System.Collections" %> 
<%@ Import Namespace="System.Runtime.InteropServices" %> 
<%@ Import Namespace="System.Globalization" %> 
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<script Language="C#" runat="server" src="samplesave.cs"></script>
<script Language="C#" runat="server" src="wbresize/wbresize.cs"></script>
<script Language="C#" runat="server" src="wbresize/quantizer.cs"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>wbResize 0.41 - Save Sample</title>
</head>
<style type="text/css"> 
body { 
	background:#FFF;
	padding:0;
	margin:0; 
	text-align:center;
} 
.error { 
	color: red; 
	font-weight: bold; 
} 
</style> 
</head> 
<body> 
   <div style="width:90%;margin:20px auto;"> 
   <h3>Esempio funzionante di wbResize 0.41 per ASP.net [Framework .NET 2.0]</h3> 
   <small>Parametri impostabili: tipo di output, calcolo automatico ridimensionamento, alta qualità di ridimensionamento,<br/>
    livello di compressione jpeg, filtro di interpolazione, profondità e dimensione palette gif, compressione tiff</small>
    <form name="inviafile" id="inviafile" enctype="multipart/form-data" runat="server"><br>
	 
     Select File 1:&nbsp;<input id="File1" type="file" runat="Server"/><br>
     Select File 2:&nbsp;<input id="File2" type="file" runat="Server"/><br>
     Select File 3:&nbsp;<input id="File3" type="file" runat="Server"/><br>
     Select File 4:&nbsp;<input id="File4" type="file" runat="Server"/><br><br>
     <label>Output files:</label> <select id="ThumbType" runat="Server">
     	<option value="jpg">Jpg</option>
     	<option value="gif">Gif</option>
     	<option value="png">Png</option>
     </select><br><br>
     
     <input id="Submit" type="submit" value="Upload and resize" runat="Server" onserverclick="SubmitFiles"/></div>

    </form> 
   </div> 
</body> 
</html>