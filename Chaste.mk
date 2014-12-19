CHASTE?=/disk/data/chaste

chaste: .chaste_done
.chaste_done: scons boost petsc xsd xerces vtk pycml
	wget -O chaste_release_3_2.tgz 'https://chaste.cs.ox.ac.uk/chaste/Inc/download.php?file=current/chaste_release_3_2.tgz'
	gzip -dc chaste_release_3_2.tgz | tar -xvf -
	cp local.py release_3.2/python/hostconfig
	cd release_3.2; scons

scons: .scons_done
.scons_done:
	wget http://prdownloads.sourceforge.net/scons/scons-2.3.1.tar.gz
	gzip -dc scons-2.3.1.tar.gz | tar -xvf -
	cd scons-2.3.1; python setup.py install --prefix=${CHASTE}
	rm -rf scons-2.3.1.tar.gz scons-2.3.1
	touch .scons_done

boost: .boost_done
.boost_done:
	wget http://downloads.sourceforge.net/project/boost/boost/1.54.0/boost_1_54_0.tar.gz
	gzip -dc boost_1_54_0.tar.gz | tar -xvf -
	cd boost_1_54_0; \
	./bootstrap.sh --prefix=${CHASTE} --with-libraries=system,filesystem,serialization; \
	./b2 install
	rm -rf boost_1_54_0.tar.gz boost_1_54_0
	touch .boost_done

petsc: .petsc_done
.petsc_done:
	wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.4.4.tar.gz
	zip -dc petsc-lite-3.4.4.tar.gz | tar -xvf -
	cd petsc-3.4.4; \
		export PETSC_DIR=`pwd`; \
		export PETSC_ARCH=linux-gnu; \
		./config/configure.py --download-openmpi --download-hypre --download-sundials --download-hdf5 --download-parmetis --download-metis --with-x=false --with-clanguage=cxx --with-shared-libraries --with-gnu-compilers; \
		./config/builder.py
	cd petsc-3.4.4; \
		export PETSC_DIR=`pwd`; \
		export PETSC_ARCH=linux-gnu-opt; \
		./config/configure.py --download-openmpi --download-hypre --download-sundials --download-hdf5 --download-parmetis --download-metis --with-x=false --with-clanguage=cxx --with-shared-libraries --with-gnu-compilers --with-debugging=0; \
		./config/builder.py
	rm -f petsc-lite-3.4.4.tar.gz
	touch .petsc_done

virtualenv: .virtualenv_done
.virtualenv_done:
	virtualenv --system-site-packages ${CHASTE}
	touch .virtualenv_done

pycml: virtualenv .pycml_done
.pycml_done:
	${CHASTE}/bin/pip install "python-dateutil==1.5"
	${CHASTE}/bin/easy_install "Amara==1.2.0.2"
	${CHASTE}/bin/pip install "rdflib==2.4.2"
	${CHASTE}/bin/pip install lxml
	touch .pycml_done

vtk: .vtk_done
.vtk_done:
	wget http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz
	gzip -dc vtk-5.10.1.tar.gz | tar -xvf -
	cd VTK5.10.1; ccmake -D CMAKE_INSTALL_PREFIX=${CHASTE} -D BUILD_SHARED_LIBS=ON -Wno-dev .
	cd VTK5.10.1; make
	cd VTK5.10.1; make install
	rm -f vtk-5.10.1.tar.gz
	rm -rf VTK5.10.1
	touch .vtk_done

xsd: .xsd_done
.xsd_done:
	cd wget http://www.codesynthesis.com/download/xsd/3.3/linux-gnu/x86_64/xsd-3.3.0-x86_64-linux-gnu.tar.bz2
	cd bzip2 -dc xsd-3.3.0-x86_64-linux-gnu.tar.bz2 | tar -xvf -
	cd ln -s ${CHASTE}/xsd-3.3.0-x86_64-linux-gnu/bin/xsd ${CHASTE}/bin/xsd
	rm -f xsd-3.3.0-x86_64-linux-gnu.tar.bz2
	touch .xsd_done

xerces: .xerces_done
.xerces_done:
	wget http://www.eu.apache.org/dist/xerces/c/3/sources/xerces-c-3.1.1.tar.gz
	tar -zxf xerces-c-3.1.1.tar.gz
	cd xerces-c-3.1.1; \
	export XERCESCROOT=`pwd`; \
		./configure --prefix=${CHASTE}; \
		make; \
		make install
	rm -rf xerces-c-3.1.1 xerces-c-3.1.1.tar.gz
	touch .xerces_done
