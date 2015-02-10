xsltproc --stringparam top-namespace Example --stringparam base-filename example --stringparam dom-type XML::Dom --stringparam additional-include xml.hpp xsd-to-hpp.xslt "$1"
