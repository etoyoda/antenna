<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 >
<xsl:output method="html"/>

<xsl:template match="/">
  <xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="div[@class='sub']">
  <span>(removed)</span>
</xsl:template>

<xsl:template match="a[@href]">
  <xsl:element name="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </xsl:element>
  &lt;URL:<xsl:value-of select="@href"/>&gt;
</xsl:template>

<xsl:template match="*">
  <xsl:element name="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="text()">
  <xsl:if test="normalize-space() != ''">
  <xsl:value-of select="."/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
