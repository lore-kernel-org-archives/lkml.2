Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab2DLFUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:20:05 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59793 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2DLFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:19:57 -0400
Date: Wed, 11 Apr 2012 22:19:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.4-rc2
Message-ID: <20120412051952.GA1404@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a few small fixes...

Changelog:
---------

JJ Ding (3):
      Input: elantech - reset touchpad before configuring it
      Input: elantech - v4 is a clickpad, with only one button
      Input: trackpoint - use psmouse_fmt() for messages

Jesper Juhl (1):
      Input: da9052 - fix memory leak in da9052_onkey_probe()

Mark Brown (1):
      Input: gpio_mouse - use linux/gpio.h rather than asm/gpio.h

Oskari Saarenmaa (1):
      Input: sentelic - filter taps in absolute mode

Uwe Kleine-K=F6nig (1):
      Input: tps6507x-ts - fix MODULE_ALIAS to match driver name


Diffstat:
--------

 drivers/input/misc/da9052_onkey.c       |    3 ++-
 drivers/input/mouse/elantech.c          |   10 ++++++++--
 drivers/input/mouse/gpio_mouse.c        |    2 +-
 drivers/input/mouse/sentelic.c          |    8 ++++++++
 drivers/input/mouse/trackpoint.c        |   14 ++++++++------
 drivers/input/touchscreen/tps6507x-ts.c |    4 +---
 6 files changed, 28 insertions(+), 13 deletions(-)

--=20
Dmitry


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhmX4AAoJEH70+W8r6ZYqaJMP/0Oo7mchwtFA8klazLrmSdfM
NWI2Vi6bhYmNZCD0nfiL7NscO9tVXbFXzo5+7sjVsxIOs9CmopxGMJUbw+Zf3umI
xX7cDYtHXdOCvaEcVM4fS8lHcAGJnE7z887fHq96CpRgd65qjcP7AYfY0uE1yVoh
vL6HLgdme7xoE1/GRdeo3K/DrQWtauSLlEDv47osqisbyCByxys0UneFy/zVhurM
XS7E+tMW9SgTcaV4BrVRh15Ap8kpdPDWiEekbJ2sxMRw+IPeuoeLyZpfVtSIpTgr
6gQm/eAeX1ewlgDnP+g/Fqmlk4z9HK2xQt8fdu3zfS5sZbx9PvjMnGi0pP4ObaVw
Tm95+v5SihXjSiQ21Jr2kk/W1yWzaB7sJA8oPGwsZZ0+iTAxpjWeRv3GykbrPwuM
+fpF1tP+sLl+OoXDxJb9nZYa6jz7Xd6aowwfhnaj/7aa23BfWQLTYlhIB3j2QhTH
hvdAo948PCleceFsvQGb7b9ek3bTyqlKI2neATzgnEuY7xJlYrsGhogt5m0fnkxu
3YwElONO9nctBs0iaeNPA4TD0c85wusbOcx3jlDsA6GLlwYnMmgLyIB8wIPHgHJs
qIBB9vqsT3L/k5MoHLzcyuibQGNnRBl1ly3sAk/Y0jZnF2E+pF3AGjUDjSHKi7oN
Ow9hIJdN8B6bSuIOJHO6
=JyuZ
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
