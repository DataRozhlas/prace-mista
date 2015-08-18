<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vm="http://portal.mpsv.cz/xml/exportvm">

  <xsl:import href="utils.xsl" />

	<xsl:decimal-format name="CZNUM" decimal-separator=',' grouping-separator=' ' />
	<xsl:output method="html" encoding="UTF-8" indent="yes" media-type="text/html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

  <xsl:param name="lang" select="'cs'"/>

  <xsl:variable name="msg" select="document(concat('resource_', $lang, '.xml'))/resource"/>

	<xsl:template match="/">
    <xsl:call-template name="tmplComment" />
    <html>
			<head>
        <meta http-equiv="Content-Language" content="cs" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title><xsl:value-of select="$msg/text[@id='xml.vm.title']"/></title>
				<style type="text/css">
          <xsl:call-template name="tmplCSS" />
				</style>
			</head>
			<body>
			  <center>
        <h1>
        	<xsl:choose>
            <xsl:when test="string-length(vm:VOLNAMISTA/@okres) > 0">
              <xsl:value-of select="vm:VOLNAMISTA/@okres" /> - <xsl:value-of select="$msg/text[@id='xml.vm.text']"/>.
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$msg/text[@id='xml.vm.body.title']"/>
            </xsl:otherwise>
          </xsl:choose>
        </h1>
        <br/>
        <h4>
          <xsl:value-of select="$msg/text[@id='xml.vm.cas.vytvoreni']"/>:<xsl:text> </xsl:text>
            <xsl:call-template name="FormatDate">
              <xsl:with-param name="dateTime">
                <xsl:value-of select="vm:VOLNAMISTA/@aktualizace" /> 
              </xsl:with-param>
            </xsl:call-template>
          <br/>
          <xsl:value-of select="$msg/text[@id='xml.vm.celkem.pozadavku']"/>:<xsl:text> </xsl:text><xsl:value-of select="count(vm:VOLNAMISTA/vm:VOLNEMISTO)" /><br/>
          <xsl:value-of select="$msg/text[@id='xml.vm.celkem']"/>:<xsl:text> </xsl:text><xsl:value-of select="sum(vm:VOLNAMISTA/vm:VOLNEMISTO/@celkemVm)" /><br/>
        </h4>
        <br/>
			  </center>
					<xsl:apply-templates select="vm:VOLNAMISTA">
						<xsl:sort select="vm:PROFESE/@nazev" />
						<xsl:sort select="vm:PROFESE/@kod" />
						<xsl:sort select="vm:PROFESE/@doplnek" />
					</xsl:apply-templates>
					<xsl:apply-templates select="vm:VOLNEMISTO_NENABIZET">
						<xsl:sort select="./@datumVyrazeni" />
					</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>

  <!-- ŠABLONA VOLNÉHO MÍSTA - nabízené -->
	<xsl:template match="vm:VOLNEMISTO">
    <table border="0" width="100%" class="OKtable OKtbodyTop OKtbodyThDistinct OKbasic2" summary="{ $msg/text[@id='xml.vm.detail'] }">
    <!-- Aktuální VM -->
    <xsl:variable name="czIscoTextKod"><xsl:value-of select="vm:PROFESE/@nazev" /> (<xsl:value-of select="vm:PROFESE/@kod" />)</xsl:variable>
    <xsl:variable name="profeseText">
      <xsl:if test="string-length(vm:PROFESE/@doplnek) = 0"><xsl:value-of select="$czIscoTextKod" /></xsl:if>
      <xsl:if test="string-length(vm:PROFESE/@doplnek) > 0"><xsl:value-of select="vm:PROFESE/@doplnek" /></xsl:if>
    </xsl:variable>
    <xsl:variable name="czIscoText">
      <xsl:if test="string-length(vm:PROFESE/@doplnek) = 0"><xsl:value-of select="''" /></xsl:if>
      <xsl:if test="string-length(vm:PROFESE/@doplnek) > 0"><xsl:value-of select="$czIscoTextKod" /></xsl:if>
    </xsl:variable>

    <tr>
      <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.pozad.profese']"/>:</th>
      <td width="100%" class="OKbackground">
        <b><xsl:value-of select="$profeseText" /></b>
      </td>
    </tr>
    <xsl:if test="string-length($czIscoText) > 0">
      <tr>
        <td colspan="2">&#xA0;</td>
        <td width="100%">
          <xsl:value-of select="$czIscoText" />
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="./@celkemVm > 1">
        <tr>
          <td>&#xA0;</td>
          <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.pocet']"/>:</td>
          <td><b><xsl:value-of select="./@celkemVm" /></b></td>
        </tr>
    </xsl:if>

    <tr>
      <th colspan="3" class="vmDetail"><xsl:value-of select="$msg/text[@id='text.vm.pracoviste.a.kontakty']"/></th>
    </tr>
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.firma']"/>:</td>
      <td>
        <xsl:choose>
          <xsl:when test="./@jakKontaktovat = '1'">
            <b><xsl:value-of select="vm:FIRMA/@nazev" /></b>, <xsl:value-of select="$msg/text[@id='text.vm.firma.ic']"/><xsl:text> </xsl:text><xsl:value-of select="vm:FIRMA/@ic" /><xsl:if test="vm:FIRMA/@www != ''">, <a href="{vm:FIRMA/@www}" class="OKdistinct2 OKbold" onclick="return openNewWindow(this.href);"><xsl:value-of select="vm:FIRMA/@www" /></a></xsl:if>
          </xsl:when>
          <xsl:when test="./@jakKontaktovat = '2'">
            <xsl:value-of select="$msg/text[@id='text.vm.informace.poda']"/><xsl:text> </xsl:text><b><xsl:value-of select="vm:FIRMA/@nazev" /></b>
          </xsl:when>
          <xsl:when test="./@jakKontaktovat = '3'">
            <b><xsl:value-of select="$msg/text[@id='text.kontakt.v.poznamce']"/></b>
          </xsl:when>
        </xsl:choose>
      </td>
    </tr>
    
    <xsl:if test="string-length(vm:PRACOVISTE) > 0">
      <tr>
        <td>&#xA0;</td>
        <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.pracoviste']"/>:</td>
        <td>
          <b><xsl:value-of select="vm:PRACOVISTE" /></b>
        </td>
      </tr>
    </xsl:if>

    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.komu.se.hlasit']"/>:</td>
      <td>
        <xsl:if test="string-length(vm:KONOS) > 0">
          <b><xsl:value-of select="vm:KONOS" /></b>
        </xsl:if>
        <xsl:if test="string-length(vm:KONOS/@telefon) > 0">
          <xsl:if test="string-length(vm:KONOS) = 0">
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:if test="string-length(vm:KONOS) > 0">
            <xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.tel']"/><xsl:text>: </xsl:text>
          </xsl:if>
          <b><xsl:value-of select="vm:KONOS/@telefon" /></b>
        </xsl:if>
        <xsl:if test="string-length(vm:KONOS/@email) > 0">
          <xsl:if test="string-length(vm:KONOS) = 0 and string-length(vm:KONOS/@telefon) = 0">
            <xsl:value-of select="$msg/text[@id='text.vm.Email']"/><xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:if test="string-length(vm:KONOS) > 0 or string-length(vm:KONOS/@telefon) > 0">
            <xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.email']"/><xsl:text>: </xsl:text>
          </xsl:if>
          <a class="OKdistinct2 OKbold"><xsl:attribute name="href">mailto:<xsl:value-of select="vm:KONOS/@email"/></xsl:attribute><xsl:value-of select="vm:KONOS/@email" /></a>
        </xsl:if>
        <xsl:if test="string-length(vm:KONOS/@adresa) > 0">
          <xsl:if test="string-length(vm:KONOS) = 0 and string-length(vm:KONOS/@telefon) = 0 and string-length(vm:KONOS/@email) = 0">
            <xsl:value-of select="$msg/text[@id='text.vm.Adresa']"/><xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:if test="string-length(vm:KONOS) > 0 or string-length(vm:KONOS/@telefon) > 0 or string-length(vm:KONOS/@email) > 0">
            <xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.adresa']"/><xsl:text>: </xsl:text>
          </xsl:if>
          <b><xsl:value-of select="vm:KONOS/@adresa" /></b>
        </xsl:if>
      </td>
    </tr>
    <tr>
      <th colspan="3" class="vmDetail"><xsl:value-of select="$msg/text[@id='text.vm.vlastnosti']"/></th>
    </tr>
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.uvazek']"/>:</td>
      <td><b><xsl:value-of select="vm:UVAZEK/@nazev" /></b></td>
    </tr>
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.pracprav.vztah']"/>:</td>
      <td><b><xsl:value-of select="vm:PRACPRAVNI_VZTAH/@nazev" /></b></td>
    </tr>
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.smennost']"/>:</td>
      <td><b><xsl:value-of select="vm:SMENNOST/@nazev" /></b></td>
    </tr>
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.vzdelani']"/>:</td>
      <td><b><xsl:value-of select="vm:MIN_VZDELANI/@nazev" /></b></td>
    </tr>
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.pracovni.pomer']"/>:</td>
      <td>
        <xsl:if test="string-length(vm:PRAC_POMER/@od) > 0">
          <xsl:value-of select="$msg/text[@id='text.vm.od']"/><xsl:text> </xsl:text><b>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="dateTime">
              <xsl:value-of select="vm:PRAC_POMER/@od" /> 
            </xsl:with-param>
          </xsl:call-template>
          </b>
        </xsl:if>
        <xsl:if test="string-length(vm:PRAC_POMER/@do) > 0">
          <xsl:text> </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.do']"/><xsl:text> </xsl:text><b>
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="dateTime">
              <xsl:value-of select="vm:PRAC_POMER/@do" /> 
            </xsl:with-param>
          </xsl:call-template>
          </b>
        </xsl:if>
      </td>
    </tr>
    <xsl:if test="(string-length(vm:MZDA/@min) > 0) or (string-length(vm:MZDA/@max) > 0)">
    <tr>
      <td>&#xA0;</td>
      <td class="noWrap"><xsl:value-of select="$msg/text[@id='text.vm.mzda']"/>:</td>
      <td>
        <xsl:if test="string-length(vm:MZDA/@min) > 0">
            <xsl:value-of select="$msg/text[@id='text.vm.od']"/><xsl:text> </xsl:text><b><xsl:value-of select="format-number(vm:MZDA/@min,'### ### ###', 'CZNUM')" /><xsl:text> </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.kc']"/></b>
        </xsl:if>
        <xsl:if test="string-length(vm:MZDA/@max) > 0">
            <xsl:text> </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.do']"/><xsl:text> </xsl:text><b><xsl:value-of select="format-number(vm:MZDA/@max,'### ### ###', 'CZNUM')" /><xsl:text> </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.kc']"/></b>
        </xsl:if>
      </td>
    </tr>
    </xsl:if>
    <xsl:if test="(vm:VHODNE_PRO/@absolventySs = 'A') or (vm:VHODNE_PRO/@absolventyVs = 'A') or (vm:VHODNE_PRO/@mladistve = 'A') or (vm:VHODNE_PRO/@ozp = 'A') or (vm:VHODNE_PRO/@ozpTzp = 'A')">
      <tr>
        <td width="15">&#xA0;</td>
        <td><xsl:value-of select="$msg/text[@id='text.vm.vhodne.pro']"/>:</td>
        <td width="100%">
            <xsl:if test="vm:VHODNE_PRO/@absolventySs = 'A'">
              <div class="firstLetterUpper OKbold"><xsl:value-of select="$msg/text[@id='text.vm.vhod.absol.ss']"/>.</div>
            </xsl:if>
            <xsl:if test="vm:VHODNE_PRO/@absolventyVs = 'A'">
              <div class="firstLetterUpper OKbold"><xsl:value-of select="$msg/text[@id='text.vm.vhod.absol.vs']"/>.</div><br/>
            </xsl:if>
            <xsl:if test="vm:VHODNE_PRO/@mladistve = 'A'">
              <div class="firstLetterUpper OKbold"><xsl:value-of select="$msg/text[@id='text.vm.vhod.mladistvi']"/>.</div><br/>
            </xsl:if>
            <xsl:if test="vm:VHODNE_PRO/@ozp = 'A' or vm:VHODNE_PRO/@ozpTzp = 'A'">
              <xsl:choose>
                <xsl:when test="vm:VHODNE_PRO/@zdrave = 'A'">
                  <div class="firstLetterUpper OKbold"><xsl:value-of select="$msg/text[@id='text.vm.vhod.zdrave.i.ozp']"/>.</div>
                </xsl:when>
                <xsl:otherwise>
                  <div class="firstLetterUpper OKbold"><xsl:value-of select="$msg/text[@id='text.vm.vhod.ozp']"/>.</div>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:if test="vm:VHODNE_PRO/@bezbar = 'A'">
                <div class="firstLetterUpper OKbold"><xsl:value-of select="$msg/text[@id='text.vm.vhod.bezbar']"/>.</div>
              </xsl:if>

            </xsl:if>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="(vm:VHODNE_PRO/@cizince = 'A') or (vm:VHODNE_PRO/@pzciz = 'A')">
      <tr>
        <td width="15">&#xA0;</td>
        <td><xsl:value-of select="$msg/text[@id='']"/>Další informace:</td>
        <td width="100%">
            <b>
            <xsl:if test="vm:VHODNE_PRO/@cizince = 'A'">
              <xsl:value-of select="$msg/text[@id='text.vm.vhodne.pro.cizince']"/><br/>
            </xsl:if>
            <xsl:if test="vm:VHODNE_PRO/@pzciz = 'A'">
              <xsl:value-of select="$msg/text[@id='text.vm.zamest.ma.povoleni.pro.cizince']"/><br/>
            </xsl:if>
            </b>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="count(vm:VYHODA) > 0">
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.vyhody']"/>:</th>
        <td width="100%">
          <xsl:for-each select="vm:VYHODA">
            <xsl:sort select="./@nazev" data-type="text" order="ascending" />
            <xsl:if test="position() > 1">
              <br/>
            </xsl:if>
            <b>
              <xsl:value-of select="./@nazev" />
              <xsl:if test="string-length(./@popis) > 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="./@popis" />
              </xsl:if>
            </b>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="count(vm:DOVEDNOST) > 0">
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.dovednosti']"/>:</th>
        <td width="100%">
          <xsl:for-each select="vm:DOVEDNOST">
            <xsl:sort select="./@nazev" data-type="text" order="ascending" />
            <xsl:if test="position() > 1">
              <br/>
            </xsl:if>
            <b>
              <xsl:value-of select="./@nazev" />
              <xsl:if test="string-length(./@popis) > 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="./@popis" />
              </xsl:if>
              <xsl:if test="number(./@praxe) &gt; 0">
                <xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.praxe.v.rocich']"/><xsl:text>: </xsl:text>
                <xsl:value-of select="format-number(./@praxe,'### ### ###,#', 'CZNUM')" />
              </xsl:if>
            </b>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="count(vm:JAZYK) > 0">
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.znalosti']"/>:</th>
        <td width="100%">
          <xsl:for-each select="vm:JAZYK">
            <xsl:sort select="./@nazev" data-type="text" order="ascending" />
            <xsl:if test="position() > 1">
              <br/>
            </xsl:if>
            <b>
              <xsl:value-of select="./@nazev" />
              <xsl:text> - </xsl:text>
              <xsl:value-of select="./@uroven" />
              <xsl:if test="string-length(./@popis) > 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="./@popis" />
              </xsl:if>
            </b>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="count(vm:POVOLANI) > 0">
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.povolani']"/>:</th>
        <td width="100%">
          <xsl:for-each select="vm:POVOLANI">
            <xsl:sort select="./@nazev" data-type="text" order="ascending" />
            <xsl:if test="position() > 1">
              <br/>
            </xsl:if>
            <b>
              <xsl:value-of select="./@nazev" />
              <xsl:if test="number(./@praxe) &gt; 0">
                <xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.praxe.v.rocich']"/><xsl:text>: </xsl:text>
                <xsl:value-of select="format-number(./@praxe,'### ### ###,#', 'CZNUM')" />
              </xsl:if>
            </b>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="count(vm:VZDELANI) > 0">
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.pozadovana.vzdelani']"/>:</th>
        <td width="100%">
          <xsl:for-each select="vm:VZDELANI">
            <xsl:sort select="./@nazev" data-type="text" order="ascending" />
            <xsl:if test="position() > 1">
              <br/>
            </xsl:if>
            <b>
              <xsl:value-of select="./@nazev" />
            </b>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test="string-length(vm:POZNAMKA) > 0 or string-length(vm:VM_WWW) > 0">
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.poznamka']"/>:</th>
        <td width="100%">
      		<xsl:if test="string-length(vm:POZNAMKA) > 0">
      			<b>
              <xsl:call-template name="htmlBreak">
                <xsl:with-param name="text">
                  <xsl:value-of select="vm:POZNAMKA" /> 
                </xsl:with-param>
              </xsl:call-template>
            </b>
      		</xsl:if>
          <xsl:if test="string-length(vm:VM_WWW) > 0">
    			<xsl:if test="string-length(vm:POZNAMKA) > 0"><br/></xsl:if>
            <a class="OKdistinct2 OKbold">
      				<xsl:attribute name="href"><xsl:value-of select="vm:VM_WWW" disable-output-escaping="yes" /></xsl:attribute>
      				<xsl:value-of select="vm:VM_WWW" disable-output-escaping="yes" />
            </a>
          </xsl:if>
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="count(vm:DOPRAVNI_SPOJENI/vm:SPOJENI) > 0">
			<tr>
				<th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.dopravni.spojeni']"/>:</th>
				<td width="100%">
				  <span class="OKbold"><xsl:value-of select="vm:DOPRAVNI_SPOJENI/@vzdalenostVerejnaKm" /><xsl:if test="vm:DOPRAVNI_SPOJENI/@vzdalenostVerejnaKm = ''"><xsl:value-of select="vm:DOPRAVNI_SPOJENI/@vzdalenostPrimaKm" /></xsl:if>&#xA0;<xsl:value-of select="$msg/text[@id='text.km']"/></span><xsl:text> </xsl:text><xsl:value-of select="$msg/text[@id='text.dojezd.vzdalenost.od.obce']"/><xsl:text> </xsl:text><span class="OKbold"><xsl:value-of select="vm:DOPRAVNI_SPOJENI/@obecOdNazev" /></span><xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.okres.zkratka']"/><xsl:text> </xsl:text><xsl:value-of select="vm:DOPRAVNI_SPOJENI/@okresOdNazev"/>,
				  <a class="OKdistinct2">
					 <xsl:attribute name="href"><xsl:value-of select="vm:DOPRAVNI_SPOJENI/@urlAdresaSpoje" disable-output-escaping="yes" /></xsl:attribute>
					 <xsl:value-of select="$msg/text[@id='text.jizdni.rady']"/>
				  </a>
				  <table class="OKtable OKbasic2" summary="{$msg/text[@id='text.vm.dopravni.spojeni']}/>" style="border-bottom: 1px solid silver; border-top: 1px solid silver; margin-top: 0.5em">
				  <tr>
					<th class="dopSpojTh1"><xsl:value-of select="$msg/text[@id='text.dojezd.na']"/></th>
					<th class="dopSpojThN"><xsl:value-of select="$msg/text[@id='text.dojezd.doba']"/></th>
					<th class="dopSpojThN"><xsl:value-of select="$msg/text[@id='text.dojezd.cena']"/></th>
					<th class="dopSpojThN"><xsl:value-of select="$msg/text[@id='text.dojezd.pocet.prestupu']"/></th>
					<th class="dopSpojThN"><xsl:value-of select="$msg/text[@id='text.dojezd.pocet.spojeni']"/></th>
				  </tr>
				  <xsl:apply-templates select="vm:DOPRAVNI_SPOJENI/vm:SPOJENI"/>
				  </table>
				</td>
			</tr>
    </xsl:if>

      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.datum.zmeny']"/>:</th>
        <td>
            <xsl:call-template name="FormatDate">
              <xsl:with-param name="dateTime">
                <xsl:value-of select="./@zmena" /> 
              </xsl:with-param>
            </xsl:call-template>
  
            <xsl:text>, </xsl:text><xsl:value-of select="vm:URAD_PRACE/@nazev" /><xsl:text>, </xsl:text><xsl:value-of select="$msg/text[@id='text.vm.id.centrum']"/><xsl:text>: </xsl:text>
  
            <xsl:if test="string-length(/vm:VOLNAMISTA/@detailvm) = 0">
              <xsl:value-of select="./@uid" />
            </xsl:if>
            <xsl:if test="string-length(/vm:VOLNAMISTA/@detailvm) > 0">
              <a href="{/vm:VOLNAMISTA/@detailvm}{./@uid}" title="{ $msg/text[@id='xml.vm.detail.tag.a.title'] }" class="OKdistinct2 OKbold"><xsl:value-of select="./@uid" /></a>
            </xsl:if>
  
            <xsl:if test="vm:AUTOR = '2'">
              <div class="OKdistinct2"><xsl:value-of select="$msg/text[@id='info.vm.autor.firma']"/></div>
            </xsl:if>
        </td>
      </tr>
      <tr>
        <td colspan="3" width="100%">
           <hr/>
        </td>
      </tr>
    </table>
	</xsl:template>

  <!-- ŠABLONA VOLNÉHO MÍSTA - vyřazené -->
	<xsl:template match="vm:VOLNEMISTO_NENABIZET">
    <table border="0" width="100%" class="OKtable OKtbodyTop OKtbodyThDistinct OKbasic2" summary="{ $msg/text[@id='xml.vm.detail'] }">
      <tr>
        <th colspan="2" nowrap="nowrap"><xsl:value-of select="$msg/text[@id='xml.vm.datum.vyrazeni']"/>:</th>
        <td width="100%">
          <xsl:call-template name="FormatDate">
            <xsl:with-param name="dateTime">
              <xsl:value-of select="./@datumVyrazeni" /> 
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <th colspan="2"><xsl:value-of select="$msg/text[@id='text.vm.id.ref']"/><xsl:text>: </xsl:text></th>
        <td><xsl:value-of select="./@uid" /></td>
      </tr>
      <tr>
        <td colspan="3" width="100%">
           <hr/>
        </td>
      </tr>
    </table>
	</xsl:template>

	<!-- ŠABLONA DOPRAVNÍ SPOJENÍ -->
	<xsl:template match="vm:DOPRAVNI_SPOJENI/vm:SPOJENI">
		<tr class="OKbold">
		  <td style="text-align: left;">
			<xsl:choose>
				<xsl:when test="./@dojezdNa = '06'"><xsl:text>6:00</xsl:text></xsl:when>
				<xsl:when test="./@dojezdNa = '07'"><xsl:text>7:00</xsl:text></xsl:when>
				<xsl:when test="./@dojezdNa = '08'"><xsl:text>8:00</xsl:text></xsl:when>
				<xsl:when test="./@dojezdNa = '14'"><xsl:text>14:00</xsl:text></xsl:when>
				<xsl:when test="./@dojezdNa = '22'"><xsl:text>22:00</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>N/A</xsl:text></xsl:otherwise>
			</xsl:choose>
		  </td>
		  <td style="text-align: right;"><xsl:value-of select="./@dojezdMin" />&#xA0;<xsl:value-of select="$msg/text[@id='text.minut.zkratka']"/></td>
		  <td style="text-align: right;">
			<xsl:if test="not(./@cenaPlna)">
				<xsl:value-of select="$msg/text[@id='text.dojezd.cena.neuvedena']"/>
			</xsl:if>
			<xsl:if test="./@cenaPlna">
			  <xsl:value-of select="./@cenaPlna" />&#xA0;<xsl:value-of select="$msg/text[@id='text.vm.kc']"/>
			</xsl:if>
		  </td>
		  <td style="text-align: right;"><xsl:value-of select="./@prestupuPocet" /></td>
		  <td style="text-align: right;"><xsl:value-of select="./@spojeniPocet" /></td>
		</tr>
	</xsl:template>
	
</xsl:stylesheet>
