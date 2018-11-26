<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 >
<xsl:output method="html"/>

<xsl:param name="base"/>

<xsl:template match="/">
  <xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="head">
  <head>
  <!-- if multiple <base> elements are specified, only the first one is used -->
  <xsl:if test="$base != ''">
    <base href="{$base}" />
  </xsl:if>
  <xsl:apply-templates select="*|@*|text()"/>
  </head>
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
