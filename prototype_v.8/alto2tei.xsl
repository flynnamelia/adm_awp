<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:alto="http://schema.ccs-gmbh.com/ALTO"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="alto xsl">
    
    <!-- 
    XSLT 1.0 for transforming ALTO XML to a basic TEI file with 
    facsimile zones. Tested with xsltproc. 
    Make sure the ALTO namespace above ("http://schema.ccs-gmbh.com/ALTO")
    matches your file. If your ALTO uses a different URI, update it here.
  -->
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <!-- 
    For clarity, we won't strip whitespace, but you could add:
    <xsl:strip-space elements="*"/>
  -->
    
    <!-- ========== 1) Root template: create the TEI structure ========== -->
    <xsl:template match="/">
        <tei:TEI>
            <tei:teiHeader>
                <tei:fileDesc>
                    <tei:titleStmt>
                        <tei:title>ALTO to TEI Conversion</tei:title>
                    </tei:titleStmt>
                    <tei:publicationStmt>
                        <tei:p>Transformed from ALTO XML using XSLT 1.0.</tei:p>
                    </tei:publicationStmt>
                    <tei:sourceDesc>
                        <tei:p>Source: ALTO file</tei:p>
                    </tei:sourceDesc>
                </tei:fileDesc>
            </tei:teiHeader>
            
            <!-- A facsimile element for physical layout -->
            <tei:facsimile>
                <!-- Each ALTO Page becomes a <surface> in TEI -->
                <xsl:apply-templates select="//alto:Page"/>
            </tei:facsimile>
            
            <!-- Optionally, you could also produce a <text> element here 
           with reading-order text. For brevity, we omit that. -->
        </tei:TEI>
    </xsl:template>
    
    <!-- ========== 2) Page => surface ========== -->
    <xsl:template match="alto:Page">
        <tei:surface>
            <!-- Put the ALTO page number in @n -->
            <xsl:attribute name="n">
                <xsl:value-of select="@PHYSICAL_IMG_NR"/>
            </xsl:attribute>
            
            <!-- If there's a filename, reference it in <graphic> -->
            <tei:graphic>
                <xsl:attribute name="url">
                    <xsl:value-of select="alto:sourceImageInformation/alto:fileName"/>
                </xsl:attribute>
            </tei:graphic>
            
            <!-- Convert TextBlocks to TEI zones -->
            <xsl:apply-templates select="alto:PrintSpace/alto:TextBlock"/>
        </tei:surface>
    </xsl:template>
    
    <!-- ========== 3) TextBlock => zone (with bounding box) ========== -->
    <xsl:template match="alto:TextBlock">
        <tei:zone>
            <!-- We'll compute lrx = HPOS+WIDTH, lry = VPOS+HEIGHT in variables, 
           since XSLT 1.0 doesn't allow direct arithmetic in attributes. -->
            
            <xsl:variable name="ulx" select="number(@HPOS)"/>
            <xsl:variable name="uly" select="number(@VPOS)"/>
            <xsl:variable name="lrx" select="number(@HPOS) + number(@WIDTH)"/>
            <xsl:variable name="lry" select="number(@VPOS) + number(@HEIGHT)"/>
            
            <xsl:attribute name="ulx"><xsl:value-of select="$ulx"/></xsl:attribute>
            <xsl:attribute name="uly"><xsl:value-of select="$uly"/></xsl:attribute>
            <xsl:attribute name="lrx"><xsl:value-of select="$lrx"/></xsl:attribute>
            <xsl:attribute name="lry"><xsl:value-of select="$lry"/></xsl:attribute>
            
            <!-- Within a TextBlock, transform each TextLine -->
            <xsl:apply-templates select="alto:TextLine"/>
        </tei:zone>
    </xsl:template>
    
    <!-- ========== 4) TextLine => nested zone with <line> text ========== -->
    <xsl:template match="alto:TextLine">
        <tei:zone>
            <!-- Again, compute bounding box -->
            <xsl:variable name="ulx" select="number(@HPOS)"/>
            <xsl:variable name="uly" select="number(@VPOS)"/>
            <xsl:variable name="lrx" select="number(@HPOS) + number(@WIDTH)"/>
            <xsl:variable name="lry" select="number(@VPOS) + number(@HEIGHT)"/>
            
            <xsl:attribute name="ulx"><xsl:value-of select="$ulx"/></xsl:attribute>
            <xsl:attribute name="uly"><xsl:value-of select="$uly"/></xsl:attribute>
            <xsl:attribute name="lrx"><xsl:value-of select="$lrx"/></xsl:attribute>
            <xsl:attribute name="lry"><xsl:value-of select="$lry"/></xsl:attribute>
            
            <!-- Gather text from <String> elements into one <line> -->
            <tei:line>
                <xsl:apply-templates select="alto:String"/>
            </tei:line>
        </tei:zone>
    </xsl:template>
    
    <!-- ========== 5) String => text in <line> ========== -->
    <xsl:template match="alto:String">
        <xsl:choose>
            <!-- For the first <String> in a line, no leading space -->
            <xsl:when test="position() = 1">
                <xsl:value-of select="@CONTENT"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@CONTENT"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ========== 6) Ignore other text nodes & attributes by default ========== -->
    <xsl:template match="text()|@*">
        <!-- no output -->
    </xsl:template>
    
</xsl:stylesheet>
