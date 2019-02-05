# author:  Manuel Gunther <siebenkopf@googlemail.com>
# date:    Wed May 25 10:55:42 MDT 2016
# license: BSD-3, see LICENSE file
#
# This file can be used to find Bob packages that provide a C++ interface.
# To find Bob libraries, use the CMake find_package command, and list all Bob packages as COMPONENTS, e.g.:
#
# - find_package(Bob COMPONENTS bob.io.base bob.learn.em REQUIRED)
#
# This will search recursively for all Bob packages (and its required Bob packages), which need to be installed beforehand, in this order:
#
# - installed (e.g. by using mr.developer) in the src directory
# - installed (e.g. by buildout) in the eggs directory
# - installed (e.g. via virtualenv) in the BOB_PREFIX_PATH (if given, either as an environment variable or as a CMake variable)
# - installed (e.g. via pip) in the system path
#
# After the successful run of find_package, these CMake variables will be filled:
#
# - Bob_INCLUDE_DIRS: The include directories of all required Bob packages, and their external requirements.
#   Use e.g. include_directories(${Bob_INCLUDE_DIRS}) to add them
#
# - Bob_LIBRARY_DIRS: The library directories of all required Bob packages.
#   Use e.g. link_directories(${Bob_LIBRARY_DIRS}) to add them
#
# - Bob_LIBRARIES: The C++ libraries of all required Bob packages.
#   Use e.g. link_libraries(${Bob_LIBRARIES}) to add them
#
# - Bob_DEFINITIONS: The preprocessor defines required to build your package (already including the "-D").
#   Use e.g. add_definitions(${Bob_DEFINITIONS}) to add them


# converts the given package name (including the dots) to a directory and to a variable usable by CMake
macro(_convert_package_to_string package)
  string(REPLACE "." "_" PACKAGE_LIB "${package}")
  string(REPLACE "." "/" PACKAGE_DIR "${package}")
  string(TOUPPER "${PACKAGE_LIB}" PACKAGE)
endmacro()

# finds the python executable, which might be in ./bin, BOB_PREFIX_PATH/bin or in the system path
macro(_find_python)
  if (NOT _python)
    set(_possible_paths ${CMAKE_PREFIX_PATH}/bin ${BOB_SOURCE_DIR}/bin)
    if (BOB_PREFIX_PATH)
      list(APPEND _possible_paths ${BOB_PREFIX_PATH}/bin)
    endif()
    # first, find python in bob's paths, if possible
    find_program(_python python HINTS ${_possible_paths} NO_CMAKE_PATH)
    if (NOT _python)
      # now, search in the system path
      find_program(_python python)
    endif()
  endif()
endmacro()


# gets the list of external includes required by the Bob package
macro(_get_external_includes package)
  _find_python()
  execute_process(COMMAND ${_python} -c "exec(\"import ${package},sys\\nif hasattr(${package}, 'get_include_directories'): sys.stdout.write(';'.join(${package}.get_include_directories()))\")" OUTPUT_VARIABLE _external_includes)
endmacro()

macro(_get_external_macros package)
  # gets the list of macros required by the Bob package
  _find_python()
  execute_process(COMMAND ${_python} -c "exec(\"import ${package},sys\\nif hasattr(${package}, 'get_macros'): sys.stdout.write(';'.join('-D%s=%s' % m for m in ${package}.get_macros()))\")" OUTPUT_VARIABLE _external_macros)
endmacro()


# recurses through the requirements and get all bob packages
macro(_recurse_requirements requirements)
  file(STRINGS ${requirements} _reqs)
  foreach (_req IN LISTS _reqs)
    # check if string starts with bob
    string(FIND ${_req} bob _pos)
    if (NOT ${_pos} EQUAL -1)
      # check if any versioning is added
      set(_chars "=;<;>; ")
      foreach (_char IN LISTS _chars)
        string(FIND ${_req} ${_char} _pos)
        if (NOT ${_pos} EQUAL -1)
          string(REPLACE "${_char}" ";" _temp ${_req})
          list(GET _temp 0 _req)
        endif()
      endforeach()
      # find bob package recursively (will not run if pacakge was already found)
      find_bob_package(${_req})
    endif()
  endforeach()
endmacro()


# Function to find a specific Bob package;
# This function will search for Bob packages in several directories
# If found, it will add include directories -- and library directories and libraries if applicable
function(find_bob_package package)

  # get the uppercase package name in ${PACKAGE}
  # the package directory in ${PACKAGE_DIR}
  # and the possible lib name in ${PACKAGE_LIB}
  _convert_package_to_string(${package})

  if (${PACKAGE}_FOUND)
    return()
  endif()

  # define possible path
  set(_possible_paths
    ${BOB_SOURCE_DIR}/src/${package}
    ${CMAKE_PREFIX_PATH}/lib/*/site-packages
  )
  # .. egg directory
  file(GLOB _egg_dir ${BOB_SOURCE_DIR}/eggs/${package}*.egg)
  if (_egg_dir)
    list(APPEND _possible_paths ${_egg_dir})
  endif()
  # .. BOB_PREFIX_PATH
  if (BOB_PREFIX_PATH)
    list(APPEND _possible_paths ${BOB_PREFIX_PATH}/lib/*/site-packages)
  endif()
  if (CMAKE_PREFIX_PATH)
    list(APPEND _possible_paths ${CMAKE_PREFIX_PATH}/lib/*/site-packages)
  endif()

  # add common path to locations
  set(_bob_paths)
  foreach(_path IN LISTS _possible_paths)
    list(APPEND _bob_paths ${_path}/${PACKAGE_DIR})
  endforeach()

  # check if we find any bob directory
  find_path(_package_dir
    NAMES __init__.py
    HINTS ${_bob_paths}
  )

  # assert that we have found the package
  if (NOT _package_dir)
    unset(_package_dir CACHE)
    if (Bob_FIND_REQUIRED)
      # if the package was required and we didn't find it, stop here
      message(FATAL_ERROR "Could not find bob package '${package}'")
    endif()
    # otherwise, set the package to NOTFOUND and continue
    set(${PACKAGE} ${PACKAGE}-NOTFOUND PARENT_SCOPE)
    return()
  endif()

  message(STATUS "Found Bob package '${package}' at '${_package_dir}'")

  set(${PACKAGE}_FOUND TRUE CACHE BOOL "The package ${package} has been found." FORCE)

  # first, parse the requirements (requires.txt) from the requires.txt inside ${PACKAGE_BASE_DIR}/${package}*.egg-info or ${PACKAGE_BASE_DIR}/EGG-INFO
  # get the base directory of the currently found package
  string(FIND ${_package_dir} /${PACKAGE_DIR} _pos)
  string(SUBSTRING ${_package_dir} 0 ${_pos} _base_dir)
  # get the egg info directory (either in package-version.egg-info or in EGG-INFO)
  file(GLOB _egg_info_dir ${_base_dir}/${package}*.egg-info ${_base_dir}/EGG-INFO)
  find_file(
    _requirements
    NAMES requires.txt
    HINTS ${_egg_info_dir}
    NO_CMAKE_PATH
  )
  # parse the requirements and add packages recursively
  if (_requirements)
    set(_r ${_requirements})
    unset(_requirements CACHE)
    set(_p ${_package_dir})
    unset(_package_dir CACHE)
    _recurse_requirements(${_r})
    set(_package_dir ${_p} CACHE STRING INTERNAL)
  endif()


  # find include directories
  find_path(_include_dir
    NAMES include/${package}
    HINTS ${_package_dir}
  )
  if (_include_dir)
    set(Bob_INCLUDE_DIRS ${Bob_INCLUDE_DIRS} ${_include_dir}/include CACHE STRING "The list of Bob include directories" FORCE)
  endif()

  # find external dependencies
  _get_external_includes(${package})
  if (_external_includes)
    set(Bob_INCLUDE_DIRS ${Bob_INCLUDE_DIRS} ${_external_includes} CACHE STRING "The list of Bob include directories" FORCE)
  endif()
  # find macros
  _get_external_macros(${package})
  if (_external_macros)
    set(Bob_DEFINITIONS ${Bob_DEFINITIONS} ${_external_macros} CACHE STRING "The list of Bob definitions" FORCE)
  endif()

  # find library
  find_library(_library
    NAMES ${PACKAGE_LIB}
    HINTS ${_package_dir}
  )
  if (_library)
    set(Bob_LIBRARY_DIRS ${Bob_LIBRARY_DIRS} ${_package_dir} CACHE STRING "The list of Bob library directories" FORCE)
    set(Bob_LIBRARIES ${Bob_LIBRARIES} ${PACKAGE_LIB} CACHE STRING "The list of Bob libraries" FORCE)
  endif()

  # clean up so that the next package is acually searched and not skipped
  unset(_package_dir CACHE)
  unset(_include_dir CACHE)
  unset(_library CACHE)
endfunction()


# HERE the main FIND_BOB starts

# get the list of components
if (NOT Bob_FIND_COMPONENTS)
  message(FATAL_ERROR "Please specify the bob packages that you want to search for as COMPONENTS")
endif()

# set Bob source directory, if not given yet (i.e., no FORCE option here)
if (NOT BOB_SOURCE_DIR)
  set(BOB_SOURCE_DIR ${CMAKE_SOURCE_DIR} CACHE STRING "Source directory of Bob packages")
endif()

# set BOB_PREFIX_PATH as CMake variable when given in as environment variable
if (NOT "$ENV{BOB_PREFIX_PATH}" STREQUAL "")
  if (BOB_PREFIX_PATH)
    if (NOT "${BOB_PREFIX_PATH}" STREQUAL "$ENV{BOB_PREFIX_PATH}")
      message(WARNING "Ignoring the BOB_PREFIX_PATH environment variable '$ENV{BOB_PREFIX_PATH}' and using '${BOB_PREFIX_PATH}' instead")
    endif()
  else()
    set(BOB_PREFIX_PATH $ENV{BOB_PREFIX_PATH} CACHE STRING "Bob installation prefix path" FORCE)
  endif()
endif()


# iterate over all COMPONENTS and add the packages
foreach (package IN LISTS Bob_FIND_COMPONENTS)
  find_bob_package(${package})
endforeach()

# Some debug output; can be disabled if you are annoyed.
message(STATUS "Found Bob include directories '${Bob_INCLUDE_DIRS}'")
message(STATUS "Found Bob library directories '${Bob_LIBRARY_DIRS}'")
message(STATUS "Found Bob libraries '${Bob_LIBRARIES}'")
message(STATUS "Found Bob definitions '${Bob_DEFINITIONS}'")
