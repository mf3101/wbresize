<%@ Page Language="C#" LCID=1040 Debug="false" Trace="false" %> 
<%@ Import Namespace="System" %> 
<%@ Import Namespace="System.IO" %> 
<%@ Import Namespace="System.Drawing" %> 
<%@ Import Namespace="System.Drawing.Imaging" %> 
<%@ Import Namespace="System.Drawing.Drawing2D" %> 
<%@ Import Namespace="System.Collections" %> 
<%@ Import Namespace="System.Runtime.InteropServices" %> 
<%@ Import Namespace="System.Globalization" %> 
<script runat="server">
/*  WBRESIZE 0.42 [ASP3 version]
	by imente 27/05/2008
	http://www.imente.org/short/wbresize
	
	**********************************************************************************
	
	WBRESIZE è rilasciato sotto licenza MIT

        The MIT License (MIT)

        Copyright (c) 2006-2015 Simone Cingano

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in
        all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
        THE SOFTWARE.
	
	**********************************************************************************
	
	QUESTA E' LA VERSIONE PER ASP
	se cerchi la versione per ASP.net vieni sul sito
	
	**********************************************************************************
	
	CHANGELOG:

    v 0.42 (2015)
        - licenza MIT
	
	v 0.41 (27/05/2008)
		- migliore gestione risorse
		- bugfix blocco immagine (rimaneva aperta e bloccava la cancellazione)
		- bugfix redirect
		
	v 0.4 (27/03/2008)
		- aggiunta classe per la quantizzazione della palette gif
		- aggiunti parametri per l'elaborazione gif [b,g]
		- aggiunto parametro di selezione tipo di interpolazione [i]
		- ottimizzazione della classe
		- incluso quantizzatore per la generazione delle gif
		- aggiunto meccanismo di supersize (permette sovradimensionamento) [a]
		
	v 0.3 (09/09/2007)
		- aggiunta funzione di cancellazione file originale
		- modifica redirect errori
		- fix bug su redirect (possibili loop)
		- nuovo algoritmo di ridimensionamento e compressione
		- supporto output per file "jpg", "gif", "png", "tiff" e "bmp"
		- spostate le funzioni di elaborazione nella classe wbResize
		
	v 0.22 (23/10/2006)
		- redirezione in caso di errore
		- controllo referrers (disattivabile) per sicurezza
	
	v 0.21 (16/10/2006)
		- introdotta compressione jpeg
		- bugfix ridimensionamento
	
	v 0.2  (15/10/2006)
		- prima versione pubblica
	
	**********************************************************************************
	
	UTILIZZO:
	la pagina viene richiamata tramite un link (per salvare immagini) oppure come argomento SRC
	di un tag immagine (img).
	
	**********************************************************************************
	
	vediamo i parametri passati a wbresize.aspx in querystring:

	PARAMETRI (da querystring) [f, s, w, h, o, a, y, q, i, c, b, g, t, n, d, r, k, e]
	
		f = nome del file originale
		
		s = percentuale di ridimensionamento (es: 20)
		w = larghezza fissata (la altezza viene calcolata di conseguenza per mantenere le dimensioni)
		h = altezza fissata (la larghezza viene calcolata di conseguenza per mantenere le dimensioni)
			*** si può indicare S oppure W oppure H. se si indica S, W e H vengono ignorati.
			*** se si indica sia W che H dipende dall'impostazione di O
			
		o = forza dimensioni ("o" di otranto)
			*** nel caso si indichi sia W che H se
			*** o = 1 => forza le dimensioni a W e H
			*** o = 0 => rimpicciolisce l'immagine senza forzare le dimensioni per farla
			***			 stare nel riquadro W e H richiesto
			
		a = permetti sovradimensionamento
			*** permette che i valori di W e H siano superiori all'originale
			*** o che si imposti un S superiore a 100
		
		y = tipo di file
			*** se non impostato utilizza jpg
			*** valori accettati "jpg", "gif", "png", "tiff", "bmp"
			
		q = alta qualità output
			*** l'alta qualità sfrutta alcuni algoritmi per ottimizzare le immagini
			*** (non influisce particolarmente sulle dimensioni del file poiché
			***  lavora sull'algoritmo di ridimensionamento)
			*** HA COME SVANTAGGIO UN CARICO DI CPU MAGGIORE [non utilizzare per molte immagini in sequenza)
			*** valori 1 / 0 ***
			
		i = tipo di interpolazione [viene attivato solo se q = 1]
			*** 0 = Nearest Neiborgh [decisamente poco valido]
			*** 1 = Bilineare
			*** 2 = Bicubica [il migliore]
		
		c = compressione jpeg (valori da 1 a 100) [utilizzato solo per Y = "jpg"
			*** se non impostata la compressione viene impostata a 75
			
		b = profondità di colore gif
			*** 0 = quantizzazione non attivata
			***		[la quantizzazione permette una buona elaborazione delle gif
			***		aumenta per contro il carico]
			***	1 = 1 bit
			*** 2 = 2 bit
			*** 4 = 4 bit
			*** 8 = 8 bit
			
		g = palette gif
			*** valore da 9 a 255
			*** il valore non viene utilizzato se b = 0
		
		t = cartella dove salvare la thumb
			*** E' IMPORTANTE CHE LA CARTELLA ABBIA IMPOSTATI I DIRITTI DI SCRITTURA!
		
		n = nome della thumb (se non indicato utilizza "thumb")
		    *** NON INDICARE L'ESTENSIONE DEL FILE, VIENE AGGIUNTA AUTOMATICAMENTE!!!
			*** se non si indica T la thumb viene restituita direttamente (on the fly)
			*** se si indica T la thumb viene salvata
			***    la cartella indicata NON deve terminare con /
			***    e inoltre DEVE possedere permessi di scrittura
			
		d = al termine dell'operazione di ridimensionamento e salvataggio del file ridimensionato
			il file originale viene cancellato dal server
			*** valori 1 / 0 ***
			*** per utilizzare questo parametro è necessario impostare a TRUE
			*** la variabile "deletePermitted", altrimenti questo parametro verrà ignorato
		
		r = pagina a cui redirigersi dopo aver effettuato il resize
			*** se non indicato si redirige alla thumb
			*** se si vuole indicare una pagina con anche querystring utilizzare al posto di & il %26
			***   es: wbresize.aspx?f=immagine.jpg......&r=pagina.asp?param1=a%26param2=b%26param3=c
		
		k = chiave di controllo
			*** vedi più in basso alla voce CHIAVE DI CONTROLLO
		
		e = pagina a cui redirigere in caso di errore
			*** vedi più in basso alla voce PAGINA DI ERRORE
	
	**********************************************************************************
		
	ESEMPIO DI SALVATAGGIO:
	
		salvataggio di una immagine ridimensionata
		
		<a href="wbresize.aspx?f=immagini/immagine.jpg&c=100&h=90&t=public/thumbs&n=thumb&r=ok.asp&e=error.asp?c=">ridimensiona</a>
		
		l'immagine "immagini/immagine.jpg" viene ridimensionata ad altezza 90pixel e
		larghezza proporzionale, con qualità jpeg del 100% e salvata nella
		cartella "public" col nome "thumb.jpg"
		
		se l'operazione va a buon fine si viene mandati alla pagina "ok.asp"
		altrimenti alla pagina "error.asp?c=x" (dove x è il codice di errore)
	
	**********************************************************************************
		
	ESEMPIO DI RIDIMENSIONAMENTO ON THE FLY:
	
		visualizzazione di una immagine ridimensionata
		
		<img src="wbresize.aspx?f=immagini/immagine.jpg&c=100&h=90&e=" alt="thumb" />
		
		l'immagine "immagini/immagine.jpg" viene ridimensionata ad altezza 90pixel e
		larghezza proporzionale, con qualità jpeg del 100% e visualizzata direttamente
		
		in caso di errore viene visualizzata un'immagine che definisce l'errore
	
	**********************************************************************************



**********************************************************************************
     >>> AREA DI PERSONALIZZAZIONE <<<
**********************************************************************************
vi sono alcune variabili da impostare, dettagliatamente spiegate qui di seguito
non modificare niente al di fuori dell'area di personalizzazione


/**** CONTROLLO REFERRERS
*** il controllo dei referrers viene eseguito confrontando il referrer (pagina da cui
*** proviene l'utente o la richiesta) da quella indicata nella variabile seguente
*** questo sistema previene l'utilizzo di WBRESIZE da pagine esterne al tuo sito
*** o da richieste dirette.
*** PER IL CONTROLLO INDICARE l'indirizzo base del sito
		(es: per utilizzi sul sito			baseAddress = "http://www.miosito.it",
			 oppure per utilizzi locali 	baseAddress = "http://localhost"  )
*** OPPURE PER DISATTIVARE IL CONTROLLO dei referrers indicare una stringa vuota ( baseAddress = "" ) */
string baseAddress = "";


/**** CHIAVE DI CONTROLLO
*** la chiave di controllo è una stringa alfanumerica personalizzabile che viene
*** confrontanta con il valore K preso in querystring.
*** l'esecuzione di wbresize è permessa SOLO se le chiavi corrispondono.
*** lasciare la stringa vuota per disattivare il controllo.
*** [la chiave è un ulteriore meccanismo di controllo che evita che utenti
***  malintenzionati possano eseguire wbresize arbitrariamente.
***  il suo utilizzo è consigliato solo se wbresize è eseguito in pagine protette
***  e non accessibili da qualsiasi utente, come ad esempio pannelli di amministrazione]
***
*** !!! DA UTILIZZARSI ESCLUSIVAMENTE SE WBRESIZE.ASPX VIENE ESEGUITO IN PAGINE
***		PROTETTE, POICHE' ALTRIMENTI LA CHIAVE PUO' ESSERE LETTA IN QUERYSTRING !!!
***
*/
string keyCheck = "";


/**** PAGINA DI ERRORE (es: errors.asp)
*** se si indica una pagina di errore tutti gli errori saranno dirottati
*** a tale pagina (aggiungendo in fondo X, ovvero il numero dell'errore)
*** es: wbresize.aspx?e=myerror.asp?code= --> errore --> redirezione a myerror.asp?code=0
*** ERRORI:
***   0 = nessun parametro impostato
***   1 = nessuna immagine indicata
***   2 = immagine indicata inesistente
***   3 = referrer non valido (accesso da sito esterno, vedi CONTROLLO REFERRERS)
***   4 = nessun referrer ricevuto / accesso diretto
***   5 = elaborazione onthefly non permessa
***   6 = chiave non corrispondente
***
*** >>> è possibile modificare l'impostazione base indicando in querystring la variabile E
*** >>> se si indica    e=pagina.asp?c=     la variabile diventerà "pagina.asp?c="
*** >>> se si indica    e=               	la variabile diventerà ""
*** >>> se non si indica la variabile rimane impostata come di seguito
***
*** !!! LA PAGINA DI ERRORE E' UTILE SE SI UTILIZZA WBRESIZE PER SALVARE
***     DELLE IMMAGINI RIDIMENSIONATE !!!
***
*/
string errorRedirect = "";


/**** IMMAGINI DI ERRORE
*** indicare la cartella dove si trovano le immagini di errore (chiamate wbresize_errX.gif,
*** dove X è il codice dell'errore).
***
*** !!! LE IMMAGINI DI ERRORE SONO UTILI SE SI UTILIZZA WBRESIZE PER VISUALIZZARE
***     IMMAGINI RIDIMENSIONATE ON THE FLY !!!
***
*/
string errorImagePath = "images/";


/**** CONTROLLO VALIDITA' REFERRERS (per redirect)
*** indica se deve essere eseguito un controllo sui referrers al fine di evitare
*** che la pagina a cui viene eseguita la redirezione sia la stessa da cui si proviene
*** questo evita che malintenzionati possano eseguire loop
*** [ATTIVARE SOLO NEL CASO IN CUI ESISTANO PAGINE CHE PUNTANO AUTOMATICAMENTE
***  A WBRESIZE.ASPX, PER ESEMPIO CON UN RESPONSE.REDIRECT ]
*/
bool checkReferrers = false;


/**** ATTIVO ONTHEFLY
*** indica se deve essere permessa l'elaborazione onthefly (quando cioè non viene salvato
*** il file ridimensionato ma viene esclusivamente "stampato" come output)
*/
bool ontheflyActive = true;


/**** CANCELLAZIONE PERMESSA
*** determina se lo script ha la facoltà di cancellare file
*** nel caso non si voglia utilizzare il parametro D (vedi sopra)
***
*** se si utilizza il parametro D è necessario impostarlo a TRUE
***
*** E' CALDAMENTE SCONSIGLIATO L'UTILIZZO DELLA CANCELLAZIONE!!!
*** è possibile infatti aggirare il controllo dei referrer e quindi
*** cancellare file nelle cartelle con permessi di scrittura da
*** parte di utenti malintenzionati!
*/
bool deletePermitted = false;

/*
**********************************************************************************
     >>> FINE AREA DI PERSONALIZZAZIONE <<<
**********************************************************************************
non modificare il codice sottostante a meno che
non si sia consapevoli di ciò che si sta facendo
*********************************************************************************/


void Page_Load(Object sender, EventArgs e) {
	
	// parametri
	string fileName = (Request.QueryString["f"]==null)?"":Request.QueryString["f"]; // nome del file originale
	string folder = (Request.QueryString["t"]==null)?"":Request.QueryString["t"]; // cartella dove salvare la thumb
	string newName = (Request.QueryString["n"]==null)?"thumb":Request.QueryString["n"]; // nuovo nome del file
	string redirect = (Request.QueryString["r"]==null)?"":Request.QueryString["r"]; // redirezione dopo save
	if (folder!="") { errorRedirect = (Request.QueryString["e"]==null)?errorRedirect:Request.QueryString["e"]; } // redirezione inerrore
	double requestedWidth = (Request.QueryString["w"]==null)?0:Convert.ToDouble(Request.QueryString["w"]); // larghezza impostata
	double requestedHeight = (Request.QueryString["h"]==null)?0:Convert.ToDouble(Request.QueryString["h"]); // altezza impostata
	bool forceDimension = (Request.QueryString["o"]==null)?false:Convert.ToBoolean(Convert.ToInt32(Request.QueryString["o"])); // forza dimensioni (0/1)
	int scaleFactor = (Request.QueryString["s"]==null)?0:Convert.ToInt32(Request.QueryString["s"]); // fattore di scalo per la miniatura
	bool allowSupersize = (Request.QueryString["a"]==null)?false:Convert.ToBoolean(Convert.ToInt32(Request.QueryString["a"])); // permetti sovradimensionamento
	int jpgCompression = (Request.QueryString["c"]==null)?75:Convert.ToInt32(Request.QueryString["c"]); // compressione (0-100)
	string fileType = (Request.QueryString["y"]==null)?"":Request.QueryString["y"]; // tipo di file in output
	string key = (Request.QueryString["k"]==null)?"":Request.QueryString["k"]; // chiave di controllo
	bool delete = (Request.QueryString["d"]==null)?false:Convert.ToBoolean(Convert.ToInt32(Request.QueryString["d"])); // cancella originale (0/1)
	bool highQuality = (Request.QueryString["q"]==null)?true:Convert.ToBoolean(Convert.ToInt32(Request.QueryString["q"])); // alta qualità (0/1)
	int gifPalette = (Request.QueryString["g"]==null)?255:Convert.ToInt32(Request.QueryString["g"]); // alta qualità (0/1)
	int gifDepth = (Request.QueryString["b"]==null)?4:Convert.ToInt32(Request.QueryString["b"]); // alta qualità (0/1)
	int Interpolation = (Request.QueryString["i"]==null)?2:Convert.ToInt32(Request.QueryString["i"]); // alta qualità (0/1)
	InterpolationMode Filter = new InterpolationMode();
	if (keyCheck!=key && keyCheck!="") { error(6); return; }
	
	//istanza della classe wbResize
	wbResize wbresize = new wbResize();
	
	//recupera il referrer
	string referrer = (Request.UrlReferrer==null?"":Request.UrlReferrer.ToString());
	
	//normalizza il filetype ai tipi supportati
	if (fileType!="gif" && fileType!="png" && fileType!="bmp" && fileType!="tiff") fileType = "jpg";
	
	//normalizza la compressione jpeg
	if (jpgCompression > 100) jpgCompression = 100;
	if (jpgCompression < 0) jpgCompression = 0;
	
	//normalizza la palette gif
	if (gifPalette < 9) gifPalette = 9;
	if (gifPalette > 255) gifPalette = 255;
	
	//normalizza la profondità di colore gif
	if (gifDepth != 0 && gifDepth != 1 && gifDepth != 2 && gifDepth != 4 && gifDepth != 8 && gifDepth != 255) gifDepth = 4;
	
	//normalizza l'interpolazione
	switch(Interpolation) {
		case 0: Filter = InterpolationMode.NearestNeighbor; break;
		case 1: Filter = InterpolationMode.HighQualityBicubic; break;
		case 2: Filter = InterpolationMode.HighQualityBilinear; break;
	}
	
	//elimina le querystring dai redirect (per i controlli di validità)
	int querystring;
	string checkreferrer = referrer;
	string checkredirect = redirect;
	querystring = referrer.IndexOf("?");
	if (querystring>0) checkreferrer = referrer.Substring(0,querystring);
	querystring = redirect.IndexOf("?");
	if (querystring>0) checkredirect = redirect.Substring(0,querystring);
	
	//controllo redirect (vieta redirect a questa pagina) [SEMPRE ATTIVO]
	redirect = (redirect.IndexOf("wbresize.aspx")==-1?redirect:"");
	//controllo redirect (vieta redirect alla pagina da cui è giunta la richiesta)
	if (checkReferrers) redirect = (checkreferrer.IndexOf(checkredirect)==-1?redirect:"");
	if (redirect=="") redirect = folder+"/"+newName+"."+fileType;
	
	
	//se il controllo dell'indirizzo base è attivo controlla la validità dei referrers
	if (baseAddress != "") {
		if (!(referrer=="")) {
			if (referrer.Substring(0, baseAddress.Length)!=baseAddress) {
				//referrer non corrispondente al sito
				error(3);return;
			}
		} else {
			//referrer nascosto
			error(4);return;
		}
	}
	
	if ( fileName.Trim().Length>0 ) {
			
		wbResize ImageResizer = new wbResize();
		try {
			//istanzia le variabili necessarie all'elaborazione
			bool saved = false;
			string fileoutput = "";
		
			ImageResizer.LoadImage(Server.MapPath(fileName));
			ImageResizer.SetFileType(fileType);
			ImageResizer.SetThumbSize(requestedWidth, requestedHeight, scaleFactor, forceDimension, allowSupersize);
			if (ImageResizer.thumbWidth==0&&ImageResizer.thumbHeight==0) { error(0); return; }
			ImageResizer.SetOptionHighQuality(highQuality);
			ImageResizer.SetOptionJpegQuality(jpgCompression);
			ImageResizer.SetOptionFilter(Filter);
			ImageResizer.SetOptionGifDepth((byte)gifDepth);
			ImageResizer.SetOptionGifPalette((byte)gifPalette);
			ImageResizer.SetOptionTiffCompress(true);
			
			// esegue le operazioni di elaborazione dell'immagine
			if ( folder != "" ) {
				// output su file
				fileoutput = Server.MapPath(folder+"\\"+newName + "." + fileType);
				ImageResizer.ResizeAndSave(fileoutput);
				if (delete && deletePermitted) System.IO.File.Delete(Server.MapPath(fileName));
				Response.Redirect(redirect,false);
			} else if (ontheflyActive) {
				// output diretto
				fileoutput = "";
				print(ImageResizer.Resize(),fileType);
			} else {
				//ERR: se ontheflyactive non è attivo ed è richiesta
				//elaborazione onthefly restituisce errore
				error(5);
			}
			
		} catch (System.IO.FileNotFoundException ex) {
			// ERR: immagine inesistente
			error(2);
		} catch (Exception ex) {
			// ERR: altro errore (permessi ad esempio)
			error(99);
		} finally {
			ImageResizer.UnloadImage();
			ImageResizer = null;
		}
	} else {
		// ERR: nessuna immagine indicata
		error(1);
	}
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

private void error(int error) {
	// errore: visualizza una immagine di errore o redirige alla pagina di errore
	try {
		if (errorRedirect != "") {
			Response.Redirect(errorRedirect + error,false);
		} else {
			System.Drawing.Image errImage;
			errImage = System.Drawing.Image.FromFile( Server.MapPath(errorImagePath+"wbresize_err"+error+".gif") );
			Response.ContentType = "image/gif";
			errImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Gif );
			errImage.Dispose();
			errImage = null;
		}
    } catch (System.IO.FileNotFoundException) {
		Response.Write("WBRESIZE ERROR CODE "+error);
        Response.End();
    }
}

/*
**********************************************************************************
     >>> WBRESIZE.cs <<<
**********************************************************************************
*/

public class wbResize
{

	public int thumbWidth = 0;
	public int thumbHeight = 0;
	private string FileType = "jpg"; //jpg,gif,bmp,tiff,png

	private System.Drawing.Image rImage = null;
	private int originalWidth = 0;
	private int originalHeight = 0;
	int JpegQuality = 100;  //0-100
	bool TiffCompress = true;
	bool HighQuality = true;
	InterpolationMode Filter = InterpolationMode.Low;
	byte GifPalette = 255;  //9-255
	byte GifDepth = 8;      //0,255,1,2,4,8
	long ByteSize;

	/****************************************************************************************/
	/****************************************************************************************/

	public void LoadImage(string path)
	{
		if (!File.Exists(path)) { throw new FileNotFoundException(); }
		try { LoadImage(System.Drawing.Image.FromFile(path)); }
		catch { throw new FileNotFoundException(); }
	}
	public void LoadImage(Stream stream)
	{
		try { LoadImage(System.Drawing.Image.FromStream(stream)); }
		catch { throw new FileNotFoundException(); }
	}
	public void LoadImage(System.Drawing.Image image)
	{
		rImage = new Bitmap(image);
		originalWidth = image.Width;
		originalHeight = image.Height;
		image.Dispose();
		image = null;
	}
	public void UnloadImage()
	{
		if (rImage!=null) rImage.Dispose();
		rImage = null;
	}

	/****************************************************************************************/
	/****************************************************************************************/

	private double scaleProportional(double originalA, double originalB, double requestedA)
	{
		//scala una delle due dimensioni eseguendo una proporzione
		return Math.Ceiling(requestedA * originalB / originalA);
	}

	public void SetThumbSize(double requestedWidth, double requestedHeight)
	{ SetThumbSize(requestedWidth, requestedHeight, 0, false, false); }
	public void SetThumbSize(double requestedWidth, double requestedHeight, bool forceDimension)
	{ SetThumbSize(requestedWidth, requestedHeight, 0, forceDimension, false); }
	public void SetThumbSize(int scaleFactor)
	{ SetThumbSize(0, 0, scaleFactor, false, false); }
	public void SetThumbSize(double requestedWidth, double requestedHeight, int scaleFactor, bool forceDimension, bool allowSuperSize)
	{
		//calcola la dimensione dell'immagine ridotta
		//[restituisce 0,0 in caso di parametri insufficienti]

		int thumbwidth = 0, thumbheight = 0;

		bool executeResize = true;

		if (!allowSuperSize && scaleFactor > 100) scaleFactor = 100;
		if (scaleFactor < 0) scaleFactor = 0;

		//se una dimensione è più grande dell'immagine e l'altra no, 
		//la diminuisce fino a renderla pari all'immagine
		if (!(!forceDimension && requestedHeight != 0 && requestedWidth != 0) && !allowSuperSize)
		{
			if (originalWidth > requestedWidth && originalHeight < requestedHeight) requestedHeight = originalHeight;
			if (originalWidth < requestedWidth && originalHeight > requestedHeight) requestedWidth = originalWidth;
			executeResize = (originalWidth >= requestedWidth && originalHeight >= requestedHeight && scaleFactor >= 0 && scaleFactor < 100);
		}

		if (executeResize)
		{
			//l'immagine è da ridimensionare: calcola le dimensioni della miniatura
			if (scaleFactor == 0)
			{
				if (requestedWidth == 0 && requestedHeight != 0)
				{
					// forzata requestedHeight
					thumbwidth = Convert.ToInt32(scaleProportional(originalHeight, requestedHeight, originalWidth));
					thumbheight = Convert.ToInt32(requestedHeight);
				}
				else if (requestedHeight == 0 && requestedWidth != 0)
				{
					// forzata requestedWidth
					thumbwidth = Convert.ToInt32(requestedWidth);
					thumbheight = Convert.ToInt32(scaleProportional(originalWidth, requestedWidth, originalHeight));
				}
				else if (requestedHeight != 0 && requestedWidth != 0)
				{
					if (forceDimension)
					{
						// forzata sia requestedWidth che requestedHeight
						thumbwidth = Convert.ToInt32(requestedWidth);
						thumbheight = Convert.ToInt32(requestedHeight);
					}
					else
					{
						double newWidth, newHeight;
						// scala le dimensioni in proporzione per mantenerle
						//nel riquadro requestedWidth/requestedHeight
						newHeight = requestedHeight;
						newWidth = scaleProportional(originalHeight, newHeight, originalWidth);
						if (newWidth > requestedWidth)
						{
							newHeight = Convert.ToInt32(scaleProportional(newWidth, requestedWidth, newHeight));
							newWidth = Convert.ToInt32(requestedWidth);
						}
						thumbheight = Convert.ToInt32(newHeight);
						thumbwidth = Convert.ToInt32(newWidth);
						if (thumbwidth > originalWidth && thumbheight > originalHeight && !allowSuperSize)
						{
							thumbheight = originalHeight;
							thumbwidth = originalWidth;
						}
					}
				}
				else //requestedHeight == 0 && requestedWidth == 0
				{
					thumbwidth = 0;
					thumbheight = 0;
				}
			}
			else
			{
				// scalata: percentuale delle dimensioni
				thumbwidth = (originalWidth * scaleFactor / 100);
				thumbheight = (originalHeight * scaleFactor / 100);
			}
		}
		else
		{
			// sovradimensionamento (si impostano le nuove dimensioni a 0 per evitare il ridimensionamento)
			thumbwidth = originalWidth;
			thumbheight = originalHeight;
		}
		thumbWidth = thumbwidth;
		thumbHeight = thumbheight;
	}

	/****************************************************************************************/
	/****************************************************************************************/

	public string Report() { return Report(""); }
	public string Report(string key)
	{
		string output = "";
		string depth = "";
		switch (key.ToLower())
		{
			case "width": output = thumbWidth.ToString(); break;
			case "height": output = thumbHeight.ToString(); break;
			case "filetype": output = FileType; break;
			case "jpegquality": output = JpegQuality.ToString(); break;
			case "gifpalette": output = GifPalette.ToString(); break;
			case "gifdepth": depth = GifDepth.ToString() + " Bit"; if (GifDepth == 255) depth = "Greyscale"; output = depth; break;
			case "tiffcompress": output = TiffCompress.ToString(); break;
			case "filter": output = Filter.ToString(); break;
			case "size": output = Convert.ToString(Math.Round((double)ByteSize / 1024,2)) + " Kb"; break;
			default:
				output = output + FileType + " Image - " + thumbWidth.ToString() + "x" + thumbHeight.ToString();
				switch (FileType)
				{
					case "jpg": output = output + " - Quality " + JpegQuality.ToString() + "%"; break;
					case "gif":
						if (GifDepth != 0) {
							output = output + " - Palette " + GifPalette.ToString();
							depth = GifDepth.ToString() + " Bit";
							if (GifDepth == 255) depth = "Greyscale";
							output = output + " - Color " + depth;
						}
						break;
					case "tiff": output = output + " - Compress " + TiffCompress.ToString(); break;
				}
				output = output + " - Filter " + Filter.ToString();
				output = output + " - Size " + Convert.ToString(Math.Round((double)ByteSize / 1024,2)) + " Kb";
				break;
		}
		return output;
	}

	/****************************************************************************************/
	/****************************************************************************************/

	public void SetFileType(string filetype)
	{
		FileType = filetype.ToLower();
		//normalizza il filetype ai tipi supportati
		if (FileType != "gif" && FileType != "png" && FileType != "bmp" && FileType != "tiff") FileType = "jpg";
	}

	public void SetOptionJpegQuality(int jpegquality)
	{
		JpegQuality = jpegquality;
		if (JpegQuality > 100) JpegQuality = 100;
		if (JpegQuality < 0) JpegQuality = 0;
	}

	public void SetOptionTiffCompress(bool tiffcompress)
	{
		TiffCompress = tiffcompress;
	}

	public void SetOptionHighQuality(bool highquality)
	{
		HighQuality = highquality;
	}

	public void SetOptionFilter(InterpolationMode filter)
	{
		Filter = filter;
	}

	public void SetOptionGifPalette(byte gifpalette)
	{
		GifPalette = gifpalette;
		if (GifPalette < 2) GifPalette = 2;
	}        

	public void SetOptionGifDepth(byte gifdepth)
	{
		GifDepth = gifdepth;
		/* VERSIONE PER ASP */
		if (GifDepth != 0 && GifDepth != 1 && GifDepth != 2 && GifDepth != 4 && GifDepth != 8) GifDepth = 4;
		/* VERSIONE GENERALE 
		if (GifDepth != 0 && GifDepth != 1 && GifDepth != 2 && GifDepth != 4 && GifDepth != 8 && GifDepth != 255) GifDepth = 4;*/
	}

	public void SetOptions(string filetype, int compression, bool highquality, InterpolationMode filter, byte gifpalette, byte gifdepth)
	{
		SetFileType(filetype);
		SetOptionJpegQuality(compression);
		SetOptionHighQuality(highquality);
		SetOptionFilter(filter);
		SetOptionGifPalette(gifpalette);
		SetOptionGifDepth(gifdepth);
	}

	/****************************************************************************************/
	/****************************************************************************************/

	public void ResizeAndSave(string fileoutput)
	{
		//salva su file un'immagine ridimensionandola
		//[in caso di errore restituisce false]

		try
		{
			System.Drawing.Image thumbnail = System.Drawing.Image.FromStream(Resize());
			thumbnail.Save(fileoutput);
			thumbnail.Dispose();
			thumbnail = null;
		}
		catch
		{
			throw new System.ApplicationException("Unable to save the image");
		}
	}

	public MemoryStream Resize()
	{
		//salva su memorystream un'immagine ridimensionandola

		if (rImage == null) throw new System.ApplicationException("Image not loaded!");

		MemoryStream memorystream = new MemoryStream();
		ByteSize = 0;
		try
		{
			System.Drawing.Image thumbnail = new Bitmap(thumbWidth, thumbHeight);
			System.Drawing.Graphics graphic = System.Drawing.Graphics.FromImage(thumbnail);
			if (HighQuality)
			{
				graphic.InterpolationMode = Filter;
				graphic.SmoothingMode = SmoothingMode.HighQuality;
				graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;
				graphic.CompositingQuality = CompositingQuality.HighQuality;
			}
			else
			{
				graphic.InterpolationMode = InterpolationMode.Low;
				graphic.SmoothingMode = SmoothingMode.HighSpeed;
				graphic.PixelOffsetMode = PixelOffsetMode.HighSpeed;
				graphic.CompositingQuality = CompositingQuality.HighSpeed;
			}
			graphic.DrawImage(rImage, 0, 0, thumbWidth, thumbHeight);


			/* EVENTUALI OPERAZIONI SULL'IMMAGINE QUI... */

			EncoderParameters encoderParameters;
			encoderParameters = new EncoderParameters(1);
			ImageCodecInfo[] info = ImageCodecInfo.GetImageEncoders();

			switch (FileType)
			{
				case "gif": //       info[2]
					if (GifDepth!=0)
					{
						/* VERSIONE PER ASP */
						Quantizer quantizer = new OctreeQuantizer(GifPalette, GifDepth);
						using (Bitmap quantized = quantizer.Quantize(thumbnail))
						{ quantized.Save(memorystream, ImageFormat.Gif); }
						/* VERSIONE GENERALE 
						Quantizer quantizer;
						if (GifDepth == 255) quantizer = new GrayscaleQuantizer();
						else quantizer = new OctreeQuantizer(GifPalette, GifDepth);
						using (Bitmap quantized = quantizer.Quantize(thumbnail))
							{ quantized.Save(memorystream, ImageFormat.Gif); }*/
					}
					else thumbnail.Save(memorystream, System.Drawing.Imaging.ImageFormat.Gif);
					break;
				case "png": //       info[4]
					thumbnail.Save(memorystream, System.Drawing.Imaging.ImageFormat.Png);
					break;
				case "bmp": //       info[0]
					thumbnail.Save(memorystream, System.Drawing.Imaging.ImageFormat.Bmp);
					break;
				case "tiff": //      info[3]
					encoderParameters.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Compression, TiffCompress ? (long)EncoderValue.CompressionLZW : (long)EncoderValue.CompressionNone);
					thumbnail.Save(memorystream, info[3], encoderParameters);
					break;
				default: //jpeg      info[1]
					encoderParameters.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, JpegQuality);          
					thumbnail.Save(memorystream, info[1], encoderParameters);
					break;
			}
			ByteSize = memorystream.Length;
			graphic.Dispose();
			graphic = null;
			thumbnail.Dispose();
			thumbnail = null;
		}
		catch
		{
			throw new System.ApplicationException("Unable to resize the image");
		}
		return memorystream;
	}
}

/*
**********************************************************************************
     >>> QUANTIZER.cs <<< (versione semplificata)
**********************************************************************************
*/
/* 
  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A 
  PARTICULAR PURPOSE. 
  
    This is sample code and is freely distributable. 
*/

    public abstract class Quantizer
    {
        public Quantizer(bool singlePass)
        {
            _singlePass = singlePass;
            _pixelSize = Marshal.SizeOf(typeof(Color32));
        }
        public Bitmap Quantize(System.Drawing.Image source)
        {
            int height = source.Height;
            int width = source.Width;
            Rectangle bounds = new Rectangle(0, 0, width, height);
            Bitmap copy = new Bitmap(width, height, PixelFormat.Format32bppArgb);
            Bitmap output = new Bitmap(width, height, PixelFormat.Format8bppIndexed);
            using (Graphics g = Graphics.FromImage(copy))
            {
                g.PageUnit = GraphicsUnit.Pixel;
                g.DrawImage(source, bounds);

            }
            BitmapData sourceData = null;
            try
            {
                sourceData = copy.LockBits(bounds, ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
                if (!_singlePass)
                    FirstPass(sourceData, width, height);
                output.Palette = GetPalette(output.Palette);
                SecondPass(sourceData, output, width, height, bounds);
            }
            finally
            {
                copy.UnlockBits(sourceData);
            }
            return output;
        }
        protected virtual void FirstPass(BitmapData sourceData, int width, int height)
        {          
            IntPtr pSourceRow = sourceData.Scan0;
            for (int row = 0; row < height; row++)
            {
                IntPtr pSourcePixel = pSourceRow;
                for (int col = 0; col < width; col++)
                {
                    InitialQuantizePixel(new Color32(pSourcePixel));
                    pSourcePixel = (IntPtr)((Int32)pSourcePixel + _pixelSize);
                }
                pSourceRow = (IntPtr)((long)pSourceRow + sourceData.Stride);
            }
        }
        protected virtual void SecondPass(BitmapData sourceData, Bitmap output, int width, int height, Rectangle bounds)
        {
            BitmapData outputData = null;
            try
            {
                outputData = output.LockBits(bounds, ImageLockMode.WriteOnly, PixelFormat.Format8bppIndexed);
                IntPtr pSourceRow = sourceData.Scan0;
                IntPtr pSourcePixel = pSourceRow;
                IntPtr pPreviousPixel = pSourcePixel;
                IntPtr pDestinationRow = outputData.Scan0;
                IntPtr pDestinationPixel = pDestinationRow;
                byte pixelValue = QuantizePixel(new Color32(pSourcePixel));
                Marshal.WriteByte(pDestinationPixel, pixelValue);
                for (int row = 0; row < height; row++)
                {
                    pSourcePixel = pSourceRow;
                    pDestinationPixel = pDestinationRow;
                    for (int col = 0; col < width; col++)
                    {
                        if (Marshal.ReadInt32(pPreviousPixel) != Marshal.ReadInt32(pSourcePixel))
                        {
                            pixelValue = QuantizePixel(new Color32(pSourcePixel));
                            pPreviousPixel = pSourcePixel;
                        }
                        Marshal.WriteByte(pDestinationPixel, pixelValue);
                        pSourcePixel = (IntPtr)((long)pSourcePixel + _pixelSize);
                        pDestinationPixel = (IntPtr)((long)pDestinationPixel + 1);

                    }
                    pSourceRow = (IntPtr)((long)pSourceRow + sourceData.Stride);
                    pDestinationRow = (IntPtr)((long)pDestinationRow + outputData.Stride);
                }
            }
            finally
            {
                output.UnlockBits(outputData);
            }
        }
        protected virtual void InitialQuantizePixel(Color32 pixel){}
        protected abstract byte QuantizePixel(Color32 pixel);
        protected abstract ColorPalette GetPalette(ColorPalette original);
        private bool _singlePass;
        private int _pixelSize;
        [StructLayout(LayoutKind.Explicit)]
        public struct Color32
        {
            public Color32(IntPtr pSourcePixel)
            {
                this = (Color32)Marshal.PtrToStructure(pSourcePixel, typeof(Color32));
            }
            [FieldOffset(0)]
            public byte Blue;
            [FieldOffset(1)]
            public byte Green;
            [FieldOffset(2)]
            public byte Red;
            [FieldOffset(3)]
            public byte Alpha;
            [FieldOffset(0)]
            public int ARGB;
            public Color Color
            {
                get { return Color.FromArgb(Alpha, Red, Green, Blue); }
            }
        }
    }
	
    public class OctreeQuantizer : Quantizer
    {
        public OctreeQuantizer(int maxColors, int maxColorBits)
            : base(false)
        {
            if (maxColors > 255)
                throw new ArgumentOutOfRangeException("maxColors", maxColors, "The number of colors should be less than 256");
            if ((maxColorBits < 1) | (maxColorBits > 8))
                throw new ArgumentOutOfRangeException("maxColorBits", maxColorBits, "This should be between 1 and 8");
            _octree = new Octree(maxColorBits);
            _maxColors = maxColors;
        }
        protected override void InitialQuantizePixel(Color32 pixel)
        {
            _octree.AddColor(pixel);
        }
        protected override byte QuantizePixel(Color32 pixel)
        {
            byte paletteIndex = (byte)_maxColors;
            if (pixel.Alpha > 0)
                paletteIndex = (byte)_octree.GetPaletteIndex(pixel);

            return paletteIndex;
        }
        protected override ColorPalette GetPalette(ColorPalette original)
        {
            ArrayList palette = _octree.Palletize(_maxColors - 1);
            for (int index = 0; index < palette.Count; index++)
                original.Entries[index] = (Color)palette[index];
            original.Entries[_maxColors] = Color.FromArgb(0, 0, 0, 0);
            return original;
        }
        private Octree _octree;
        private int _maxColors;
        private class Octree
        {
            public Octree(int maxColorBits)
            {
                _maxColorBits = maxColorBits;
                _leafCount = 0;
                _reducibleNodes = new OctreeNode[9];
                _root = new OctreeNode(0, _maxColorBits, this);
                _previousColor = 0;
                _previousNode = null;
            }
            public void AddColor(Color32 pixel)
            {
                if (_previousColor == pixel.ARGB)
                {
                    if (null == _previousNode)
                    {
                        _previousColor = pixel.ARGB;
                        _root.AddColor(pixel, _maxColorBits, 0, this);
                    }
                    else
                        _previousNode.Increment(pixel);
                }
                else
                {
                    _previousColor = pixel.ARGB;
                    _root.AddColor(pixel, _maxColorBits, 0, this);
                }
            }
            public void Reduce()
            {
                int index;
                for (index = _maxColorBits - 1; (index > 0) && (null == _reducibleNodes[index]); index--) ;
                OctreeNode node = _reducibleNodes[index];
                _reducibleNodes[index] = node.NextReducible;
                _leafCount -= node.Reduce();
                _previousNode = null;
            }
            public int Leaves
            {
                get { return _leafCount; }
                set { _leafCount = value; }
            }
            protected OctreeNode[] ReducibleNodes
            {
                get { return _reducibleNodes; }
            }
            protected void TrackPrevious(OctreeNode node)
            {
                _previousNode = node;
            }
            public ArrayList Palletize(int colorCount)
            {
                while (Leaves > colorCount)
                    Reduce();
                ArrayList palette = new ArrayList(Leaves);
                int paletteIndex = 0;
                _root.ConstructPalette(palette, ref paletteIndex);
                return palette;
            }
            public int GetPaletteIndex(Color32 pixel)
            {
                return _root.GetPaletteIndex(pixel, 0);
            }
            private static int[] mask = new int[8] { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
            private OctreeNode _root;
            private int _leafCount;
            private OctreeNode[] _reducibleNodes;
            private int _maxColorBits;
            private OctreeNode _previousNode;
            private int _previousColor;
            protected class OctreeNode
            {
                public OctreeNode(int level, int colorBits, Octree octree)
                {
                    _leaf = (level == colorBits);
                    _red = _green = _blue = 0;
                    _pixelCount = 0;
                    if (_leaf)
                    {
                        octree.Leaves++;
                        _nextReducible = null;
                        _children = null;
                    }
                    else
                    {
                        _nextReducible = octree.ReducibleNodes[level];
                        octree.ReducibleNodes[level] = this;
                        _children = new OctreeNode[8];
                    }
                }
                public void AddColor(Color32 pixel, int colorBits, int level, Octree octree)
                {
                    if (_leaf)
                    {
                        Increment(pixel);
                        octree.TrackPrevious(this);
                    }
                    else
                    {
                        int shift = 7 - level;
                        int index = ((pixel.Red & mask[level]) >> (shift - 2)) |
                            ((pixel.Green & mask[level]) >> (shift - 1)) |
                            ((pixel.Blue & mask[level]) >> (shift));

                        OctreeNode child = _children[index];

                        if (null == child)
                        {
                            child = new OctreeNode(level + 1, colorBits, octree);
                            _children[index] = child;
                        }
                        child.AddColor(pixel, colorBits, level + 1, octree);
                    }

                }
                public OctreeNode NextReducible
                {
                    get { return _nextReducible; }
                    set { _nextReducible = value; }
                }
                public OctreeNode[] Children
                {
                    get { return _children; }
                }
                public int Reduce()
                {
                    _red = _green = _blue = 0;
                    int children = 0;
                    for (int index = 0; index < 8; index++)
                    {
                        if (null != _children[index])
                        {
                            _red += _children[index]._red;
                            _green += _children[index]._green;
                            _blue += _children[index]._blue;
                            _pixelCount += _children[index]._pixelCount;
                            ++children;
                            _children[index] = null;
                        }
                    }
                    _leaf = true;
                    return (children - 1);
                }
                public void ConstructPalette(ArrayList palette, ref int paletteIndex)
                {
                    if (_leaf)
                    {
                        _paletteIndex = paletteIndex++;
                        palette.Add(Color.FromArgb(_red / _pixelCount, _green / _pixelCount, _blue / _pixelCount));
                    }
                    else
                    {
                        for (int index = 0; index < 8; index++)
                        {
                            if (null != _children[index])
                                _children[index].ConstructPalette(palette, ref paletteIndex);
                        }
                    }
                }
                public int GetPaletteIndex(Color32 pixel, int level)
                {
                    int paletteIndex = _paletteIndex;
                    if (!_leaf)
                    {
                        int shift = 7 - level;
                        int index = ((pixel.Red & mask[level]) >> (shift - 2)) |
                            ((pixel.Green & mask[level]) >> (shift - 1)) |
                            ((pixel.Blue & mask[level]) >> (shift));
                        if (null != _children[index])
                            paletteIndex = _children[index].GetPaletteIndex(pixel, level + 1);
                        else
                            throw new Exception("Didn't expect this!");
                    }
                    return paletteIndex;
                }
                public void Increment(Color32 pixel)
                {
                    _pixelCount++;
                    _red += pixel.Red;
                    _green += pixel.Green;
                    _blue += pixel.Blue;
                }
                private bool _leaf;
                private int _pixelCount;
                private int _red;
                private int _green;
                private int _blue;
                private OctreeNode[] _children;
                private OctreeNode _nextReducible;
                private int _paletteIndex;
            }
        }
    }
</script>
