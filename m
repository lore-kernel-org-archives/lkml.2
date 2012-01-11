Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2AKH2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:28:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38658 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2AKH2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:28:08 -0500
Date: Tue, 10 Jan 2012 23:28:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.3-rc0 (part 2)
Message-ID: <20120111072802.GA19831@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive more updates for the input subsystem. This pull corrects
problem of overzealous conversion to module_platform_driver() introduced
in previous pull (called out by Geert), a couple of fixups to serio_raw
driver and a small change to bcm5974 driver.

Thanks!

Changelog:
---------

Che-Liang Chiou (1):
      Input: serio_raw - remove stray semicolon

Dmitry Torokhov (3):
      Input: revert some over-zealous conversions to module_platform_driver=
()
      Input: serio_raw - really signal HUP upon disconnect
      Input: serio_raw - return proper result when serio_raw_write fails

Jussi Pakkanen (1):
      Input: bcm5974 - set BUTTONPAD property


Diffstat:
--------

 drivers/input/keyboard/amikbd.c             |   15 ++++++++++++++-
 drivers/input/keyboard/davinci_keyscan.c    |   13 ++++++++++++-
 drivers/input/keyboard/nomadik-ske-keypad.c |   13 ++++++++++++-
 drivers/input/misc/twl4030-pwrbutton.c      |   15 +++++++++++++--
 drivers/input/mouse/amimouse.c              |   16 ++++++++++++++--
 drivers/input/mouse/bcm5974.c               |    3 +++
 drivers/input/serio/at32psif.c              |   14 +++++++++++++-
 drivers/input/serio/serio_raw.c             |    8 ++++----
 drivers/input/touchscreen/atmel-wm97xx.c    |   13 ++++++++++++-
 drivers/input/touchscreen/mc13783_ts.c      |   13 ++++++++++++-
 10 files changed, 109 insertions(+), 14 deletions(-)

--=20
Dmitry


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPDToCAAoJEH70+W8r6ZYqtdgP/1EmmZPcIio0sM5UyY0ovnI9
DVDwb8isaxXn/MA7Tt6TNbpbF61qNglmjb1+duWIUaiTtZeve2n4cD1A3cGDj8bW
XArbaNs1ZLLDuV3mfnGcw8lXBZl/3Ohtp6B0dctIulCN1z87i8R5mFiHlxO2QyK8
6QHfVE5lzRbfAJSLyfnYzAE/tNWZCiigrggQOhkY4QchivmXz0M/zYDcec9WdWDO
vyRZMLf6eo3J7XH+pKS10PVFju8e88F5LrpW2CI7KM3EHEUPWuDriPg8ggOtBdRF
XwWmPxsvcjmxqSSAYs9fDtBvvK9hhbGgvNRdwEZNbhLiJUOxL/BB4OCq2vCQ19ds
XsXerw6G274qi/bUft88Mnrgm/IyCy6svGB/wrfHvZiF3WAlFOoxbf1PR4Ts+kr4
ApDNWPWFB4L9yGIEmU9eqR6BiQOxd/2qIVfHeicjT+uzHFAxP201c6XANLfVg8EA
2FYg4Yn9eQvLZ6LPogPyZJ+c1ZjQ+2ZwxRk3u4M32jKwjJBLmDPogpSqx6ilIr69
0BLRlBz6fWxpy7Z+mLVYxXpFklUoNUdkvcZRfNYS/uv09Vdak08l4imok/EipUYy
nyYWJTmwlqpEqTTQ81k86XLqpeXoldaQaqH+H40exFB2sF+AQpzx1zJYDW9BOhRP
mYmSWKO9s8j+jY1F0oWW
=Yhr6
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
