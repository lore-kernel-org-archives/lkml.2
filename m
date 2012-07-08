Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2GHXUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:20:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab2GHXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:19:59 -0400
Message-ID: <1341789595.25597.246.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH linux-firmware 2/2] WHENCE: Move version strings from Info
 to Version fields
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 09 Jul 2012 00:19:55 +0100
In-Reply-To: <1341789536.25597.244.camel@deadeye.wl.decadent.org.uk>
References: <1341789536.25597.244.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xSocFvd7qp/S87zIy8AU"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xSocFvd7qp/S87zIy8AU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE |   77 +++++++++++++++++++++++++++++++++++-------------------------=
----
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/WHENCE b/WHENCE
index 6a3665a..8e0aff3 100644
--- a/WHENCE
+++ b/WHENCE
@@ -93,6 +93,7 @@ Licence: Allegedly GPLv2+, but no source visible. Marked:
 Driver: smctr -- SMC ISA/MCA Token Ring adapter
=20
 File: tr_smctr.bin
+Version: 6.3C1
 Info: MCT.BIN v6.3C1 03/01/95
=20
 Original licence info:
@@ -184,10 +185,12 @@ Compiled from original 8051 source into Intel HEX, us=
ed in our binary ihex form.
 Driver: emi26 -- EMI 2|6 USB Audio interface
=20
 File: emi26/bitstream.fw
-Info: VERSION=3D1.1.1.131 DATE=3D2001dec06
+Version: 1.1.1.131
+Info: DATE=3D2001dec06
=20
 File: emi26/firmware.fw
-Info: VERSION=3D1.0.2.916 DATE=3D12.02.2002
+Version: 1.0.2.916
+Info: DATE=3D12.02.2002
=20
 File: emi26/loader.fw
=20
@@ -218,19 +221,23 @@ Original licence information:
 Driver: emi62 -- EMI 6|2m USB Audio interface
=20
 File: emi62/bitstream.fw
-Info: VERSION=3D1.0.0.191 DATE=3D 2002oct28
+Version: 1.0.0.191
+Info: DATE=3D 2002oct28
=20
 File: emi62/loader.fw
 Source: EMILOAD.HEX
-Info: VERSION=3D1.0.2.002 DATE=3D10.01.2002
+Version: 1.0.2.002
+Info: DATE=3D10.01.2002
=20
 File: emi62/midi.fw
 Source: EMI62MFW.HEX
-Info: VERSION=3D1.04.062 DATE=3D16.10.2002
+Version: 1.04.062
+Info: DATE=3D16.10.2002
=20
 File: emi62/spdif.fw
 Source: EMI62SFW.HEX
-Info: VERSION=3D1.04.062 DATE=3D16.10.2002
+Version: 1.04.062
+Info: DATE=3D16.10.2002
=20
 Converted from Intel HEX files, used in our binary representation of ihex.
=20
@@ -674,13 +681,13 @@ Linux driver tarballs downloaded from Marvell's "Extr=
anet" with permission.
 Driver: libertas - Marvell Libertas 802.11b/g cards, OLPC firmware
=20
 File: libertas/lbtf_sdio.bin
-Info: v9.0.7.p4
+Version: 9.0.7.p4
=20
 File: lbtf_usb.bin
-Info: v5.132.3.p1
+Version: 5.132.3.p1
=20
 File: libertas/usb8388_olpc.bin
-Info: v5.110.22.p23
+Version: 5.110.22.p23
=20
 Licence: Redistributable. See LICENCE.OLPC for details.
=20
@@ -717,61 +724,61 @@ Linux driver tarballs downloaded from Marvell's "Extr=
anet" with permission.
 Driver: iwlwifi - Intel Wireless Wifi
=20
 File: iwlwifi-3945-2.ucode
-Info: v15.32.2.9
+Version: 15.32.2.9
=20
 File: iwlwifi-4965-2.ucode
-Info: v228.61.2.24
+Version: 228.61.2.24
=20
 File: iwlwifi-5000-1.ucode
-Info: v5.4.A.11 (aka v5.4.1.16)
+Version: 5.4.A.11 (aka 5.4.1.16)
=20
 File: iwlwifi-5000-2.ucode
-Info: v8.24.2.12
+Version: 8.24.2.12
=20
 File: iwlwifi-5000-5.ucode
-Info: v8.83.5.1
+Version: 8.83.5.1
=20
 File: iwlwifi-5150-2.ucode
-Info: v8.24.2.2
+Version: 8.24.2.2
=20
 File: iwlwifi-1000-3.ucode
-Info: v128.50.3.1
+Version: 128.50.3.1
=20
 File: iwlwifi-1000-5.ucode
-Info: v39.31.5.1
+Version: 39.31.5.1
=20
 File: iwlwifi-6000-4.ucode
-Info: v9.221.4.1
+Version: 9.221.4.1
=20
 File: iwlwifi-6050-4.ucode
-Info: v9.201.4.1
+Version: 9.201.4.1
=20
 File: iwlwifi-6050-5.ucode
-Info: v41.28.5.1
+Version: 41.28.5.1
=20
 File: iwlwifi-6000g2a-5.ucode
-Info: v17.168.5.3
+Version: 17.168.5.3
=20
 File: iwlwifi-6000g2b-5.ucode
-Info: v17.168.5.1
+Version: 17.168.5.1
=20
 File: iwlwifi-6000g2b-6.ucode
-Info: v18.168.6.1
+Version: 18.168.6.1
=20
 File: iwlwifi-135-6.ucode
-Info: v18.168.6.1
+Version: 18.168.6.1
=20
 File: iwlwifi-100-5.ucode
-Info: v39.31.5.1
+Version: 39.31.5.1
=20
 File: iwlwifi-105-6.ucode
-Info: v18.168.6.1
+Version: 18.168.6.1
=20
 File: iwlwifi-2030-6.ucode
-Info: v18.168.6.1
+Version: 18.168.6.1
=20
 File: iwlwifi-2000-6.ucode
-Info: v18.168.6.1
+Version: 18.168.6.1
=20
 Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
=20
@@ -1139,7 +1146,7 @@ Found in hex form in kernel source.
 Driver: netxen_nic - NetXen Multi port (1/10) Gigabit Ethernet NIC
=20
 File: phanfw.bin
-Info: v4.0.579
+Version: 4.0.579
=20
 Licence: Redistributable. See LICENCE.phanfw for details.
=20
@@ -1253,7 +1260,7 @@ Provided from the author, Bernd Porr <BerndPorr@f2s.c=
om>
 Driver: xc5000 - Xceive 5000 Tuner driver
=20
 File: dvb-fe-xc5000-1.6.114.fw
-Info: v1.6.114
+Version: 1.6.114
=20
 Licence: Redistributable. See LICENCE.xc5000 for details
=20
@@ -1262,7 +1269,7 @@ Licence: Redistributable. See LICENCE.xc5000 for deta=
ils
 Driver: dib0700 - DiBcom dib0700 USB DVB bridge driver
=20
 File: dvb-usb-dib0700-1.20.fw
-Info: v1.20
+Version: 1.20
=20
 Licence: Redistributable. See LICENCE.dib0700 for details
=20
@@ -1271,7 +1278,7 @@ Licence: Redistributable. See LICENCE.dib0700 for det=
ails
 Driver: ath3k - DFU Driver for Atheros bluetooth chipset AR3011
=20
 File: ath3k-1.fw
-Info: v1.0
+Version: 1.0
=20
 Fix EEPROM radio table issue and change PID to 3005
=20
@@ -1538,7 +1545,7 @@ Driver: ueagle-atm - Driver for USB ADSL Modems based=
 on Eagle IV Chipset
 File: ueagle-atm/CMV4p.bin.v2
 File: ueagle-atm/DSP4p.bin
 File: ueagle-atm/eagleIV.fw
-Info: v1.0
+Version: 1.0
=20
 Licence: Redistributable. See LICENCE.ueagle-atm4-firmware for details
=20
@@ -1567,7 +1574,7 @@ File: ueagle-atm/CMVei.bin
 File: ueagle-atm/CMVepFR04.bin =20
 File: ueagle-atm/DSP9i.bin	   =20
 File: ueagle-atm/eagleII.fw
-Info: v1.1
+Version: 1.1
=20
 Licence: Redistributable. Based on=20
          https://mail.gna.org/public/eagleusb-dev/2004-11/msg00172.html
@@ -1889,7 +1896,7 @@ File: myri10ge_eth_z8e.dat
 File: myri10ge_ethp_z8e.dat
 File: myri10ge_rss_eth_z8e.dat
 File: myri10ge_rss_ethp_z8e.dat
-Info: v1.4.52
+Version: 1.4.52
=20
 License: Redistributable.  See LICENCE.myri10ge_firmware for details.
=20
--=20
1.7.10.4



--=-xSocFvd7qp/S87zIy8AU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/oVm+e/yOyVhhEJAQov4g//ZkdGZd11nmVwf5j4hQzp/5gU1ANNOZF1
eE0UqaqZ/kGZuSLG0or17ERIYAPKFqw/lreNCnedEuWCxOPNQYJucdrV+Dbot6hb
g1R5tLION5r+afd66kpxOJhTIpFt3Tsiam5OZeB4RABi3CTVjFlHZbhdUGhemJIY
EiIBAQ+W3KRK6XJ/BA7vFPGUX49vLiPvV6ue70OGYRakR5VEMefXiWyBO4YaN2yH
BDmZG5rRdO2933MF/sAMFD5xx8bAJCrynuRDESIAxyey6Na234kjY72/jdaWkKcR
OpUBsJTX9SIzgVWEbvsRxIlQLRXNcjMX0ufu/2uHopf4I+oTTM1UjbLlwI6jfPL3
dWwtgfApzGgpplSjjncnnFdE/fu794hypehc40dLN2jg28LENo92m8LcwQ3X2SaJ
PBQ+fVKM6YeUbkcKeGGotdAhpEtlNCxRJP38pa8RdfmQY0o9RkeQwT2mUlJxEg64
4LoXavudE/2qknkjhYGU6Wo1eqsv36+d6pMQXSunAOemuDau0lck3deGVmK850oi
81aCg56Yzn8D+meUOtCZUaMm1k2LjkxWS5hkdtoKQE+TuJTSp1VFhjGoJr5H9dbs
rHsDM5V1aV9J3M4V1S6pUHv2pbgu67BwAciX5yKpCVWHlE0s9QICsgRov6nyNJVg
l6W8S0pyISE=
=uIgP
-----END PGP SIGNATURE-----

--=-xSocFvd7qp/S87zIy8AU--
