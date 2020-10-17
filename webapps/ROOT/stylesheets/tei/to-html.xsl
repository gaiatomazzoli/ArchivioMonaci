<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <xsl:template match="tei:hi[@rend='superscript']">  <!-- non serve più -->
    <sup><xsl:apply-templates/></sup>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='underline']">  <!-- non funziona se è dentro a <expan> -->
    <u><xsl:apply-templates/></u>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='stacked']">
    [<i>variante: </i> <xsl:apply-templates/>]
  </xsl:template>
  
  <xsl:template match="tei:pb">
    <xsl:choose><xsl:when test="@break"><xsl:text>/</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text> / </xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:gap[@reason='illegible'][@unit='chars']">
    <xsl:choose>
      <xsl:when test="@quantity"><i>[<xsl:value-of select="@quantity"/> caratteri illeggibili]</i></xsl:when>
      <xsl:when test="@atLeast"><i>[<xsl:value-of select="@atLeast"/>-<xsl:value-of select="@atMost"/> caratteri illeggibili]</i></xsl:when>
      <xsl:when test="@extent"><i>[più caratteri illeggibili]</i></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:postscript">
    <xsl:call-template name="tei-make-div" />
  </xsl:template>
  
  <xsl:template match="tei:address">
    <xsl:choose>
      <xsl:when test="ancestor::tei:dateline"><xsl:apply-templates/></xsl:when>
      <xsl:otherwise><xsl:call-template name="tei-make-p" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:unclear">
    <xsl:apply-templates/><xsl:text> (?)</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:addrLine">
    <xsl:apply-templates/><xsl:if test="following-sibling::tei:addrLine"><br/></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:note">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:head">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>
  
  <xsl:template match="tei:abbr" mode="abbr">
    <xsl:choose>
      <xsl:when test="ancestor::tei:hi[@rend='underline'] or descendant::tei:hi[@rend='underline']"><u><xsl:apply-templates/></u></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:abbr" mode="expanded_abbr">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:am" mode="abbr">
    <xsl:choose>
      <xsl:when test="ancestor::tei:hi[@rend='underline'] or descendant::tei:hi[@rend='underline']"><u><xsl:apply-templates/></u></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:am" mode="expanded_abbr">
  </xsl:template>
  
  <xsl:template match="tei:ex" mode="abbr">
  </xsl:template>
  <xsl:template match="tei:ex" mode="expanded_abbr">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:expan">
    <!-- se le abbreviazioni generano già un popup poiché sono nomi aventi un @ref, non compare il popup dello scioglimento dell’abbreviazione -->
    <xsl:choose>
      <xsl:when test="ancestor::tei:persName[@ref] or ancestor::tei:orgName[@ref] or ancestor::tei:title[@ref]">
        <xsl:apply-templates mode="abbr" select="."/>
      </xsl:when>  
      <xsl:otherwise>
        <span class="popup_box">
          <span class="popup_word"><xsl:apply-templates mode="abbr" select="."/></span>
          <span class="popup"><xsl:apply-templates mode="expanded_abbr" select="."/></span>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="tei:div[@type='transcription']//tei:persName">
    <xsl:variable name="pers-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="person-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/listPersons.xml'))//tei:person[@xml:id=$pers-id]"/>
    <xsl:choose>
      <xsl:when test="$pers-id">
        <xsl:choose>
          <xsl:when test="ancestor::tei:title"><xsl:apply-templates /></xsl:when>
          <xsl:otherwise>
            <span class="popup_box"><span class="popup_word"><xsl:choose>
              <xsl:when test="$person-id/tei:idno[@type='Treccani']"><a><xsl:attribute name="href"><xsl:value-of select="$person-id/tei:idno[@type='Treccani']"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates /></a></xsl:when>
              <xsl:otherwise><xsl:apply-templates /></xsl:otherwise></xsl:choose></span>
              <span class="popup">
                <xsl:if test="$person-id/tei:persName/tei:forename"><xsl:value-of select="$person-id/tei:persName/tei:forename"/></xsl:if>
                <xsl:if test="$person-id/tei:persName/tei:forename and $person-id/tei:persName/tei:surname"><xsl:text> </xsl:text></xsl:if>
                <xsl:if test="$person-id/tei:persName/tei:surname"><xsl:value-of select="$person-id/tei:persName/tei:surname"/></xsl:if>
                <xsl:if test="$person-id[not(descendant::tei:forename)]"><xsl:value-of select="$person-id/tei:persName" /></xsl:if>
                <xsl:if test="$person-id/tei:birth or $person-id/tei:death"><xsl:text> (</xsl:text><xsl:choose><xsl:when test="$person-id/tei:birth/@when"><xsl:value-of select="$person-id/tei:birth/@when"/></xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose><xsl:text>-</xsl:text><xsl:choose><xsl:when test="$person-id/tei:death/@when"><xsl:value-of select="$person-id/tei:death/@when"/></xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose><xsl:text>)</xsl:text></xsl:if>
              </span></span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:div[@type='transcription']//tei:title">
    <xsl:variable name="ti-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="title-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/listBibl.xml'))//tei:bibl[@xml:id=$ti-id]"/>
    <xsl:variable name="ti-parts" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="title1-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/listBibl.xml'))//tei:bibl[@xml:id=$ti-parts[1]]"/>
    <xsl:variable name="title2-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/listBibl.xml'))//tei:bibl[@xml:id=$ti-parts[2]]"/>
    <xsl:choose>
      <xsl:when test="count($ti-parts)=2">
        <xsl:choose>
          <xsl:when test="$title1-id and $title2-id">
          <span class="popup_box"><span class="popup_word"><xsl:apply-templates /></span>
            <span class="popup">
              <xsl:if test="$title1-id/tei:author"><xsl:value-of select="$title1-id/tei:author"/><xsl:text>, </xsl:text></xsl:if>
              <i><xsl:value-of select="$title1-id/tei:title[1]"/></i><xsl:if test="$title1-id/tei:date"><xsl:text>, </xsl:text>
                <xsl:if test="$title1-id/tei:title[2]"><xsl:text>in </xsl:text><i><xsl:value-of select="$title1-id/tei:title[2]"/></i><xsl:text>, </xsl:text></xsl:if>
                <xsl:choose>
                  <xsl:when test="$title1-id/tei:date[@when]"><xsl:value-of select="$title1-id/tei:date/@when"/></xsl:when>
                  <xsl:when test="$title1-id/tei:date[@from][@to]"><xsl:value-of select="concat($title1-id/tei:date/@from,'-',$title1-id/tei:date/@to)"/></xsl:when>
                  <xsl:when test="$title1-id/tei:date[@from][not(@to)]"><xsl:value-of select="concat($title1-id/tei:date/@from,'-')"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$title1-id/tei:date"/></xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <xsl:text>. </xsl:text>
              <xsl:if test="$title2-id/tei:author"><xsl:value-of select="$title2-id/tei:author"/><xsl:text>, </xsl:text></xsl:if>
              <i><xsl:value-of select="$title2-id/tei:title[1]"/></i><xsl:if test="$title2-id/tei:date"><xsl:text>, </xsl:text>
                <xsl:if test="$title2-id/tei:title[2]"><xsl:text>in </xsl:text><i><xsl:value-of select="$title2-id/tei:title[2]"/></i><xsl:text>, </xsl:text></xsl:if>
                <xsl:choose>
                  <xsl:when test="$title2-id/tei:date[@when]"><xsl:value-of select="$title2-id/tei:date/@when"/></xsl:when>
                  <xsl:when test="$title2-id/tei:date[@from][@to]"><xsl:value-of select="concat($title2-id/tei:date/@from,'-',$title2-id/tei:date/@to)"/></xsl:when>
                  <xsl:when test="$title2-id/tei:date[@from][not(@to)]"><xsl:value-of select="concat($title2-id/tei:date/@from,'-')"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$title2-id/tei:date"/></xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <xsl:text>.</xsl:text>
            </span>
          </span>
          </xsl:when>
          <!-- link ad altre lettere note -->
        <xsl:when test="@type='letter' and @ref">
          <a><xsl:attribute name="href">
            <xsl:value-of select="@ref"/>
          <!--<xsl:choose>
            <xsl:when test="contains(@ref,'http') or contains(@ref,'www')"><xsl:value-of select="@ref"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="concat('./',@ref,'.html')"/></xsl:otherwise>
          </xsl:choose>-->
        </xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
        </xsl:when> 
        <xsl:when test="@key"><span class="popup_box"><span class="popup_word"><xsl:apply-templates /></span>
          <span class="popup"><xsl:value-of select="@key"/></span></span>
        </xsl:when>
        <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
      </xsl:choose>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$ti-id">
            <span class="popup_box"><span class="popup_word"><xsl:apply-templates /></span>
              <span class="popup"><xsl:if test="$title-id/tei:author"><xsl:value-of select="$title-id/tei:author"/><xsl:text>, </xsl:text></xsl:if>
                <i><xsl:value-of select="$title-id/tei:title[1]"/></i><xsl:if test="$title-id/tei:date"><xsl:text>, </xsl:text>
                  <xsl:if test="$title-id/tei:title[2]"><xsl:text>in </xsl:text><i><xsl:value-of select="$title-id/tei:title[2]"/></i><xsl:text>, </xsl:text></xsl:if>
                  <xsl:choose>
                    <xsl:when test="$title-id/tei:date[@when]"><xsl:value-of select="$title-id/tei:date/@when"/></xsl:when>
                    <xsl:when test="$title-id/tei:date[@from][@to]"><xsl:value-of select="concat($title-id/tei:date/@from,'-',$title-id/tei:date/@to)"/></xsl:when>
                    <xsl:when test="$title-id/tei:date[@from][not(@to)]"><xsl:value-of select="concat($title-id/tei:date/@from,'-')"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$title-id/tei:date"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:if><xsl:text>.</xsl:text></span></span>
          </xsl:when>
          <xsl:when test="@type='letter' and @ref"><a><xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></xsl:when>  <!-- link ad altre lettere note -->
          <xsl:when test="@key">
            <xsl:choose>
              <xsl:when test="@type='manuscript' and @corresp"> <!-- appare solo se c'è anche @key -->
                <span class="popup_box"><span class="popup_word"><a><xsl:attribute name="href"><xsl:value-of select="@corresp"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></span>
                  <span class="popup"><xsl:value-of select="@key"/></span></span>
              </xsl:when>
              <xsl:otherwise><span class="popup_box"><span class="popup_word"><xsl:apply-templates /></span>
                <span class="popup"><xsl:value-of select="@key"/></span></span></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          
          <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:div[@type='transcription']//tei:orgName">
    <xsl:variable name="org-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="organization-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/listOrg.xml'))//tei:org[@xml:id=$org-id]/tei:orgName"/>
    <xsl:choose>
      <xsl:when test="$org-id">
        <span class="popup_box"><span class="popup_word"><xsl:apply-templates /></span>
          <span class="popup"><xsl:value-of select="$organization-id"/></span></span>
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--
  <xsl:template match="tei:addrLine">
    <br/><xsl:apply-templates/>
  </xsl:template>-->
  
</xsl:stylesheet>
