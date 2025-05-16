<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">

  <!-- Import the standard TEI HTML framework -->
  <xsl:import href="html.xsl"/>

  <!-- Set parameters to turn on TOC generation -->
  <xsl:template match="tei:*" mode="maketoc">
    <xsl:param name="forcedepth"/>
    <xsl:variable name="myName">
      <xsl:value-of select="local-name(.)"/>
    </xsl:variable>
    <xsl:if test="tei:head or $autoHead='true'">
      <xsl:variable name="Depth">
        <xsl:choose>
          <xsl:when test="not($forcedepth='')">
            <xsl:value-of select="$forcedepth"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$tocDepth"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="thislevel">
        <xsl:choose>
          <xsl:when test="$myName = 'div'">
            <xsl:value-of select="count(ancestor::tei:div)"/>
          </xsl:when>
          <xsl:when test="starts-with($myName,'div')">
            <xsl:value-of select="number(substring-after($myName,'div')) - 1"/>
          </xsl:when>
          <xsl:otherwise>99</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="pointer">
        <xsl:apply-templates mode="generateLink" select="."/>
      </xsl:variable>
      <li>
        <xsl:attribute name="class">
          <xsl:text>toc</xsl:text>
          <xsl:if test="not($autoHead='true') and not(tei:head or @n)"> headless</xsl:if>
          <xsl:if test=".//m:math and  $outputTarget='epub3'">
            <xsl:attribute
              name="class"> contains-mathml</xsl:attribute>
          </xsl:if>
        </xsl:attribute>
        <xsl:call-template name="header">
          <xsl:with-param name="toc" select="$pointer"/>
          <xsl:with-param name="minimal">false</xsl:with-param>
          <xsl:with-param name="display">plain</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="$thislevel &lt; $Depth">
          <xsl:call-template name="continuedToc"/>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>
  

  <!-- Optional: Customize the TOC wrapper -->
  <xsl:template name="tei:makeTOC">
    <div id="toc">
      <h2>Table of Contents</h2>
      <ul class="toc">
        <xsl:apply-templates select="//tei:div1" mode="maketoc"/>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>
