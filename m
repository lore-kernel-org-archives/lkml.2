Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2JLUAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:00:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42428 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2JLUAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:00:13 -0400
Date: Fri, 12 Oct 2012 13:00:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.7-rc0
Message-ID: <20121012200007.GA31768@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. With it input
core no longer limits number of character devices per event handler
(such as evdev) to 32, but switches to dynamic minors once legacy range
is exhausted. This should get multi-seat installations that currently
run our of event devices very quickly.

You will also get an update for Wacom driver and a couple of driver fixes.

Thanks!

Changelog:
---------

Andy Shevchenko (1):
      Input: atmel_mxt_ts - simplify mxt_dump_message

Dmitry Torokhov (5):
      Input: mousedev - factor out psaux code to reduce #ifdefery
      Input: mousedev - reformat structure initializers
      Input: mousedev - rename mixdev_open to opened_by_mixdev
      Input: mousedev - mark mousedev interfaces as non-seekable
      Input: extend the number of event (and other) devices

Jason Gerecke (4):
      Input: wacom - report correct touch contact size for I5/Bamboo
      Input: wacom - allow any multi-input Intuos device to set prox
      Input: wacom - introduce wacom_fix_phy_from_hid
      Input: wacom - clean up wacom_query_tablet_data

Thomas Abraham (1):
      Input: samsung-keypad - add clk_prepare and clk_unprepare


Diffstat:
--------

 drivers/input/evdev.c                    |  99 +++++---------
 drivers/input/input.c                    | 114 ++++++++--------
 drivers/input/joydev.c                   |  88 +++++-------
 drivers/input/keyboard/samsung-keypad.c  |  11 +-
 drivers/input/mousedev.c                 | 224 ++++++++++++++++-----------=
----
 drivers/input/tablet/wacom_sys.c         | 145 ++++++++++++++------
 drivers/input/tablet/wacom_wac.c         |  30 ++++-
 drivers/input/touchscreen/atmel_mxt_ts.c |   6 +-
 include/linux/input.h                    |  10 +-
 9 files changed, 382 insertions(+), 345 deletions(-)

--=20
Dmitry


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQeHbHAAoJEH70+W8r6ZYqNj4QAJb2xTCJCuAPeaa5y4oZUyc8
H813NVuit990B3NUYXatCEBTf2dd0VyZoOrYyEm77nKipdmz35rR6klXvgyxd5Xs
Xky9/Z5UxKiFrOhl3E/cyfgqgxXb+sljoT0YqiQmqJdmUE54TqOLybVrA/EmKFOt
cb12FmRf84wtkX4f2cLJb2lHrn2Xaq4RQo04jCzKfUeOEFuS+NGRy3AIFpa1xe+R
FaKdoEKL2jwkqwicEI77hsnq6Jdj+/jIqqGDY27LhSkM0KksdXbqJ24UW7EF7MNw
/YoTnSg4wo+Ty1maNPvbrECV/bV0STOJy9CWWozbrZvvF+mmHrUYunPjDYBUTD+E
k4DHL7F5IiIP7V59Szq1a3nMIfY0CPfhBF5HQH49rVArd8VUvnQgnkElFSlpG8jr
34vX3hT+XJvwXPBH2c5osdm6qySZI9pHEhdE9XNyNxjpYjVb0Q96AG3vPMICmJKb
qsMwBtXS/HXpDjgNq64qqdEnywSZH9E6UTUtsuDNV9QYIMpNJ+T7DqSwcJhvDSfy
6bJJNer/cadYiIgUIgomRPCiTwrSkVXYttM3PwEg9e3c5Ftvw6lYb/JSbQ6oZrah
/LRsYQ36yxZwvt427xxMcVnK57UpQHDeCXzUa0LHmSTdRYHfDFjXSPFB7Eq3kybS
vHdRYlSkf95oPuHEwMyc
=uS3d
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
