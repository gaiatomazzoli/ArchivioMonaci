<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of TEI documents into a Solr index document. -->

  <xsl:import href="tei-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:orgName[ancestor::tei:div/@type='transcription']" group-by="@ref">
        <xsl:sort select="translate(normalize-unicode(lower-case(current-grouping-key()),'NFD'), '&#x0300;&#x0301;&#x0308;&#x0303;&#x0304;&#x0313;&#x0314;&#x0345;&#x0342;' ,'')"/> <!-- non funziona -->
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:variable name="org-id" select="substring-after(@ref,'#')"/>
            <xsl:variable name="organ-id" select="document('../../content/xml/authority/listOrg.xml')//tei:org[@xml:id=$org-id]/tei:orgName"/>
            <xsl:choose>
              <xsl:when test="$organ-id"><xsl:value-of select="$organ-id" /></xsl:when>
              <xsl:when test="$org-id"><xsl:value-of select="$org-id" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:orgName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
