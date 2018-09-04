if ( NOT TARGET CinderFlex )
	get_filename_component( CINDER_FLEX_PATH
		"${CMAKE_CURRENT_LIST_DIR}/../../src" ABSOLUTE )
	get_filename_component( CINDER_PATH
		"${CMAKE_CURRENT_LIST_DIR}/../../../.." ABSOLUTE )

	# TODO: set these according to FleX and CUDA installation
	get_filename_component( FLEX_PATH
		"${CMAKE_CURRENT_LIST_DIR}/../../../../../FleX/" ABSOLUTE )
	get_filename_component( CUDA_INCLUDE_PATH
		"/usr/include/cuda" ABSOLUTE )
	get_filename_component( CUDA_LIB_PATH
		"/usr/lib64" ABSOLUTE )

	list( APPEND CINDER_FLEX_SOURCES
		${CINDER_FLEX_PATH}/CinderFlex.cpp
	)

	add_library( CinderFlex ${CINDER_FLEX_SOURCES} )

	target_include_directories( CinderFlex PUBLIC
		${FLEX_PATH}/include
		${CUDA_INCLUDE_PATH}
		${CINDER_FLEX_PATH} )
	target_include_directories( CinderFlex PRIVATE BEFORE "${CINDER_PATH}/include" )

	if( NOT TARGET cinder )
		include( "${CINDER_PATH}/proj/cmake/configure.cmake" )
		find_package( cinder REQUIRED PATHS
			"${CINDER_PATH}/${CINDER_LIB_DIRECTORY}"
			"$ENV{CINDER_PATH}/${CINDER_LIB_DIRECTORY}" )
	endif()

	target_link_libraries( CinderFlex PRIVATE cinder
		#PUBLIC ${FLEX_PATH}/lib/linux64/NvFlexDeviceRelease_x64.a
		PUBLIC ${FLEX_PATH}/lib/linux64/NvFlexReleaseCUDA_x64.a
		PUBLIC ${FLEX_PATH}/lib/linux64/NvFlexExtReleaseCUDA_x64.a

		#PUBLIC ${FLEX_PATH}/lib/linux64/NvFlexDeviceDebug_x64.a
		#PUBLIC ${FLEX_PATH}/lib/linux64/NvFlexDebugCUDA_x64.a
		#PUBLIC ${FLEX_PATH}/lib/linux64/NvFlexExtDebugCUDA_x64.a

		PUBLIC ${CUDA_LIB_PATH}/libcudart_static.a
		PUBLIC rt
	)
endif()
