<h2>wbResize (ic.image.resizer)</h2>
<p>wbResize (chiamato anche ic.image.resizer all'interno del namespace IC) è una semplice classe che si occupa di ridimensionare e salvare e/o visualizzare immagini.</p>
<p>Esistono due "versioni" della classe: la prima è orientata all'utlizzo direttamente da ASP, la seconda è orientata al mondo ASP.net (ne esiste poi una terza in versione dll per la programmazione in ambiente .net, chiamata appunto ic.image.resizer di cui questa documentazione non si occuperà).</p>
<p><a href="#class">documentazione alla classe wbResize</a><br/>
<a href="#asp">documentazione specifica versione per ASP 3.0</a><br/>
<a href="#aspx">documentazione specifica versione per ASP.net</a></p>
<hr/><hr/><hr/>
<a id="class"></a>
<h2>La classe wbResize</h2>
<p>La classe wbResize (che nella versione DLL si chiama ic.image.resizer, quindi semplicemente "resizer") è colei che effettua il ridimensionamento ed è estremamente facile da utilizzare: vediamone i metodi e subito dopo del codice di esempio<br />
(per informazioni particolareggiate circa l'utilizzo in ambiente ASP e ASP.net vedere più in fondo)</p>
<hr/>
<h3>Metodi</h3>

<p><b>LoadImage(string path)<br/>LoadImage(Stream stream)<br/>LoadImage(System.Drawing.Image image)</b><br />
LoadImage è metodo atto al caricamento dell'immagine in memoria: è possibile passare come parametro una path (in ASP.net ricordarsi di utilizzare Server.MapPath per definire un percorso), oppure uno Stream o infine direttamente una immagine (Image).<br />
[GENERA ERRORI DA GESTIRE NEL CASO L'IMMAGINE NON ESISTA O NON SIA VALIDA]</p>

<p><b>UnloadImage()</b><br/>Scarica l'immagine dalla memoria.</p>

<p><b>SetThumbSize(double requestedWidth, double requestedHeight)<br />SetThumbSize(double requestedWidth, double requestedHeight, bool forceDimension)<br />SetThumbSize(int scaleFactor)<br />SetThumbSize(double requestedWidth, double requestedHeight, int scaleFactor, bool forceDimension, bool allowSuperSize))</b><br />
Tramite SetThumbSize (metodo OPZIONALE) è possibile impostare una dimensione per il ridimensionamento.<br />
Sono vari i meccanismi di impostazione, ma in ogni caso la priorità viene data a ScaleFactor e poi alle due dimensioni<br />
Se indicato ScaleFactor diverso da 0 [valore da 1 a 100] l'immagine verrà ridimensionata secondo tale fattore percentuale.<br />
Se indicato Width = 0 e un valore di Height (o viceversa) l'immagine verrà ridimensionata proporzionalmente in base al parametro dato.<br />
Se indicato sia Width che Height l'immagine verrà racchiusa in un riquadro delle dimensioni massime indicate in Width e Height.<br />
Se indicato forceDimension = true invece che proporzionalmente l'immagine verrà forzata ai valori Width e Height indicati.<br />
allowSuperSize permette che i valori di Width e Height che superano la dimensione dell'originale vengano accettati così come scaleFactor superiori a 100<br />
<em>In alternativa si possono impostare manualmente valori di Width e Height da utilizzare per il ridimensionamento accedendo alle proprietà pubbliche "thumbWidth" e "thumbHeight".</em></p>

<p><b>SetFileType(string filetype)</b><br />
Imposta il tipo di file in output.<br />
Valori accettati "jpg","gif","tiff","png","bmp"
[a seconda del tipo di output verranno utilizzate le opzioni relative]
</p>

<p><b>SetOptionJpegQuality(int jpegquality)</b><br />
Imposta il livello di qualità delle immagini JPEG [valore 0-100]
</p>

<p><b>SetOptionTiffCompress(bool tiffcompress)</b><br />
Imposta la compressione LZW per le immagini TIFF.
</p>

<p><b>SetOptionHighQuality(bool highquality)</b><br />
Imposta l'alta qualità per il ridimensionamento (sostanzialmente effetti di correzione dell'immagine per aumentare la qualità della thumb)
</p>

<p><b>SetOptionFilter(InterpolationMode filter)</b><br />
Imposta il filtro di Interpolazione per il ridimensionamento.<br />
E' consigliato l'uso del filtro Bicubico ad alta qualità.<br />
[L'opzione è attiva solo se è impostata HIGHQUALITY = TRUE]
</p>

<p><b>SetOptionGifDepth(byte gifdepth)</b><br />
Imposta la profondita di colore per le GIF.<br />
Accetta<br />
0 = nessuna quantizzazione [il sistema utilizza il normale sistema di compressione di bassa qualità di GDI+]<br />
1 = 1bit<br />
2 = 2bit<br />
4 = 4bit<br />
8 = 8bit<br />
255 = Grayscale (sperimentale)
</p>

<p><b>SetOptionGifPalette(byte gifpalette)</b><br />
Imposta il numero di colori in Palette GIF<br />
Accetta valori da 9 a 255
</p>

<p><b>SetOptions(string filetype, int compression, bool highquality, InterpolationMode filter, byte gifpalette, byte gifdepth)</b><br />
Tramite questa funzione unica è possibile impostare tutti i parametri in un'unica passata.    
</p>

<p><b>ResizeAndSave(string fileoutput)</b>
Effettua il ridimensionamento e salva il risultato nel file indicato<br />
[GENERA ERRORI DA GESTIRE NEL CASO L'IMMAGINE NON ESISTA O NON SIA VALIDA]</p>

<p><b>MemoryStream Resize()</b><br />
Effettua il ridimensionamento e restituisce un MemoryStream<br />
[GENERA ERRORI DA GESTIRE NEL CASO L'IMMAGINE NON ESISTA O NON SIA VALIDA]<br />
<pre>//esempio
System.Drawing.Image myThumb = System.Drawing.Image.FromStream(Resize());</pre></p>

<p><b>string Report(string key)</b><br />
Restituisce dati sul ridimensionamento e sull'immagine in formato String.<br />
Se non impostato il parametro key restituisce un'unica stringa riassuntiva.<br />
Le key accettate sono: "width", "height", "filetype", "jpegquality", "gifpalette", "gifdepth", "tiffcompress", "filter", "size"
</p>

<hr/>
<p>
Come si può facilmente intuire si possono eseguire più ridimensionamenti di seguito dopo aver caricato una immagine.<br />
Vediamo un piccolo codice di esempio assumendo che in "System.Drawing.Image myImage" ci sia già caricata l'immagine che vogliamo ridimensionare</p>
<pre>
ic.image.resizer ImageResizer = new ic.image.resizer(); //versione DLL
//wbResize ImageResizer = new wbResize(); //versione ASP.NET

try {
    ImageResizer.LoadImage(myImage);
    ImageResizer.SetOptionHighQuality(true);
    ImageResizer.SetThumbSize(50);
    ImageResizer.SetOptionFilter(InterpolationMode.HighQualityBicubic); //InterpolationMode fa parte del namespace "System.Drawing.Drawing2D"
    //ImageResizer.SetOptionTiffCompress(true); //solo per TIFF
    //ImageResizer.SetOptionGifPalette(255); //solo per GIF
    //ImageResizer.SetOptionGifDepth(8); //solo per GIF
    ImageResizer.SetFileType("jpg");
    ImageResizer.SetOptionJpegQuality(100);

    picImage.Image = System.Drawing.Image.FromStream(ImageResizer.Resize()); //visualizziamo l'immagine ridimensionata in una PictureBox
    lblStatus.Text = ImageResizer.Report(); //stampiamo un report in una label
}
catch(Exception ex)
{
    MessageBox.Show(ex.Message);
}
ImageResizer.UnloadImage();
ImageResizer = null;
</pre>
<p>Tramite questo semplice codice prendiamo una immagine (presente in myImage) e la ridimensioniamo al 50% usando filtri di alta qualità e visualizziamo il risultato in PictureBox.</p>
<hr/><hr/><hr/>
<a id="asp"></a>
<h2>Versione per ASP 3.0</h2>
<p>La versione orientata ad ASP3 si presenta come un unico file denominato wbresize.aspx nel quale è contenuto tutto il codice necessario al corretto funzionamento e le varie classi.<br/>
L'idea alla base di questa versione è che wbresize sia utilizzato come un "servizio" (che non necessità di installazione ne di registrazioni particolari!) per siti sviluppati in ASP che necessita di un ridimensionamento.</p>
<p>E' possibile utilizzare wbResize per ASP3 in modalità salvataggio o ridimensionamento onthefly. In entrambi i casi il metodo di interfaccia fra ASP e wbResize è alquanto spartano ma efficace: la pagina wbresize.aspx viene richiamata con un link (o redirect) per la modalità salvataggio e direttamente nell'SRC di una &lt;img&gt; per la modalità on the fly.<br />
I parametri vengono poi impostati tramite la querystring.</p>
<p>Per una completa lista e una spiegazione esauriente delle impostazioni di wbresize per ASP3 aprire wbresize.aspx e visualizzare le prime linee commentate; vi troverete una lista dei parametri e informazioni circa la variabili di personalizzazione</p>
<hr/><hr/><hr/>
<a id="aspx"></a>
<h2>Versione per ASP.net</h2>
<p>La versione orientata ad ASP.net è più articolata e consiste in due file .cs (wbresize.cs e quantizer.cs) che verranno inclusi nelle pagine che dovranno sfruttare la classe. All'interno dello zip vi sono due demo funzionanti di un utilizzo onthefly e di uno per il ridimensionamento e salvataggio (in cui è presentato in aggiunta anche un veloce uploader).</p>
<p>E' possibile utilizzare wbResize per ASP.net in modalità salvataggio o ridimensionamento onthefly.<br />
Nella modalità salvataggio è necessario includere il seguente codice in ogni pagina che utilizza wbresize per avere a disposizione la classe (supponendo che wbresize.cs e quantizer.cs siano posizionati nella cartella wbresize).</p>
<pre>
&lt;%@ Import Namespace="System" %&gt; 
&lt;%@ Import Namespace="System.IO" %&gt; 
&lt;%@ Import Namespace="System.Drawing" %&gt; 
&lt;%@ Import Namespace="System.Drawing.Imaging" %&gt; 
&lt;%@ Import Namespace="System.Drawing.Drawing2D" %&gt; 
&lt;%@ Import Namespace="System.Collections" %&gt; 
&lt;%@ Import Namespace="System.Runtime.InteropServices" %&gt; 
&lt;%@ Import Namespace="System.Globalization" %&gt; 
&lt;script Language="C#" runat="server" src="wbresize/wbresize.cs"&gt;&lt;/script&gt;
&lt;script Language="C#" runat="server" src="wbresize/quantizer.cs"&gt;&lt;/script&gt;
</pre>
<p>Nella modalità onthefly è necessario scrivere una pagina apposita che utilizzando wbresize, proprio come nella modalità salvataggio, dia come ritorno l'immagine e che quindi possa essere immessa direttamente in un SRC di una &lt;img&gt;.<br />
Ecco un esempio di una pagina che esegue questo tipo di funzione accettando come parametro querystring la tipologia di file di output:</p>
<pre>
&lt;%@ Page Language="C#" LCID=1040 Debug="true" Trace="false" %&gt; 
&lt;%@ Import Namespace="System" %&gt; 
&lt;%@ Import Namespace="System.IO" %&gt; 
&lt;%@ Import Namespace="System.Drawing" %&gt; 
&lt;%@ Import Namespace="System.Drawing.Imaging" %&gt; 
&lt;%@ Import Namespace="System.Drawing.Drawing2D" %&gt; 
&lt;%@ Import Namespace="System.Collections" %&gt; 
&lt;%@ Import Namespace="System.Runtime.InteropServices" %&gt; 
&lt;%@ Import Namespace="System.Globalization" %&gt;
&lt;script Language="C#" runat="server" src="wbresize/wbresize.cs"&gt;&lt;/script&gt;
&lt;script Language="C#" runat="server" src="wbresize/quantizer.cs"&gt;&lt;/script&gt;
&lt;script Language="C#" runat="server"&gt;

string ThumbType = "";

void Page_Load(object sender, System.EventArgs e)
{	
ThumbType = (Request.QueryString["t"]==null)?"":Request.QueryString["t"];

wbResize ImageResizer = new wbResize();

ImageResizer.LoadImage(Server.MapPath("myimage.jpg"));		//accetta path, image e stream
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

&lt;/script&gt;
</pre>
<p>Supponendo che questa pagina si chiami "thumb.aspx" possiamo avere</p>
<pre>&lt;img src="thumb.aspx?t=jpg" /&gt;</pre>
<p>che effettua il ridimensionamento on the fly di myimage.jpg in formato jpg in un riquadro 500x500 con alta qualità di resample.</p>
<hr/>
<p>Per maggiori informazioni ed esempi pratici vedere i file contenuti nello zip della versione wbResize ASP.net</p>
<hr/>
