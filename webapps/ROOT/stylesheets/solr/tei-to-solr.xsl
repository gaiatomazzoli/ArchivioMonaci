<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>

  <xsl:template match="tei:persName[not(@type)][@ref]" mode="facet_persone_menzionate">
    <field name="persone_menzionate">
      <xsl:variable name="pers-id" select="tokenize(replace(@ref,'#',''),' ')"/>
      <xsl:variable name="person-id" select="document('../../content/xml/authority/listPersons.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
      <xsl:choose>
        <xsl:when test="$person-id[descendant::tei:forename]"><xsl:value-of select="$person-id/tei:surname"/><xsl:text> </xsl:text><xsl:value-of select="$person-id/tei:forename"/></xsl:when>
        <xsl:when test="$person-id[not(descendant::tei:forename)]"><xsl:value-of select="$person-id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:placeName[@ref]" mode="facet_luoghi_menzionati">
    <field name="luoghi_menzionati">
      <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
      <xsl:variable name="place-id" select="document('../../content/xml/authority/listPlaces.xml')//tei:place[@xml:id=$pl-id]/tei:placeName"/>
      <xsl:choose>
        <xsl:when test="$place-id"><xsl:value-of select="$place-id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:orgName[@ref]" mode="facet_istituzioni_menzionate">
    <field name="istituzioni_menzionate">
      <xsl:variable name="org-id" select="substring-after(@ref,'#')"/>
      <xsl:variable name="organization-id" select="document('../../content/xml/authority/listOrg.xml')//tei:org[@xml:id=$org-id]/tei:orgName"/>
      <xsl:choose>
        <xsl:when test="$organization-id"><xsl:value-of select="$organization-id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName[@type='author'][@ref]" mode="facet_autori_menzionati">
    <field name="autori_menzionati">
      <xsl:variable name="pers-id" select="tokenize(replace(@ref,'#',''),' ')"/>
      <xsl:variable name="person-id" select="document('../../content/xml/authority/listPersons.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
      <xsl:choose>
        <xsl:when test="$person-id[descendant::tei:forename]"><xsl:value-of select="$person-id/tei:forename"/><xsl:text> </xsl:text><xsl:value-of select="$person-id/tei:surname"/></xsl:when>
        <xsl:when test="$person-id[not(descendant::tei:forename)]"><xsl:value-of select="$person-id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:title[not(@type)][@ref]" mode="facet_opere_menzionate">
    <field name="opere_menzionate">
      <xsl:variable name="ti-id" select="tokenize(replace(@ref,'#',''),' ')"/>
      <xsl:variable name="title-id" select="document('../../content/xml/authority/listBibl.xml')//tei:bibl[@xml:id=$ti-id]/tei:title[1]"/>
      <xsl:choose>
        <xsl:when test="$title-id"><xsl:value-of select="$title-id"/></xsl:when>
        <xsl:when test="@key"><xsl:value-of select="@key"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:title[@type!='letter']" mode="facet_fonti_menzionate">
    <field name="fonti_menzionate">
      <xsl:choose>
        <xsl:when test="@type='manuscript'">Manoscritto</xsl:when>
        <xsl:when test="@type='inscription'">Iscrizione</xsl:when>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs[@type='topic']" mode="facet_tematiche">
    <field name="tematiche">
      <xsl:choose>
        <xsl:when test="@key"><xsl:value-of select="@key"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName" mode="facet_mittente">
    <field name="mittente">
      <xsl:variable name="pers-id" select="substring-after(@ref,'#')"/>
      <xsl:variable name="person-id" select="document('../../content/xml/authority/listPersons.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
      <xsl:choose>
        <xsl:when test="$person-id/tei:surname"><xsl:value-of select="$person-id/tei:surname"/><xsl:text> </xsl:text><xsl:value-of select="$person-id/tei:forename"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$person-id"/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:persName" mode="facet_destinatario">
    <field name="destinatario">
      <xsl:variable name="pers-id" select="substring-after(@ref,'#')"/>
      <xsl:variable name="person-id" select="document('../../content/xml/authority/listPersons.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
      <xsl:choose>
        <xsl:when test="$person-id/tei:surname"><xsl:value-of select="$person-id/tei:surname"/><xsl:text> </xsl:text><xsl:value-of select="$person-id/tei:forename"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$person-id"/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:date" mode="facet_data_invio">
    <field name="data_invio">
      <xsl:variable name="date-parts" select="tokenize(@when, '-')"/>
      <xsl:choose>
        <xsl:when test="count($date-parts)=3"><xsl:value-of select="format-date(@when,'[Y0001].[M01].[D01]')" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
        <xsl:when test="count($date-parts)=2"><xsl:value-of select="format-date(xs:date(concat(@when,'-01')),'[Y0001].[M01]')" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
        <xsl:when test="count($date-parts)=1"><xsl:value-of select="number(@when)" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
        <xsl:otherwise><xsl:text>Non specificata</xsl:text></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:date" mode="facet_data_ricezione">
    <field name="data_ricezione">
      <xsl:variable name="date-parts" select="tokenize(@when, '-')"/>
      <xsl:choose>
        <xsl:when test="count($date-parts)=3"><xsl:value-of select="format-date(@when,'[Y0001].[M01].[D01]')" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
        <xsl:when test="count($date-parts)=2"><xsl:value-of select="format-date(xs:date(concat(@when,'-01')),'[Y0001].[M01]')" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
        <xsl:when test="count($date-parts)=1"><xsl:value-of select="number(@when)" /><xsl:if test="@cert='low'"><xsl:text> (?)</xsl:text></xsl:if></xsl:when>
        <xsl:otherwise><xsl:text>Non specificata</xsl:text></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:placeName" mode="facet_luogo_invio">
    <field name="luogo_invio">
      <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
      <xsl:variable name="place-id" select="document('../../content/xml/authority/listPlaces.xml')//tei:place[@xml:id=$pl-id]/tei:placeName"/>
      <xsl:choose>
        <xsl:when test="$place-id"><xsl:value-of select="$place-id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:placeName" mode="facet_luogo_ricezione">
    <field name="luogo_ricezione">
      <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
      <xsl:variable name="place-id" select="document('../../content/xml/authority/listPlaces.xml')//tei:place[@xml:id=$pl-id]/tei:placeName"/>
      <xsl:choose>
        <xsl:when test="$place-id"><xsl:value-of select="$place-id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:summary[@corresp]" mode="facet_tipologia_documentaria">
      <xsl:variable name="doc-id" select="tokenize(replace(@corresp,'#',''),' ')"/>
      <xsl:variable name="document-id1" select="document('../../content/xml/authority/document_type.xml')//tei:item[@xml:id=$doc-id[1]]/tei:term"/>
      <xsl:variable name="document-id2" select="document('../../content/xml/authority/document_type.xml')//tei:item[@xml:id=$doc-id[2]]/tei:term"/>
    <xsl:if test="$document-id1"><field name="tipologia_documentaria"><xsl:value-of select="$document-id1"/></field></xsl:if>
    <xsl:if test="$document-id2"><field name="tipologia_documentaria"><xsl:value-of select="$document-id2"/></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@type='transcription']" mode="facet_lingua">
    <field name="lingua">
      <xsl:choose>
        <xsl:when test="@xml:lang='it'">Italiano</xsl:when>
        <xsl:when test="@xml:lang='fr'">Francese</xsl:when>
        <xsl:otherwise><xsl:value-of select="@xml:lang"/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:date[@when]" mode="facet_anno_invio">
    <field name="anno_invio">
      <xsl:variable name="date-parts" select="tokenize(@when, '-')"/>
      <xsl:choose>
        <xsl:when test="count($date-parts)=3"><xsl:value-of select="format-date(@when,'[Y0001]')" /></xsl:when>
        <xsl:when test="count($date-parts)=2"><xsl:value-of select="format-date(xs:date(concat(@when,'-01')),'[Y0001]')" /></xsl:when>
        <xsl:when test="count($date-parts)=1"><xsl:value-of select="number(@when)" /></xsl:when>
      </xsl:choose>
        <!--<xsl:value-of select="format-date(@when,'[Y0001]')"/>-->
    </field>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  <xsl:template name="extra_fields" >
    <xsl:call-template name="field_persone_menzionate"/>  
    <xsl:call-template name="field_luoghi_menzionati"/>
    <xsl:call-template name="field_istituzioni_menzionate"/>  
    <xsl:call-template name="field_autori_menzionati"/>  
    <xsl:call-template name="field_opere_menzionate"/>  
    <xsl:call-template name="field_fonti_menzionate"/>  
    <xsl:call-template name="field_tematiche"/>
    <xsl:call-template name="field_mittente"/>  
    <xsl:call-template name="field_destinatario"/>  
    <xsl:call-template name="field_data_invio"/>  
    <xsl:call-template name="field_data_ricezione"/>  
    <xsl:call-template name="field_luogo_invio"/>  
    <xsl:call-template name="field_luogo_ricezione"/>  
    <xsl:call-template name="field_tipologia_documentaria"/>  
    <xsl:call-template name="field_lingua"/>  
    <xsl:call-template name="field_anno_invio"/>  
  </xsl:template>
  
  <xsl:template name="field_persone_menzionate">
    <xsl:apply-templates mode="facet_persone_menzionate" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_luoghi_menzionati">
    <xsl:apply-templates mode="facet_luoghi_menzionati" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_istituzioni_menzionate">
    <xsl:apply-templates mode="facet_istituzioni_menzionate" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_autori_menzionati">
    <xsl:apply-templates mode="facet_autori_menzionati" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_opere_menzionate">
    <xsl:apply-templates mode="facet_opere_menzionate" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_fonti_menzionate">
    <xsl:apply-templates mode="facet_fonti_menzionate" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_tematiche">
    <xsl:apply-templates mode="facet_tematiche" select="//tei:TEI" />
  </xsl:template>
  
  <xsl:template name="field_mittente">
    <xsl:apply-templates mode="facet_mittente" select="//tei:correspAction[@type='sent']" />
  </xsl:template>
  
  <xsl:template name="field_destinatario">
    <xsl:apply-templates mode="facet_destinatario" select="//tei:correspAction[@type='received']" />
  </xsl:template>
  
  <xsl:template name="field_data_invio">
    <xsl:apply-templates mode="facet_data_invio" select="//tei:correspAction[@type='sent']" />
  </xsl:template>
  
  <xsl:template name="field_data_ricezione">
    <xsl:apply-templates mode="facet_data_ricezione" select="//tei:correspAction[@type='received']" />
  </xsl:template>
  
  <xsl:template name="field_luogo_invio">
    <xsl:apply-templates mode="facet_luogo_invio" select="//tei:correspAction[@type='sent']" />
  </xsl:template>
  
  <xsl:template name="field_luogo_ricezione">
    <xsl:apply-templates mode="facet_luogo_ricezione" select="//tei:correspAction[@type='received']" />
  </xsl:template>
  
  <xsl:template name="field_tipologia_documentaria">
    <xsl:apply-templates mode="facet_tipologia_documentaria" select="//tei:msContents" />
  </xsl:template>
  
  <xsl:template name="field_lingua">
    <xsl:apply-templates mode="facet_lingua" select="//tei:div[@type='transcription']" />
  </xsl:template>
  
  <xsl:template name="field_anno_invio">
    <xsl:apply-templates mode="facet_anno_invio" select="//tei:correspAction[@type='sent']" />
  </xsl:template>
  
</xsl:stylesheet>
