
#pragma once

#include <string>
#include <cstdint>
#include <memory>
#include <vector>
#include "xml.hpp"


namespace Example {

typedef float Metres;
typedef float Seconds;

struct Edge;
void load( const XML::Dom &dom, const std::string &path, Edge &item );
void save( XML::Dom &dom, const std::string &path, const Edge &item );

struct Symbol;
void load( const XML::Dom &dom, const std::string &path, Symbol &item );
void save( XML::Dom &dom, const std::string &path, const Symbol &item );

struct Project;
void load( const XML::Dom &dom, const std::string &path, Project &item );
void save( XML::Dom &dom, const std::string &path, const Project &item );

struct Root;
void load( const XML::Dom &dom, const std::string &path, Root &item );
void save( XML::Dom &dom, const std::string &path, const Root &item );


struct Edge
{
    std::string m_color;
    int32_t m_width;
};


struct Symbol
{
    Metres m_width;
    Metres m_height;
    std::string m_name;
    Edge m_top;
    Edge m_left;
    Edge m_right;
    Edge m_bottom;
};


struct Project
{
    std::vector<Symbol> m_symbol;
};


struct Root
{
    Project m_project;
};


}

