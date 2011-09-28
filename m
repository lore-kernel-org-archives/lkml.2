Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1I1HAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:00:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52283 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1I1HAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:00:15 -0400
Date: Wed, 28 Sep 2011 17:00:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the moduleh tree with the net tree
Message-Id: <20110928170008.6d603da5213d16a87b0485c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Sep_2011_17_00_08_+1000_09XwrI5QSYjBTeyL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Sep_2011_17_00_08_+1000_09XwrI5QSYjBTeyL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c between commit
af2bf4b4ee58 ("staging: remove ath6kl") from the  tree and commit
33cffa3526be ("staging: Add module.h to more drivers implicitly using
it") from the moduleh tree.

The former removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Sep_2011_17_00_08_+1000_09XwrI5QSYjBTeyL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgsX4AAoJEDMEi1NhKgbsOIwH+gODoD1jut/JYSK9WeKLq9UV
rWMVlXIp3d7w46APkfKonwMJez68xNacvTQBEm9iMmgvjWCN839LJ6f2h2f81eND
oBYSzT138IBDXedcCgh89NL2JEXl8CqOfpWgVXAwDSwQpl0DNheP4VxhHViIcGLf
6wFcgOnGAwBD/iW+bH5vjVRyU3ElKDOQjQAo4d0oetFU/3y1jQX64el0WNFJiZmF
0nIED35J2OGCuH7W22V0vtMoRKALKqBmpII32QcdposzyXNVTcNdxVFpFjem4nMl
KH5WCdS16BW07CzR+iR0j3EzxSiyEqPNQsVAdEmFPIo5Fiw/+1Ddmu5lRdXqI0E=
=q2k7
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Sep_2011_17_00_08_+1000_09XwrI5QSYjBTeyL--
