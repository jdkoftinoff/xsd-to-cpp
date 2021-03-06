<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
    <xsl:output method="text"/>
    <xsl:param name="top-namespace"/>
    <xsl:param name="base-filename"/>
    <xsl:param name="dom-type"/>
    <xsl:param name="additional-include"/>

    <xsl:template name="print-copyright-license">
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>

    <xsl:template name="print-header-preamble">
        <xsl:call-template name="print-copyright-license"/>
        <xsl:text>#pragma once&#x0a;</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:text>#include &lt;string&gt;&#x0a;</xsl:text>
        <xsl:text>#include &lt;cstdint&gt;&#x0a;</xsl:text>
        <xsl:text>#include &lt;memory&gt;&#x0a;</xsl:text>
        <xsl:text>#include &lt;vector&gt;&#x0a;</xsl:text>
        <xsl:text>#include &lt;array&gt;&#x0a;</xsl:text>
        <xsl:if test="string-length($additional-include)>0">
            <xsl:text>#include "</xsl:text>
            <xsl:value-of select="$additional-include"/>
            <xsl:text>"&#x0a;</xsl:text>
        </xsl:if>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>

    <xsl:template name="generate-indent">            
        <xsl:param name="indent"/>
        <xsl:value-of select="substring('                                        ',1,$indent)"/>
    </xsl:template>

    <xsl:template name="insert-comment">
        <xsl:param name="comment"/>
        <xsl:param name="name"/>
        <xsl:param name="indent"/>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:text>/** </xsl:text>
        <xsl:if test="string-length($name)>0">
            <xsl:value-of select="$name"/>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
        <xsl:if test="string-length($comment)>0">
            <xsl:call-template name="generate-indent">            
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
            <xsl:text> *&#x0a;</xsl:text>
            <xsl:call-template name="generate-indent">            
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
            <xsl:text> *  </xsl:text>
            <xsl:value-of select="$comment"/>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:text> */</xsl:text>
        <xsl:text>&#x0a;</xsl:text>     
    </xsl:template>

    <xsl:template name="type-map">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="substring($type,1,3)='xs:'">
                <xsl:choose>
                    <xsl:when test="$type='xs:byte'">
                        <xsl:value-of select="'int8_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:short'">
                        <xsl:value-of select="'int16_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:integer'">
                        <xsl:value-of select="'int32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:int'">
                        <xsl:value-of select="'int32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:long'">
                        <xsl:value-of select="'int64_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:unsignedShort'">
                        <xsl:value-of select="'uint16_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:unsignedInt'">
                        <xsl:value-of select="'uint32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:unsignedLong'">
                        <xsl:value-of select="'uint64_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:positiveInteger'">
                        <xsl:value-of select="'int32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:nonPositiveInteger'">
                        <xsl:value-of select="'int32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:nonNegativeInteger'">
                        <xsl:value-of select="'int32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:negativeInteger'">
                        <xsl:value-of select="'int32_t'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:decimal'">
                        <xsl:value-of select="'double'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:double'">
                        <xsl:value-of select="'double'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:float'">
                        <xsl:value-of select="'float'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:boolean'">
                        <xsl:value-of select="'bool'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:token'">
                        <xsl:value-of select="'std::string'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:normalizedString'">
                        <xsl:value-of select="'std::string'"/>
                    </xsl:when>
                    <xsl:when test="$type='xs:string'">
                        <xsl:value-of select="'std::string'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after($type,':')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-after($type,':')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="member-variable-map">
        <xsl:param name="name"/>
        <xsl:value-of select="concat('m_',$name)"/>
    </xsl:template>
  
    <xsl:template name="generate-simpletype">
        <xsl:param name="indent"/>
        <xsl:call-template name="insert-comment">
            <xsl:with-param name="name" select="@name"/>
            <xsl:with-param name="comment" select="xs:annotation/xs:documentation"/>
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:text>typedef </xsl:text>
        <xsl:call-template name="type-map">
            <xsl:with-param name="type" select="xs:restriction/@base"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>;</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>

    <xsl:template name="generate-declare-struct">
        <xsl:param name="name"/>
        <xsl:param name="indent"/>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:text>struct </xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>;&#x0a;</xsl:text>
    </xsl:template>

    <xsl:template name="declare-load-from-dom">
        <xsl:param name="name"/>
        <xsl:param name="indent"/>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:text>    void load( const </xsl:text>
        <xsl:value-of select="$dom-type"/>
        <xsl:text> &amp;dom, const std::string &amp;path ); </xsl:text>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
  
    <xsl:template name="declare-save-to-dom">
        <xsl:param name="name"/>
        <xsl:param name="indent"/>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:text>    void save( </xsl:text>
        <xsl:value-of select="$dom-type"/>
        <xsl:text> &amp;dom, const std::string &amp;path ) const;</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>
    
    <xsl:template name="generate-define-struct">        
        <xsl:param name="name"/>
        <xsl:param name="indent"/>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:call-template name="insert-comment">
            <xsl:with-param name="name" select="@name"/>
            <xsl:with-param name="comment" select="xs:annotation/xs:documentation"/>
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>        
        <xsl:text>struct </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>        
        <xsl:text>{</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:if test="string-length($dom-type)>0">
            <xsl:call-template name="declare-load-from-dom">
                <xsl:with-param name="name" select="@name"/>
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
            <xsl:call-template name="declare-save-to-dom">
                <xsl:with-param name="name" select="@name"/>
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:for-each select="xs:attribute | xs:complexContent/xs:extension//xs:attribute">
            <xsl:call-template name="generate-indent">            
                <xsl:with-param name="indent" select="$indent+4"/>
            </xsl:call-template>        
            <xsl:choose>
                <xsl:when test="@use='optional'">
                    <xsl:text>optional&lt;</xsl:text>
                    <xsl:call-template name="type-map">
                        <xsl:with-param name="type" select="@type"/>
                    </xsl:call-template>
                    <xsl:text>&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text></xsl:text>
                    <xsl:call-template name="type-map">
                        <xsl:with-param name="type" select="@type"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:call-template name="member-variable-map">
                <xsl:with-param name="name" select="@name"/>
            </xsl:call-template>
            <xsl:text>;</xsl:text>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="xs:sequence/xs:element | xs:complexContent/xs:extension/xs:sequence/xs:element">
            <xsl:text>&#x0a;</xsl:text>          
            <xsl:choose>
                <xsl:when test="(@minOccurs=@maxOccurs) and (@maxOccurs>1)">
                    <xsl:call-template name="generate-indent">            
                        <xsl:with-param name="indent" select="$indent+4"/>
                    </xsl:call-template>                            
                    <xsl:text>required&lt; std::array&lt;</xsl:text>
                    <xsl:value-of select="substring-after(@type,':')"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="@maxOccurs"/>
                    <xsl:text>&gt;&gt; </xsl:text>
                    <xsl:call-template name="member-variable-map">
                        <xsl:with-param name="name" select="@name"/>
                    </xsl:call-template>
                    <xsl:text>;</xsl:text>
                    <xsl:text>&#x0a;</xsl:text>
                </xsl:when>
                <xsl:when test="((@minOccurs=0) and ((@maxOccurs=1)) or (@maxOccurs=''))">
                    <xsl:call-template name="generate-indent">            
                        <xsl:with-param name="indent" select="$indent+4"/>
                    </xsl:call-template>                                                
                    <xsl:text>optional&lt;</xsl:text>
                    <xsl:value-of select="substring-after(@type,':')"/>
                    <xsl:text>&gt; </xsl:text>
                    <xsl:call-template name="member-variable-map">
                        <xsl:with-param name="name" select="@name"/>
                    </xsl:call-template>
                    <xsl:text>;</xsl:text>
                    <xsl:text>&#x0a;</xsl:text>
                </xsl:when>
                <xsl:when test="((@minOccurs=0 or @minOccurs>1) and ((@maxOccurs>1)) or (@maxOccurs='unbounded'))">
                    <xsl:call-template name="generate-indent">            
                        <xsl:with-param name="indent" select="$indent+4"/>
                    </xsl:call-template>                                                
                    <xsl:text>std::vector&lt;</xsl:text>
                    <xsl:value-of select="substring-after(@type,':')"/>
                    <xsl:text>&gt; </xsl:text>
                    <xsl:call-template name="member-variable-map">
                        <xsl:with-param name="name" select="@name"/>
                    </xsl:call-template>
                    <xsl:text>;</xsl:text>
                    <xsl:text>&#x0a;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="generate-indent">            
                        <xsl:with-param name="indent" select="$indent+4"/>
                    </xsl:call-template>                                                
                    <xsl:text>required&lt;</xsl:text>
                    <xsl:value-of select="substring-after(@type,':')"/>
                    <xsl:text>&gt; </xsl:text>
                    <xsl:call-template name="member-variable-map">
                        <xsl:with-param name="name" select="@name"/>
                    </xsl:call-template>
                    <xsl:text>;</xsl:text>
                    <xsl:text>&#x0a;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="generate-indent">            
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>                
        <xsl:text>};</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>

    <xsl:template name="open-namespace">
        <xsl:param name="namespace"/>
        <xsl:if test="string-length($namespace)>0">
            <xsl:text>&#x0a;</xsl:text>
            <xsl:text>namespace </xsl:text>
            <xsl:value-of select="$namespace"/>
            <xsl:text> {</xsl:text>
            <xsl:text>&#x0a;</xsl:text>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="close-namespace">
        <xsl:param name="namespace"/>
        <xsl:if test="string-length($namespace)>0">
            <xsl:text>&#x0a;</xsl:text>
            <xsl:text>}&#x0a;</xsl:text>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/xs:schema">
        <xsl:call-template name="print-header-preamble"/>
        <xsl:call-template name="open-namespace">
            <xsl:with-param name="namespace" select="$top-namespace"/>
        </xsl:call-template>
        <xsl:for-each select="xs:simpleType">
            <xsl:call-template name="generate-simpletype">
                <xsl:with-param name="indent" select="0"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:text>template &lt;typename T&gt; using optional = std::vector&lt;T&gt;;&#x0a;</xsl:text>
        <xsl:text>template &lt;typename T&gt; using required = std::vector&lt;T&gt;;&#x0a;</xsl:text>
        <xsl:text>&#x0a;</xsl:text>
        <xsl:for-each select="xs:complexType">
            <xsl:call-template name="generate-declare-struct">
                <xsl:with-param name="name" select="@name"/>
                <xsl:with-param name="indent" select="0"/>
            </xsl:call-template>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="xs:complexType">
            <xsl:call-template name="generate-define-struct">
                <xsl:with-param name="name" select="@name"/>
                <xsl:with-param name="indent" select="0"/>
            </xsl:call-template>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:for-each>
        <xsl:call-template name="close-namespace">
            <xsl:with-param name="namespace" select="$top-namespace"/>
        </xsl:call-template>

    </xsl:template>
</xsl:stylesheet>
