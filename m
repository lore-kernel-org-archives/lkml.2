Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1CKGJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:09:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56009 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab1CKGJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:09:23 -0500
Date: Fri, 11 Mar 2011 17:09:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the usb tree with the s5p tree
Message-Id: <20110311170912.0fb48cf4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Mar_2011_17_09_12_+1100_=1pb6Y+zVt1UU24n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Mar_2011_17_09_12_+1100_=1pb6Y+zVt1UU24n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-s3c2440/mach-gta02.c between commit 326d05c15f7f ("ARM:
S3C2440: Request usb pullup pin before using it on GTA02") from the s5p
tree and commit e27c3c5c7e0f ("ARM: s3c24xx: Switch to common GPIO
controlled UDC pullup implementation") from the usb tree.

The latter commit removes the function gta02_udc_command() which is
modified by the former.  I removed the function.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_Mar_2011_17_09_12_+1100_=1pb6Y+zVt1UU24n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNebyIAAoJEDMEi1NhKgbsqkUH/3Ot+cg/7Qc4ANbeLdrVtPUV
+Zc/M8irj0UThpNtsLSNX4S2WYpY+67q+bA5O8mFSd6eqTfakLJ/G95+1VYt84U3
FdUmpXM+cC+sjecjKwR6iDq5Gemehk7dNirbYBQpJXNwAy8dX/X+jYT+z52ySfLu
0h/05WiyI1DUjXrmrSNqzhsMUKtCD5sK2Q6geJLDGpn9RbNhuPMV/oU6c3wjrkRR
al4uJMrXkSPnR9+iowoeBwTvc1EZBZexEs+KzB8zUgUIqpVYB1ptrTrdAzLFLw7C
NA7wsREJmh3RnBiKrW6pwajmKFTolQ+C6ndrXvaGiMPbGqXalwRxlMizGE0apPE=
=b904
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Mar_2011_17_09_12_+1100_=1pb6Y+zVt1UU24n--
