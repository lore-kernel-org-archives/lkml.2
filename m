Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0JLAmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:42:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60458 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301Ab0JLAmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:42:32 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Harald Welte <HaraldWelte@viatech.com>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ykmt4FwlLRh/JlTgEQEc"
Date: Tue, 12 Oct 2010 01:42:18 +0100
Message-ID: <1286844138.2955.320.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [GIT PULL linux-firmware.git] VT6656 firmware
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ykmt4FwlLRh/JlTgEQEc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit e9f9e3a9b7d780e93ae869c1b8502c843bfd93a4=
:

  wimax: update WiMAX firmwares for 2.6.35 (2010-09-29 12:02:34 +0900)

are available in the git repository at:
  http://git.decadent.org.uk/git/linux-firmware.git master

Ben Hutchings (1):
      Add firmware for VIA VT6656

 LICENCE.via_vt6656 |   25 +++++++++++++++++++++++++
 WHENCE             |    8 ++++++++
 vntwusb.fw         |  Bin 0 -> 11341 bytes
 3 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 LICENCE.via_vt6656
 create mode 100644 vntwusb.fw

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-ykmt4FwlLRh/JlTgEQEc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATLOu5Oe/yOyVhhEJAQILlQ//TihL3TsIBD1HJbB9nIbo75BG+MLZMklb
5PHNHrkRKYv9jX6fUW7Xe8/VujRGi0efQroTSzGH4zwAAek6xcS468pMpN//26ji
LKlszZJyf0m+ozs+P1WUiL98XA8UaJMHw0R99+4hi8E3/Ur50+A1TXrtwGefptXE
ZHSKAi+KhTRHQMGSV9SmtSedylB2/y5Ob6aHX8FvqpIVWaBfyVyWsDtZ4u4Qj/IB
FJds4Jh8v1/hFJXU7UepEbqSXzBQKyUAobvLSnbwcUWznC5KGrYaib6igBxYUKU3
RpE4w/CE+qpLKZaj/kNh90Fg2fWAhDhgZ2EArj+YF5k1hIcgoQY5fPV9EZWm5MZd
PObELs6gEaJEtO/uE+j/9zrZJR41PuavKGJs/vYz65W0YDKpBufQ5CYu5LNVfiMG
x322Hl4YLcrlgcfL40tnQW6WILG7yxTu5YB4hwbf5fLpsVmoZJBtr+vhEZbr77Fj
mes5q4v33ZaDrsoQQOek6so5SqUlaGWRApo6edGEmjFInmYIrpGC1mCpAHYZL03W
nXJ/C6ginxda5uZPlchiHO73tJJU+8n3rt5DFvl3c81C/9SG+BEuPBYJhe5AkCDk
lDat1Tsq6v2xNlmK7zBD6Xb6q75aAfNo/IXbozVkB6Mwi6kIQCJ/xNLiqCcYW6Tg
TiiMcElQCaQ=
=XhGu
-----END PGP SIGNATURE-----

--=-ykmt4FwlLRh/JlTgEQEc--
