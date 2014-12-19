Running Chaste on DICE
======================

Clone this git repository to

	git clone https://github.com/edinburgh-rbm/chaste-dice.git /disk/data/chaste

(or alternatively move this directory there)

and change into it

	cd /disk/data/chaste

Set up the environment:

	. ./chaste.env

Then start building stuff:

	make -f Chaste.mk

Wait a long time.

Eventually a screen will appear that asks questions. Press 'c' twice and
then 'g'.

Wait some more.

The tests should pass eventually...

If you want to install this somewhere else, it's a question of search and 
replace /disk/data/chaste in the three (other) files in this directory:
Chaste.mk, local.py and chaste.env

To use the installation later or in another session, set up the environment
again,

	. ./chaste.env

or else copy the contents of that file into your .profile or .bashrc to
have it always happen when you log in.
