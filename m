Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2GHXTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:19:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60324 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab2GHXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:19:04 -0400
Message-ID: <1341789536.25597.244.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH linux-firmware 0/2] Clean up some metadata in WHENCE
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 09 Jul 2012 00:18:56 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VDPinnl78XLKvgxl2KeU"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VDPinnl78XLKvgxl2KeU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've committed the following changes.

Ben.

Ben Hutchings (2):
  WHENCE: Move informational text from File to Info fields
  WHENCE: Move version strings from Info to Version fields

 WHENCE |  104 +++++++++++++++++++++++++++++++++++++-----------------------=
----
 1 file changed, 60 insertions(+), 44 deletions(-)

--=20
1.7.10.4



--=-VDPinnl78XLKvgxl2KeU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/oVYOe/yOyVhhEJAQrdpw//VFGQlR+aljFrHkXgyZjbpIuvNf4aSx8s
CkJcQRb5+H1WyGUmvycvgPxFb126u7LkjhDA248HnDps+aFuXW1TeB1spzzVcFpU
FejxfxRTvLRzyqQMaorbWFEtY1hMBUDq9vitaRTQov8uApDeYW1pyQelNoseNEsI
MVLzkIBCnp93w4/SdQzhWkwQo5gy+GUPjMGwivOqg98+kuJkyIsWJi4w++aSAKzP
HWz/NfMgc0e7ms7owQU4Di9RFC6J94Ac8EverlmEs8sO2cPEIQtk1PCaLxLlUsW1
PJ3gcCmobBUQmowTSxxjER0ofmR9a+hwOrooYP/Q4td+ddenKRmVMtrieW/63L2K
dCsLLdwodM8+27/nmRL6gQXFwB+CPKXZWpjsASgceA65OJhEdR6Ln8DH7ZI8vZGH
zcv6CXPPk/fev8hs4zbbX96k4Zyy4erm6SDinroprx01RQXjsEc0yzZTfqI+gBLR
DBJN4xqQKt4xsOdcgQ021P56SRn3Hze4wbdPlt4dKPPBVbRuI+yS5GL32F8Zc+JD
Dl99B5bTroqj7YKRxF1iFaIt7XU/ZVflLvmis4r9zmrMnRUcHCxqejZVrlF7cEyj
rVHV/i/6YL9Da5nmM96jDhfF4JyhZUHlLsjEg/64VFBGyQz8uAb09vaOht++0zDk
O1HGFl0B/U4=
=PHv6
-----END PGP SIGNATURE-----

--=-VDPinnl78XLKvgxl2KeU--
