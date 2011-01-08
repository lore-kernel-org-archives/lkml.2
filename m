Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1AHW4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:56:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45479 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab1AHW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:56:17 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eYQ6ZeixDcSrHTE7jLcl"
Date: Sat, 08 Jan 2011 22:56:12 +0000
Message-ID: <1294527372.3283.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 0/2] firmware: Administrative fixes
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eYQ6ZeixDcSrHTE7jLcl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'll send a pull-request shortly if no-one objects to the changes.

Ben.

Ben Hutchings (2):
  brcm80211: Remove version number from filenames, matching the driver
  Add source and copyright notice for CIS files from pcmcia-cs

 WHENCE                          |   30 +++++++++++++++++++++-----
 brcm/bcm43xx-0-610-809-0.fw     |  Bin 97376 -> 0 bytes
 brcm/bcm43xx-0.fw               |  Bin 0 -> 97376 bytes
 brcm/bcm43xx_hdr-0-610-809-0.fw |  Bin 180 -> 0 bytes
 brcm/bcm43xx_hdr-0.fw           |  Bin 0 -> 180 bytes
 cis/src/3CCFEM556.cis           |   22 +++++++++++++++++++
 cis/src/3CXEM556.cis            |   22 +++++++++++++++++++
 cis/src/COMpad2.cis             |   20 +++++++++++++++++
 cis/src/COMpad4.cis             |   14 ++++++++++++
 cis/src/DP83903.cis             |   24 +++++++++++++++++++++
 cis/src/LA-PCM.cis              |   44 +++++++++++++++++++++++++++++++++++=
++++
 cis/src/MT5634ZLX.cis           |   18 ++++++++++++++++
 cis/src/NE2K.cis                |   10 ++++++++
 cis/src/PCMLM28.cis             |   37 ++++++++++++++++++++++++++++++++
 cis/src/PE-200.cis              |   11 +++++++++
 cis/src/PE520.cis               |   11 +++++++++
 cis/src/RS-COM-2P.cis           |   14 ++++++++++++
 cis/src/tamarack.cis            |   17 +++++++++++++++
 18 files changed, 288 insertions(+), 6 deletions(-)
 delete mode 100644 brcm/bcm43xx-0-610-809-0.fw
 create mode 100644 brcm/bcm43xx-0.fw
 delete mode 100644 brcm/bcm43xx_hdr-0-610-809-0.fw
 create mode 100644 brcm/bcm43xx_hdr-0.fw
 create mode 100644 cis/src/3CCFEM556.cis
 create mode 100644 cis/src/3CXEM556.cis
 create mode 100644 cis/src/COMpad2.cis
 create mode 100644 cis/src/COMpad4.cis
 create mode 100644 cis/src/DP83903.cis
 create mode 100644 cis/src/LA-PCM.cis
 create mode 100644 cis/src/MT5634ZLX.cis
 create mode 100644 cis/src/NE2K.cis
 create mode 100644 cis/src/PCMLM28.cis
 create mode 100644 cis/src/PE-200.cis
 create mode 100644 cis/src/PE520.cis
 create mode 100644 cis/src/RS-COM-2P.cis
 create mode 100644 cis/src/tamarack.cis

--=20
1.7.2.3



--=-eYQ6ZeixDcSrHTE7jLcl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATSjrfee/yOyVhhEJAQKaYg//cvNMy8sy7K3LUIJowwWUjlVsi17g5Ge9
Wvh65JeJF2SSQAsW1g7pBl5Up2L7kfacNO+vlE1IL1nuZIkIQdokzEO2Us/t9qHo
s7ToGNtlyixTuFkNfWV/hhhOOjSXWb7jFxY6gsrDNhv+wcg1uDDaX9ARnW8XiDBj
/GdyJAfQEVKrbQaasQiSS5y7uvr2cTtsvSLOhBbjx4nC5Tx3TN42du2qbPVZJ8hQ
SchCpKWPUab1ACCPOI44yagZN3JMw5Mu9Agdrm1HDpCLFpbjb6TLA9obKiI7KojE
ZLS0SolHlXtBuuJN2fIlayH76mjIdv7ZYz/Bm+eJirIddNMMjWx+sfZBZgoKyYYc
ITsNMRfxgByiU11e4sJmBruMgLjRn+OcZkmn1KktQZZsapC1jdRFpzjrjdur/evb
pUfeULJeHWJlhp84Y0UjnZRo8ZUmI4tKOY64pTwfEJd4tvD0KVdtpruRRscX3d0q
jFEEYN1cHSfYAvO+r6LWgze0ujQyBbCFESp+8DUGV7pfyDWJwHJjJTlcLTERBVeU
RRl4jUTCRuWYanb7EEhrKFbzQ3FyPAIF4zJSfsc2Xdc+eQ64KX3XyGo89qH2sqeh
JwE1M/DLsPQ/7K0/+9aXfktz8MzhnIAdpYum03o1LvkfHnRQmc1892eLd/8pEido
EXxETNOwgqY=
=nkXm
-----END PGP SIGNATURE-----

--=-eYQ6ZeixDcSrHTE7jLcl--
