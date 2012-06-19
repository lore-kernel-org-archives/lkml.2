Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2FSB3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:29:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55223 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2FSB3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:29:47 -0400
Date: Tue, 19 Jun 2012 11:29:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20120619112939.23c80aed8f1db9682e37be87@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_11_29_39_+1000_YF7.=TiG=vAAy5UZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_11_29_39_+1000_YF7.=TiG=vAAy5UZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/hid/hid-ids.h between commit 9ed326951806 ("HID: multitouch: Add
support for Baanto touchscreen") from Linus' tree and commit 110301833d6f
("[media] radio/si470x: Add support for the Axentia ALERT FM USB
Receiver") from the v4l-dvb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-ids.h
index 6d3037e,70298d1..0000000
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@@ -160,9 -157,9 +160,12 @@@
  #define USB_VENDOR_ID_AVERMEDIA		0x07ca
  #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
 =20
+ #define USB_VENDOR_ID_AXENTIA		0x12cf
+ #define USB_DEVICE_ID_AXENTIA_FM_RADIO	0x7111
+=20
 +#define USB_VENDOR_ID_BAANTO		0x2453
 +#define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 +
  #define USB_VENDOR_ID_BELKIN		0x050d
  #define USB_DEVICE_ID_FLIP_KVM		0x3201
 =20

--Signature=_Tue__19_Jun_2012_11_29_39_+1000_YF7.=TiG=vAAy5UZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP39YDAAoJEECxmPOUX5FE50YP/jl8+qnxGtBwqaqsn1gOVPg7
YoakT908VAZJqbkbSnJ/7rboVAM9nUmSNissE7XNgD4E90G1HqW8My6FPFfmzc3S
ItjWzDhh+2vAdoRixhPMoh+rt0SLG4f6w1hmjNRLR++el0Xnv5f71hunN5qVDOLT
zx1en3ZjviEJ4VY2h3yjrDIIOoPGbqdzaG8AHz4l1RNOGg+DLz/gs+wLMvGlMTHu
JCcUefpIc3Q9QaCQXgTWYDDetJ5xqIwvnrHk6xQbLfTxyz1+fOrABjFs4WWf5cSj
bfGPYNwiLf115jCCbo9CvfMJvMZMZn0VmAbWyA7TAUzcnYhoezEplG3E4FfZovzB
3aJy0+L0QLdV1G0fnRLTzbTxOh2WctI7vp0SK9UDCzkdVDaqHBYxY9rubJPz2cw6
7quyiKA3aLnZ1Sr6SfDkkekqjViaexJEJldmSFuVjRDkrdk4k579luXWn5XgN0mr
Mw/mrcEgua1l/Pn48rgHHI8sceaih+6SrIIiCwPV0r+8RNPBRAlYMBvLbmXwWamp
IfKS0wYOfjlCa8WdX3cLzC4Wz/L7ON6Eic5V7n38OSoNN7GijZ5XdYfVCkVWgU1M
NM6Ii6RYSowKZE7Da/V71P1+UuKzrfoJIIQUEkTSr4OKUm11m9ZxhJNgZe6ZSUFs
u5NHGRXrQWc4s1APYW/w
=0qyu
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_11_29_39_+1000_YF7.=TiG=vAAy5UZ--
