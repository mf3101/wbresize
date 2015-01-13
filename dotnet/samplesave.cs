public string thumbtype = "jpg";
public System.Web.UI.WebControls.Image[] ResultImages = new System.Web.UI.WebControls.Image[4];
public System.Web.UI.WebControls.Label Status = new System.Web.UI.WebControls.Label();

void Page_Load(object sender, System.EventArgs e)
{	
	for (int i = 0; i < ResultImages.Length;i++) {
		ResultImages[i] = new System.Web.UI.WebControls.Image();
		Controls.AddAt(Controls.Count - 1, ResultImages[i]);
	}
	Controls.AddAt(Controls.Count - 1, Status);
}
  
void SubmitFiles(Object sender, EventArgs e)
{
	HttpFileCollection uploadedFiles = Request.Files;
	thumbtype = ThumbType.Value;
	Status.Text = "<hr/><p><strong>Uploading...</strong><br/>"; 
	string path = "";
	string filename = "";
		
	for (int i = 0; i < uploadedFiles.Count; i ++)  
	{
		if (uploadedFiles[i].FileName!="") {
			filename = "upload/" + uploadedFiles[i].FileName + ".thumb." + thumbtype;
			Status.Text += "<span class=\"status\">" + filename + " uploaded</span><br/>"; 
			Resize(uploadedFiles[i],filename);
			ResultImages[i].ImageUrl = filename;
		}
		else
		{
			ResultImages[i].ImageUrl = "";
			Status.Text += "<span class=\"status\">" + "No file specified in field " + (i+1) + "</span><br/>"; 
		}
	}
	Status.Text += "</p><hr/>"; 
	
}

void Resize(HttpPostedFile file, string filename)
{
	try {
		wbResize ImageResizer = new wbResize();
		
		ImageResizer.LoadImage(file.InputStream);		//accetta path, image e stream
		ImageResizer.SetFileType(thumbtype);			//Tipo di output [jpg, gif, bmp, tiff, png]
		ImageResizer.SetThumbSize(500, 500, false);		//Width, Height e forzatura
		//ImageResizer.SetThumbSize(50); 				//IMPOSTA LA % DELL'ORIGINALE
		
		ImageResizer.SetOptionHighQuality(true);		//Alta qualità
		ImageResizer.SetOptionJpegQuality(100);			//Qualità JPEG
		ImageResizer.SetOptionFilter(InterpolationMode.HighQualityBicubic); //Filtro di Interpolazione
		ImageResizer.SetOptionGifDepth(4);				//Profondità colore GIF [0 = off, 1, 2, 4, 8, 255 = grayscale]
		ImageResizer.SetOptionGifPalette(255);			//Dimensione Palette GIF [9-255]
		ImageResizer.SetOptionTiffCompress(true);		//Compressione TIFF
		
		/* DATI IN STREAM */
		//MemoryStream stream = ImageResizer.Resize();
		
		/* SALVATAGGIO SU PATH */
		ImageResizer.ResizeAndSave(Server.MapPath(filename));
		Status.Text += "<span class=\"status\">" + filename + " resized [" + ImageResizer.Report("size") + "]</span><br/>"; 
	}
	catch 
	{
		Status.Text += "<span class=\"error\">" + filename + " resize error</span><br/>"; 
	}
}