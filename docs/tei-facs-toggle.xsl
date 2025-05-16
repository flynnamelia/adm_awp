<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei">

  <!-- Parameter to choose embedding vs linking -->
  <xsl:param name="embedFacsimile" select="'false'"/>

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- Root -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
        <link rel="stylesheet" href="style.css"/>
      </head>
      <body>
        <div id="controls">
          <button onclick="toggleApparatus('B')">Base Text</button>
          <button onclick="toggleApparatus('A')">Variant Text</button>
          <button onclick="toggleApparatus('both')">Show Both</button>
        </div>
        <div id="edition">
          <xsl:apply-templates select="//tei:text"/>
        </div>
        <script src="toggle.js"></script>
      </body>
    </html>
  </xsl:template>

  <!-- Paragraphs and lines -->
  <xsl:template match="tei:p|tei:l">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <!-- Page breaks: insert page number and facsimile -->
  <xsl:template match="tei:pb">
    <div class="page" id="page{@n}">
      <span class="pagenum">Page <xsl:value-of select="@n"/></span>
      <xsl:if test="@facs">
        <div class="facsimile">
          <xsl:choose>
            <xsl:when test="$embedFacsimile='true'">
              <img src="{@facs}" alt="Facsimile of page {@n}"/>
            </xsl:when>
            <xsl:otherwise>
              <a href="{@facs}" target="_blank">View facsimile page <xsl:value-of select="@n"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- Critical apparatus -->
  <xsl:template match="tei:app">
    <span class="app variant">
      <xsl:apply-templates select="tei:rdg[@wit='#B_AWP']"/>
      <xsl:apply-templates select="tei:rdg[@wit='#N_AWP']"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:rdg[@wit='#B_AWP']">
    <span class="rdg rdg-B"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:rdg[@wit='#N_AWP']">
    <span class="rdg rdg-A hidden"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- Identity fallback -->
  <xsl:template match="*|@*">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
