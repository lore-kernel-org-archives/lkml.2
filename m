Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1AHW5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:57:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45485 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab1AHW5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:57:45 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Henry Ptasinski <henryp@broadcom.com>
In-Reply-To: <1294527372.3283.43.camel@localhost>
References: <1294527372.3283.43.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GEuQL16H+TEiRGld5nl5"
Date: Sat, 08 Jan 2011 22:57:41 +0000
Message-ID: <1294527461.3283.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/2] brcm80211: Remove version number from filenames,
 matching the driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GEuQL16H+TEiRGld5nl5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The driver generates filenames like this:

                sprintf(fw_name, "%s-%d.fw", wl_firmwares[i],
                        UCODE_LOADER_API_VER);
                ...
                sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
                        UCODE_LOADER_API_VER);

which implies the filenames should be:

    brcm/bcm43xx-0.fw
    brcm/bcm43xx_hdr-0.fw

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE                          |    5 +++--
 brcm/bcm43xx-0-610-809-0.fw     |  Bin 97376 -> 0 bytes
 brcm/bcm43xx-0.fw               |  Bin 0 -> 97376 bytes
 brcm/bcm43xx_hdr-0-610-809-0.fw |  Bin 180 -> 0 bytes
 brcm/bcm43xx_hdr-0.fw           |  Bin 0 -> 180 bytes
 5 files changed, 3 insertions(+), 2 deletions(-)
 delete mode 100644 brcm/bcm43xx-0-610-809-0.fw
 create mode 100644 brcm/bcm43xx-0.fw
 delete mode 100644 brcm/bcm43xx_hdr-0-610-809-0.fw
 create mode 100644 brcm/bcm43xx_hdr-0.fw

diff --git a/WHENCE b/WHENCE
index 0bc162c..cec7478 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1403,8 +1403,9 @@ Licence:
=20
 Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
=20
-File: brcm/bcm43xx-0-610-809-0.fw
-File: brcm/bcm43xx_hdr-0-610-809-0.fw
+File: brcm/bcm43xx-0.fw
+File: brcm/bcm43xx_hdr-0.fw
+Version: 610.809.0
=20
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
=20
[binary changes omitted]


--=-GEuQL16H+TEiRGld5nl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATSjr4ue/yOyVhhEJAQIxBRAAuzSkeqc+QV4ixwlmx5njvyN/vdSLz97Q
UyVtEf6SrrHry8U4lOBA1sg0NQiQ47nVEMdbtomUp772NmD0GzIkmCSadjR7F9uh
CX1auXz+mtIPxMW7HaFDL7ylapPBGmT5xwhXymIHwp8blisvqNGO3D+ZuYv2hLLE
Q9EQtOri+R0plWJNxJK2sSeds+jotl4KBymPiZ65Q0sOnc7ZHy2MLyue6PjyQO+y
XMqeYZzPamC347tADCkpwCrS+Ss/iw/k2uyCJM1e6chxGyPzCy4TgCLtPq87RdgV
onlzYzTGWQpR9RONhed0xP1VuYoJ9xFBwrDqV4K/EYGCJJen0ZHNToF9HirHfJ/2
BD0tWcXo7emAIfQyowJYQuPyZb/FusN9CsWa1rILkfHCE+i3SGfNqrnSyTFSEbpA
LZKaOMEgths3UWjLs0S8zLX+164sw9Olfoi4QBPRuYVUAlRZLKMU5WWA83+wCLdO
EICQO308m/j3W42h+MXax1VYQ8VSehopMuU6SKFs1Cm6MioNHofds0JkliKeGSoJ
0YguIRcZOdT1AnfL3druLO/v3DcHSk+yFsIW0g9Wb70vy78a78fC8yn1SKIGCoTX
aSL0FPPQp0Ihna7n0fQL92v0pnRomVHmpSh4jGntT858u+Hta40C1R0soV8VmdxN
GCPStEHn6ws=
=kFHE
-----END PGP SIGNATURE-----

--=-GEuQL16H+TEiRGld5nl5--
