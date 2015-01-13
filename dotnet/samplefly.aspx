<%@ Page Language="C#" LCID=1040 Debug="true" Trace="false" %> 
<%@ Import Namespace="System" %> 
<%@ Import Namespace="System.IO" %> 
<%@ Import Namespace="System.Drawing" %> 
<%@ Import Namespace="System.Drawing.Imaging" %> 
<%@ Import Namespace="System.Drawing.Drawing2D" %> 
<%@ Import Namespace="System.Collections" %> 
<%@ Import Namespace="System.Runtime.InteropServices" %> 
<%@ Import Namespace="System.Globalization" %>
<script Language="C#" runat="server" src="wbresize/wbresize.cs"></script>
<script Language="C#" runat="server" src="wbresize/quantizer.cs"></script>
<script Language="C#" runat="server">

string ThumbType = "";

void Page_Load(object sender, System.EventArgs e)
{	
	ThumbType = (Request.QueryString["t"]==null)?"":Request.QueryString["t"];
	
	
	wbResize ImageResizer = new wbResize();
	
	ImageResizer.LoadImage(Server.MapPath("upload/sample.jpg"));		//accetta path, image e stream
	ImageResizer.SetFileType(ThumbType);			//Tipo di output [jpg, gif, bmp, tiff, png]
	ImageResizer.SetThumbSize(500, 500, false);		//Width, Height e forzatura
	//ImageResizer.SetThumbSize(50); 				//IMPOSTA LA % DELL'ORIGINALE
	
	ImageResizer.SetOptionHighQuality(true);		//Alta qualità
	ImageResizer.SetOptionJpegQuality(100);			//Qualità JPEG
	ImageResizer.SetOptionFilter(InterpolationMode.HighQualityBicubic); //Filtro di Interpolazione
	ImageResizer.SetOptionGifDepth(4);				//Profondità colore GIF [0 = off, 1, 2, 4, 8, 255 = grayscale]
	ImageResizer.SetOptionGifPalette(255);			//Dimensione Palette GIF [9-255]
	ImageResizer.SetOptionTiffCompress(true);		//Compressione TIFF
	
	print(ImageResizer.Resize(),ThumbType);
}

private void print(MemoryStream memorystream, string filetype) {
	//stampa nell'outputstream un'immagine (passata in un memorystream)
	switch (filetype) {
		case "gif": Response.ContentType = "image/gif"; break;
		case "png": Response.ContentType = "image/png"; break;
		case "bmp": Response.ContentType = "image/bmp"; break;
		case "tiff": Response.ContentType = "image/tiff"; break;
		default: Response.ContentType = "image/jpeg"; break;
	}
	memorystream.WriteTo( Response.OutputStream );
}
</script>