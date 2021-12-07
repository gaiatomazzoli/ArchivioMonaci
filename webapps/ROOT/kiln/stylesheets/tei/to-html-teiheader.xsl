<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:t="http://www.tei-c.org/ns/1.0">

  <!-- Transform a TEI document's teiHeader into HTML. -->

  <xsl:template match="tei:teiHeader">
    <!-- Display metadata about this document, drawn from the TEI
         header. -->
    <div class="section-container accordion" data-section="accordion">
      <section>
        <h2 class="title" data-section-title=""><small><a href="#">Informazioni sul documento</a></small></h2>
        <div class="content" data-section-content="">
          <xsl:apply-templates select="tei:fileDesc" />
          <xsl:apply-templates select="tei:profileDesc" />
        </div>
      </section>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:correspDesc">
      <p><strong>Mittente:</strong><xsl:text> </xsl:text><xsl:apply-templates select="tei:correspAction[@type='sent']/tei:persName" />
        <br/><strong>Luogo di invio:</strong><xsl:text> </xsl:text><xsl:apply-templates select="tei:correspAction[@type='sent']/tei:placeName" />
        <br/><strong>Data di invio:</strong><xsl:text> </xsl:text><xsl:apply-templates select="tei:correspAction[@type='sent']/tei:date" /></p>
      <p><strong>Destinatario:</strong><xsl:text> </xsl:text><xsl:apply-templates select="tei:correspAction[@type='received']/tei:persName" />
        <br/><strong>Luogo di ricezione:</strong><xsl:text> </xsl:text><xsl:apply-templates select="tei:correspAction[@type='received']/tei:placeName" />
        <br/><strong>Data di ricezione:</strong><xsl:text> </xsl:text><xsl:apply-templates select="tei:correspAction[@type='received']/tei:date"/></p>
  </xsl:template>
  
  <xsl:template match="tei:correspAction//tei:date">
    <xsl:variable name="date-parts" select="tokenize(@when, '-')"/>
    <xsl:choose>
      <xsl:when test="count($date-parts)=3"><xsl:value-of select="format-date(@when,'[D1].[M1].[Y0001]')" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
      <xsl:when test="count($date-parts)=2"><xsl:value-of select="format-date(xs:date(concat(@when,'-01')),'[M1].[Y0001]')" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
      <xsl:when test="count($date-parts)=1"><xsl:value-of select="number(@when)" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
      
      <xsl:otherwise><xsl:text>?</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:bibl">
    <xsl:apply-templates /><xsl:text>. </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:bibl//tei:title">
    <i><xsl:value-of select="."/></i>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title">
    <!--<p><strong>Titolo:</strong><xsl:text> </xsl:text><xsl:apply-templates /></p>-->
  </xsl:template>
  
  <xsl:template match="tei:editor">
    <p>
      <strong><xsl:choose>
        <xsl:when test="@role='transcription'">Trascrizione</xsl:when>
        <xsl:when test="@role='encoding'">Codifica</xsl:when>
        <xsl:otherwise><xsl:value-of select="@role" /></xsl:otherwise>
      </xsl:choose>
        <xsl:text>: </xsl:text></strong>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="tei:respStmt">
    <p>
      <strong>
        <xsl:apply-templates select="tei:resp" />
        <xsl:text>: </xsl:text>
      </strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="tei:*[not(local-name()='resp')]" />
    </p>
  </xsl:template>
  
  <xsl:template match="tei:publisher">
    <!--<p>
      <strong>Pubblicazione: </strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </p>-->
  </xsl:template>
  
  <xsl:template match="tei:pubPlace"/>
  
  <xsl:template match="tei:publicationStmt/tei:date">
    <p>
      <strong>Data pubblicazione online: </strong>
      <xsl:text> </xsl:text>
      <xsl:value-of select="format-date(@when,'[D1].[M1].[Y0001]')" />
    </p>
  </xsl:template>
  
   <xsl:template match="tei:listBibl">
    <p><strong>Riferimenti bibliografici: </strong> <xsl:text> </xsl:text> <xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="tei:msDesc">
    <p><strong>Collocazione: </strong> <xsl:text> </xsl:text> <xsl:apply-templates select="tei:msIdentifier" /></p>
    <p><strong>Contenuto: </strong> <xsl:text> </xsl:text> <xsl:apply-templates select="tei:msContents" /></p>
  </xsl:template>
  
  <xsl:template match="tei:summary//tei:title[@type='letter'][@ref]">
          <a><xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
  </xsl:template>
</xsl:stylesheet>
