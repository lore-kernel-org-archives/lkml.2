Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab2JYCF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:05:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51152 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab2JYCFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:05:55 -0400
Date: Thu, 25 Oct 2012 13:05:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20121025130545.5755af42c5573e2253866913@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_13_05_45_+1100_/gMmx/M8vqRgys.S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_13_05_45_+1100_/gMmx/M8vqRgys.S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/misc/ezusb.c between commit 197ef5ef37d9 ("USB: Add missing
license tag to ezusb driver") from the usb.current tree and commitc
30186e51e53 ("USB: ezusb: unexport some functions that aren't being
used") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/misc/ezusb.c
index 6589268,0a48de9..0000000
--- a/drivers/usb/misc/ezusb.c
+++ b/drivers/usb/misc/ezusb.c
@@@ -157,5 -162,4 +162,6 @@@ int ezusb_fx2_ihex_firmware_download(st
  	return ezusb_ihex_firmware_download(dev, ezusb_fx2, firmware_path);
  }
  EXPORT_SYMBOL_GPL(ezusb_fx2_ihex_firmware_download);
+ #endif
 +
 +MODULE_LICENSE("GPL");

--Signature=_Thu__25_Oct_2012_13_05_45_+1100_/gMmx/M8vqRgys.S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiJ55AAoJEECxmPOUX5FEjt8P/RRZjthtV/MKTiWTgceLOEwX
8WCO7ioPf0x0GHK7IWa8APszLO3EJofpCFxlmxIbTnDbZBE3z6wx4CFc8mwc7wfR
meXLGoQhbJ9xdAB6t+ludO64degrt3dpV6Ma/ku2KBi3ELhvsiwPV9cHfVBfAACh
ncUTJfPD2BnR4sUpPt1F6M+twCofw4JMhxbP33V+Ql+iN0FmUqqvR+KEoEkDPU8M
uP2aiA6u+Vpudup0WjcqMYX0wgCkDbtEmdeHxd/dQ3A3metuEmLJcmIQpgLbIN2p
jd5Ir6ORX78+akPj59XbZRw4mx7O21SAOppkU6Fu33Bldm1hm1e25dXtobeqoODC
Aa8slQViHZVQw+Kt0CDyrnvOKzz/5ytROSBHTejzfGF0EsE+k3Q13Cgnl12ntXqN
wuZ5KAhETcmdZwsouqV0fhjOpKF/wXDL7pdA16vZZIaF4wZW4dcWtQpuYwBYuGed
PPa8AcSRo2xiaN6t9WC6EbfGDkTY9nFNh8tVNnHys3SZmw2tRVIApx4qYb8u22GK
3h6w7FhWI10+c8tmWIZvKBSNpcOoJi8i3aEI08sqaF7BWKu7MQb/6E1wk6ZPSzQJ
gBhdtbdOU/urno9ET4osQtyH6eYgvHLazX3RguptKGAXASwoBVDMBrkhE+o6EPLe
81mgXAcImLoUahoQJuxr
=hiDT
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_13_05_45_+1100_/gMmx/M8vqRgys.S--
