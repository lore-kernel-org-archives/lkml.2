Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1GPMhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45794 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab1GPMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:11 -0400
Date: Sat, 16 Jul 2011 20:38:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the gpio tree with the i.MX tree
Message-Id: <20110716203837.ffee6af39380620984c2d8d6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_20_38_37_+1000_eVXe1NXcJUnufV_/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_20_38_37_+1000_eVXe1NXcJUnufV_/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the gpio tree got conflicts in
arch/arm/mach-imx/mm-imx1.c, arch/arm/mach-imx/mm-imx21.c and
arch/arm/mach-imx/mm-imx25.c between commit 8d3c41c8bc6a ("ARM: imx2: Fix
GPIO iosize") from the i.MX tree and commit e7fc6ae74467 ("gpio/mxc: get
rid of the uses of cpu_is_mx()") from the gpio tree.

The latter change incorporates the former, so I used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_20_38_37_+1000_eVXe1NXcJUnufV_/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIWouAAoJEDMEi1NhKgbsq/EIAJrnmrHqIjvk8Vewwn2LXAtm
vE1qzGdz9Ea4Y/g/IBlWR7Wt4wlUp7KJya00oK7mMl2Thyr95Mn7AuC0gaoXh7gK
0G7468j9MD4AvMFqM7f0TuSJpaSgiq1cuKQC8icvLpK75vWWuxZ3nNS6hNIanEjy
PPMStk4winfy75i6K4kWqnKUoAew8FjPgGVry0orthb0aHiA0UyeYwEkppaDwi+X
NGtdoCfbaQa9p2Cpd3DDoz4Mic7O0ryHFeChHYs0eDK7onJKWW55gfd04SJrik2w
bdIzXPtmmSvPhFolv+1ENqI3jgjB/3XccHDKJFsvHSg1DT0iVKW9678UOdpf0Ak=
=Duc4
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_20_38_37_+1000_eVXe1NXcJUnufV_/--
