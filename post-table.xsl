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

<xsl:template match="a[@href]">
  <xsl:element name="{name(.)}">
  <xsl:apply-templates select="*|@*|text()"/>
  </xsl:element>
  <xsl:element name="code">
  <xsl:text>&lt;URL:</xsl:text>
  <xsl:call-template name="urljoin">
    <xsl:with-param name="lhs" select="$base"/>
    <xsl:with-param name="rhs" select="@href"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  </xsl:element>
</xsl:template>

<xsl:template name="urljoin">
  <xsl:param name="lhs" />
  <xsl:param name="rhs" />
  <xsl:choose>
  <xsl:when test="contains($rhs, '//')">
    <xsl:value-of select="$rhs"/>
  </xsl:when>
  <xsl:when test="starts-with($rhs, '/') and contains(substring-after($lhs, '//'), '/')">
    <xsl:value-of select="concat(
      substring-before($lhs, '//'),
      '//',
      substring-before(substring-after($lhs, '//'), '/'),
      substring($rhs, 2)
    )"/>
  </xsl:when>
  <xsl:when test="starts-with($rhs, '/') and substring-after($lhs, '//')">
    <xsl:value-of select="concat($lhs, $rhs)"/>
  </xsl:when>
  <xsl:when test="contains(substring-after($lhs, '//'), '/')">
    <xsl:call-template name="dirname">
      <xsl:with-param name="path" select="$lhs"/>
    </xsl:call-template>
    <xsl:value-of select="concat('/', $rhs)"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$rhs"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="dirname">
  <xsl:param name="path" />
  <xsl:choose>
  <xsl:when test="substring($path, string-length($path)) = '/'">
    <xsl:value-of select="substring($path, 1, string-length($path) - 1)"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="dirname">
      <xsl:with-param name="path" select="substring($path, 1, string-length($path) - 1)"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
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
