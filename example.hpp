
#pragma once

#include <string>
#include <cstdint>
#include <memory>
#include <vector>
#include <array>
#include "xml.hpp"


namespace Example {


/** Metres
 *
 *  
            A Distance in Metres
        
 */
typedef float Metres;

/** Seconds
 *
 *  
        A time in seconds
        
 */
typedef float Seconds;

template <typename T> using optional = std::vector<T>;
template <typename T> using required = std::vector<T>;

struct Edge;

struct Symbol;

struct Project;

struct Root;



/** Edge
 */
struct Edge
{
    void load( const XML::Dom &dom, const std::string &path ); 
    void save( XML::Dom &dom, const std::string &path ) const;

    std::string m_color;
    int32_t m_width;
};




/** Symbol
 */
struct Symbol
{
    void load( const XML::Dom &dom, const std::string &path ); 
    void save( XML::Dom &dom, const std::string &path ) const;

    Metres m_width;
    Metres m_height;
    std::string m_name;
    optional<std::string> m_id;

    required<Edge> m_top;

    required<Edge> m_left;

    required<Edge> m_right;

    required<Edge> m_bottom;
};




/** Project
 */
struct Project
{
    void load( const XML::Dom &dom, const std::string &path ); 
    void save( XML::Dom &dom, const std::string &path ) const;


    std::vector<Symbol> m_symbol;
};




/** Root
 */
struct Root
{
    void load( const XML::Dom &dom, const std::string &path ); 
    void save( XML::Dom &dom, const std::string &path ) const;


    required<Project> m_project;
};



}

