Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0FGCyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 22:54:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56953 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab0FGCyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 22:54:04 -0400
Date: Mon, 7 Jun 2010 12:53:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the devicetree tree with Linus' tree
Message-Id: <20100607125343.cd109629.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Jun_2010_12_53_43_+1000_b=Ty=ZJ/j8ue5xCS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Jun_2010_12_53_43_+1000_b=Ty=ZJ/j8ue5xCS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/usb/host/ehci-hcd.c between commit
1f23b2d98c11fed43c552a5dbd00c793f81a8736 ("usb: fix ehci_hcd build
failure when both generic-OF and xilinx is selected") from the  tree and
commit 4c018c4ab1edd8f4154848868960ebe132c3d138 ("usb/of: fix build
errors") from the devicetree tree.

They look like two version of the same fix.  I used the version from
Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Jun_2010_12_53_43_+1000_b=Ty=ZJ/j8ue5xCS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwMXzcACgkQjjKRsyhoI8w9KQCeNjNFeYkRDxDfg6GfBz45KMip
rnwAoL5kTdi3kxwn3jds/6dPnLuO/PiY
=9iIV
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Jun_2010_12_53_43_+1000_b=Ty=ZJ/j8ue5xCS--
