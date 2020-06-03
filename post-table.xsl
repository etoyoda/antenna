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

<xsl:template match="div[@style='opacity: 0;' and @class='sub']">
</xsl:template>

<xsl:template match="a[@href]">
  <xsl:element name="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </xsl:element>
  &lt;URL:<xsl:value-of select="@href"/>&gt;
</xsl:template>

<xsl:template match="table|thead|tbody|tfoot">
  <div data-org="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </div>
</xsl:template>

<xsl:template match="caption|tr">
  <p data-org="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </p>
</xsl:template>

<xsl:template match="th|td">
  <span data-org="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </span>
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
