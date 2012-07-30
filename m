Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2G3Fkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 01:40:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2G3Fkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 01:40:51 -0400
Date: Sun, 29 Jul 2012 22:40:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.6-rc0 (2nd set)
Message-ID: <20120730054047.GA18037@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd set of updates for the input subsystem for the 3.6 merge
window. You will get a new driver for FT5x06 based EDT displays and a
couple of other driver changes.

Changelog:
---------

Ping Cheng (1):
      Input: wacom - add support to Cintiq 22HD

Seth Forshee (1):
      Input: synaptics - handle out of bounds values from the hardware

Simon Budig (1):
      Input: add driver for FT5x06 based EDT displays


Diffstat:
--------

 Documentation/input/edt-ft5x06.txt     |   54 ++
 drivers/input/mouse/synaptics.c        |   22 +
 drivers/input/tablet/wacom_wac.c       |   21 +-
 drivers/input/tablet/wacom_wac.h       |    3 +-
 drivers/input/touchscreen/Kconfig      |   13 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/edt-ft5x06.c |  898 ++++++++++++++++++++++++++++=
++++
 include/linux/input/edt-ft5x06.h       |   24 +
 8 files changed, 1033 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/input/edt-ft5x06.txt
 create mode 100644 drivers/input/touchscreen/edt-ft5x06.c
 create mode 100644 include/linux/input/edt-ft5x06.h

--=20
Dmitry


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQFh5fAAoJEH70+W8r6ZYqoNoP/jK1OIKujhNSgyHuxZ9AD9YB
hLIVD8Y++FQ61SJPKppbholOrm+XSApse6kLAlfIDKWCfrMUYmTGlth8obNM1ZRB
en2r5awlEBKhiVQPlFSOGJKL6b9qcmIFOkg56zkeRwIIoSVh0IMDK/PrfiAhukd3
vFHlB4rAf4/dZB59L1luXVR+yfV9ocB6pkgDk0L41jZk4C3CdSLo1axSy+QbHzmy
7oytYsLUtYOM6haUXbwftznh3gPOb4Gxcl+tXiDB5SjgQdw1VD7hNlFfTQm+fVCn
HK9R5+4YWPNev2nsHQCl/v30tmSTUikqXUxd4kb2oOrXXFqHazDERFlYBH1HlzuM
1b774jcE73i7NcmiKEWdt/kZ0w+yUNq4F92SK1BjQ4oCcT2XU0us6CqZ+exSdEJ9
YAk5ef7GhSc17B4aIEhIH6CVOO846WmRmWa9vWvyfyhhkRjn3daBeKHWVlOIIvIx
sMEhta9+twY2pmYS55Mc1zgRbd3Y6Cl4v6WPqdqGfkLTrnL7PsMWUWutuduNtPBr
pJu3q1m35Yz0qbHZVp8rmFSvf/mJ3J83MVrgKvKhtgdvnMeTmg623lVdShA3WzMl
koHaXHOzpLvM9fTefUzCOCYhVMpgQRaKb/WEz1CMYCnaIJq9j5TiCSJ4/+sCodP5
u906nSMcc27ozmwHuNpb
=wfjT
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
