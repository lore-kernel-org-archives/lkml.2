Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2IJBeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:34:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59040 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2IJBeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:34:11 -0400
Date: Mon, 10 Sep 2012 11:33:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Marek Vasut <marex@denx.de>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20120910113359.ddc30b010fcd73f00c993d23@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Sep_2012_11_33_59_+1000_RFpO_H/YSS5okRWU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Sep_2012_11_33_59_+1000_RFpO_H/YSS5okRWU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/usbhid/hid-quirks.c between commit 67ddbb3e6568 ("HID: add
NOGET quirk for Eaton Ellipse MAX UPS") from Linus' tree and commit
2843b673d034 ("HID: add quirk for Freescale i.MX28 ROM recovery") from
the hid tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary (no action is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/usbhid/hid-quirks.c
index 991e85c,9af530e..0000000
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@@ -70,7 -70,7 +70,8 @@@ static const struct hid_blacklist=20
  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
  	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
  	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+ 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET=
 },
 +	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_Q=
UIRK_NO_INIT_REPORTS },
  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_=
QUIRK_NO_INIT_REPORTS },
  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_=
QUIRK_NO_INIT_REPORTS },

--Signature=_Mon__10_Sep_2012_11_33_59_+1000_RFpO_H/YSS5okRWU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTUOHAAoJEECxmPOUX5FEdK8QAKgAXkVeG5sdXTyudMnU45ew
zJDaWuoUdOKML4+M5D1vkA24pC17/nSNFEl3OtnBOQudPBA/rhOjZdQdEfIkTC5o
mp6X5N7hjTPoBLTnUnBUg1sCKJ7K5st4kFNtqNkIiZF2g4giJL5oJm+Oqh4JUngf
sFOkt/IvwA8FywU6IeSRP3DdD+r+p1WdQSM2zhA5VViLYz08EPVzM8u4pqdowWrA
CtDVinU63l5g/YmrMQ0oNTVOv/O8oRKK+ES3Z35QQOH6R5PTnrmAUAKseDEDsSVg
QHqRVOUeuWqIPigF0fHK9m+vUMuug8/6rk+1GU4Tx99pJQUzsfJNug7DS4A1hEuN
ldGIf/xQ17G0nQ2VVndkTe9xpXxKp1PNN7PvmJ5ChZa71ytIothL5I7mwbIqAL9p
XJb0NHlr51Dp3PDNk6IwwmlmhYH1prjYSnyrlkBm7cZUGt56aGd0YamQ5QrVXh7H
vLgq1u5sW9TAe32cJzWCPZT7tP0rBnee0xlSWd0QjFrAuPRahzh/MbBD+0wIGGVo
LFbaZGnMS6JFnkmJ2ze10jYVcvGbT198tsApbSy2//0KbJcLnFxoIquRM2piQza0
Su/P3nL/a4qiFwLpQPMMvlX/hPdPR7QaYkc5CEzZTva2XKKXdCqrix8QgurhWwKa
RAO1MV6IfuGIs12COBGq
=dEl1
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Sep_2012_11_33_59_+1000_RFpO_H/YSS5okRWU--
