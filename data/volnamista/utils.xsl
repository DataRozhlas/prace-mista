<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Komentář -->
  <xsl:template name="tmplComment">
    <xsl:comment> Integrovaný portál MPSV, http://portal.mpsv.cz                        </xsl:comment>
    <xsl:comment> OKsystem s.r.o., Na Pankráci 125, 140 21 Praha 4                      </xsl:comment>
    <xsl:comment> +420 244 021 111, webadmin.portal@oksystem.cz, http://www.oksystem.cz </xsl:comment>
    <!-- Odřádkování -->
    <xsl:text>
    </xsl:text>
  </xsl:template>

  <!-- Kaskádové styly -->
  <xsl:template name="tmplCSS">
    <xsl:text>
          .OKbackground {background-color: #E1EBFF;}
          .OKcaptionDistinct caption, .OKtheadDistinct thead, .OKtfootDistinct tfoot, .OKtbodyDistinct tbody, .OKthDistinct th, .OKtdDistinct td, .OKtheadThDistinct thead th, .OKtheadTdDistinct thead td, .OKtfootThDistinct tfoot th, .OKtfootTdDistinct tfoot td, .OKtbodyThDistinct tbody th, .OKtbodyTdDistinct tbody td {color: #3478FF;}
          .OKcaptionTop caption, .OKtheadTop thead, .OKtfootTop tfoot, .OKtbodyTop tbody, .OKthTop th, .OKtdTop td, .OKtheadThTop thead th, .OKtheadTdTop thead td, .OKtfootThTop tfoot th, .OKtfootTdTop tfoot td, .OKtbodyThTop tbody th, .OKtbodyTdTop tbody td {vertical-align: top;}
          .OKtable {border-collapse: collapse; font-size: 100%; font-family: "Arial CE", Arial, Helvetica, sans-serif;}
          .OKtable caption {font-weight: bold; text-align: center; padding: 1em 0em 0.5em 0em;}
          .OKtable tbody {text-align: left;}
          .OKtable tbody th {font-weight: bold;}
          .OKtable th, .OKtable td {padding: 0.2em;}
          .OKtable thead, .OKtable tfoot {font-weight: bold; text-align: center;}
          .OKtableBorder, .OKtableBorderAll, .OKtableBorderAll th, .OKtableBorderAll td {border: 1px solid #3478FF;}
          .OKtableBorder, .OKtableBorderAll {border-width: 2px;}
          .OKdistinct1 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 115%;}
          .OKdistinct2 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 100%;}
          .OKdistinct3 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 85%;}
          .OKbasic2 {color: #000000; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 100%;}
          .OKcaptionNoWrap caption, .OKtheadNoWrap thead th, /* jinak nejde v IE */ .OKtheadNoWrap thead td, .OKtfootNoWrap tfoot th, .OKtfootNoWrap tfoot td, .OKtbodyNoWrap tbody th, .OKtbodyNoWrap tbody td, .OKthNoWrap th, .OKtdNoWrap td, .OKtheadThNoWrap thead th, .OKtheadTdNoWrap thead td, .OKtfootThNoWrap tfoot th, .OKtfootTdNoWrap tfoot td, .OKtbodyThNoWrap tbody th, .OKtbodyTdNoWrap tbody td {white-space:nowrap;}
          .OKbold {font-weight: bold;}
          .firstLetterUpper:first-letter { text-transform: uppercase;}
          .noWrap {white-space: nowrap;}
          body {font-size: 80%; font-family: "Arial CE", Arial, Helvetica, sans-serif;}
          h1 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 170%; Font-Weight: Bold; padding: 0px; margin: 0px; text-align: center;}
          h2 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 140%; Font-Weight: Bold; padding: 0.5em 0em 0em 0em; margin: 0px;}
          h3 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 130%; Font-Weight: Bold; padding: 0.5em 0em 0em 0em; margin: 0px;}
          h4 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 120%; Font-Weight: Bold; padding: 0.5em 0em 0em 0em; margin: 0px;}
          h5 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 110%; Font-Weight: Bold; padding: 0.5em 0em 0em 0em; margin: 0px;}
          h6 {color: #3478FF; font-family: "Arial CE", Arial, Helvetica, sans-serif; Font-Size: 100%; Font-Weight: Bold; padding: 0.5em 0em 0em 0em; margin: 0px;}
          hr {border: #3478FF 1px solid; height: 2px; border-width: 1px 0px 1px 0px;}
          th.dopSpojTh1, th.dopSpojThN {color: black; font-weight: normal; text-align: center;}
          th.dopSpojThN {padding-left: 1em;}
    </xsl:text>
  </xsl:template>

  <xsl:template name="tmplCSSOutlook2007">
    <xsl:text>
          /* Outlook 2007 :-( */
          th {white-space: nowrap; text-align: left; font-weight: bold; color: #3478FF; vertical-align: top; padding: 0.2em; margin: 0px;}
          td {text-align: left; vertical-align: top; padding: 0.2em; margin: 0px;}
          table {border-collapse: collapse; font-size: 100%; font-family: "Arial CE", Arial, Helvetica, sans-serif;}
    </xsl:text>
  </xsl:template>

  <!-- XML date time format 2006-01-14T08:55:22 -->
  <xsl:template name="FormatDate">
    <xsl:param name="dateTime" />
    <xsl:param name="clearLeadingZero" select="'true'" />

    <xsl:variable name="year">
      <xsl:value-of select="substring-before($dateTime,'-')" />
    </xsl:variable>
    <xsl:variable name="mon-temp">
      <xsl:value-of select="substring-after($dateTime,'-')" />
    </xsl:variable>
    <xsl:variable name="mon">
      <xsl:value-of select="substring-before($mon-temp,'-')" />
    </xsl:variable>
    <xsl:variable name="day-temp">
      <xsl:value-of select="substring-after($mon-temp,'-')" />
    </xsl:variable>
    <xsl:variable name="time">
      <xsl:value-of select="substring-after($dateTime,'T')" />
    </xsl:variable>
    <xsl:variable name="day">
  		<xsl:choose>
    		<xsl:when test="string-length($time) = 0">
          <xsl:value-of select="substring-after($mon-temp,'-')" />
    		</xsl:when>
    		<xsl:otherwise>
          <xsl:value-of select="substring-before($day-temp,'T')" />
    		</xsl:otherwise>
  		</xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$clearLeadingZero = 'true' and substring($day, 1, 1) = '0'">
        <xsl:value-of select="substring-after($day,'0')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$day"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.</xsl:text>
    <xsl:choose>
      <xsl:when test="$clearLeadingZero = 'true' and substring($mon, 1, 1) = '0'">
        <xsl:value-of select="substring-after($mon,'0')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$mon"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$year"/>
    
    <xsl:if test="string-length($time) &gt; 0">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$time"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="htmlBreak">                        
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '&#xa;')">
        <xsl:value-of select="substring-before($text, '&#xa;')"/>
        <br/>
        <xsl:call-template name="htmlBreak">
          <xsl:with-param name="text" select="substring-after($text, '&#xa;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
