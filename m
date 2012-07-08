Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2GHXTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:19:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60329 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab2GHXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:19:45 -0400
Message-ID: <1341789582.25597.245.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH linux-firmware 1/2] WHENCE: Move informational text from
 File to Info fields
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 09 Jul 2012 00:19:42 +0100
In-Reply-To: <1341789536.25597.244.camel@deadeye.wl.decadent.org.uk>
References: <1341789536.25597.244.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JeyghC9yPUp93rMh2qpG"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JeyghC9yPUp93rMh2qpG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/WHENCE b/WHENCE
index fb6030c..6a3665a 100644
--- a/WHENCE
+++ b/WHENCE
@@ -413,12 +413,18 @@ Found in hex form in kernel source.
=20
 Driver: qla2xxx - QLogic QLA2XXX Fibre Channel
=20
-File: ql2100_fw.bin -- 1.19.38 TP
-File: ql2200_fw.bin -- 2.02.08 TP
-File: ql2300_fw.bin -- 3.03.28 IPX
-File: ql2322_fw.bin -- 3.03.28 IPX
-File: ql2400_fw.bin -- 5.06.05 MID=20
-File: ql2500_fw.bin -- 5.06.05 MIDQ
+File: ql2100_fw.bin
+Version: 1.19.38 TP
+File: ql2200_fw.bin
+Version: 2.02.08 TP
+File: ql2300_fw.bin
+Version: 3.03.28 IPX
+File: ql2322_fw.bin
+Version: 3.03.28 IPX
+File: ql2400_fw.bin
+Version: 5.06.05 MID
+File: ql2500_fw.bin
+Version: 5.06.05 MIDQ
=20
 Licence: Redistributable. See LICENCE.qla2xxx for details
=20
@@ -428,8 +434,10 @@ Available from ftp://ftp.qlogic.com/outgoing/linux/fir=
mware/
=20
 Driver: orinoco - Agere/Prism/Symbol Orinoco support
=20
-File: agere_sta_fw.bin -- 9.48 Hermes I
-File: agere_ap_fw.bin  -- 9.48 Hermes I
+File: agere_sta_fw.bin
+Version: 9.48 Hermes I
+File: agere_ap_fw.bin
+Version: 9.48 Hermes I
=20
 Licence: Redistributable. See LICENCE.agere for details
=20
@@ -1731,7 +1739,8 @@ Licence:
=20
 Driver: r8712u - Realtek 802.11n WLAN driver for RTL8712U
=20
-File: rtlwifi/rtl8712u.bin - upgraded to the version found in the Vendor's=
 V2.6.6
+File: rtlwifi/rtl8712u.bin
+Info: version found in the Vendor's V2.6.6
=20
 Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
=20
--=20
1.7.10.4




--=-JeyghC9yPUp93rMh2qpG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/oVjue/yOyVhhEJAQp0LBAAusuDWaMxbowI8kiyb6VgwDZt0NXINesW
65wJn72gZTU74d8kUeaXCY9rFw1Vdku4v0FkapSKbFqyYF0yXx2Xza1AaA4vtl6i
UsFkirNUg7kWMh/XTXSYUOqF4IHrLUz7yw0pPAsNMbMI2oQMAAXJFEr3e5VvTefx
RPoeYLwoE9DQtLH3duuglZX4zRKA8Faqr5sgzl4jJ8orK5CTgnvFgXllje6uMB/M
QthfLgnks2HPZDetMgWJOL7v/HnkshYXt+jto/UbyyOlhJi2jE0btIKVVlhdM/Zw
WfIH7/R96d/waXgCBNVWejqQJe2Mdj7pKHiXUbrcRL2tqs3f0DUF/YZ1kFNiuOgd
FIbxeg4J0ZtD9d2YHtbKYFFKWcJ9A09Sb3BEIMqkb+pT+FihKC3TzxLJq+5ecFqx
hwftV+Z4c4nBkCtg1pizL2Yh0hZGGa+o7PNGUhtSt8luMqscpauZ3aPMd/+MfwID
2Vv9MM1wbKe0fa25LX+JfkgC28eMkGpliRm84YCgozBgtRjtCa66rPUdTuRM5Jwk
xy1l/bVYkcmhH7BB78h6eyMPczQjKqBE4NN4jgU/gfHwlYIiqz3ddw3+7X2XBQbW
bzwJooJE3BgmY4VAxWN+37eE6r0q6FxjjWZVvoDWj9jRuuxggc1XlbAuyKc/8r2j
M1Hxa3L8iwM=
=ak2T
-----END PGP SIGNATURE-----

--=-JeyghC9yPUp93rMh2qpG--
