Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab0GVBrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:47:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43253 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0GVBrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:47:08 -0400
Date: Thu, 22 Jul 2010 11:46:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20100722114655.1140fb61.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jul_2010_11_46_55_+1000_lg/M1miGI30F_z6_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jul_2010_11_46_55_+1000_lg/M1miGI30F_z6_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
arch/arm/plat-samsung/include/plat/keypad.h between commit
1e3241300503df18a098dd35098f6975dcf622e2 ("ARM: SAMSUNG: Add keypad
device support") from the s5p tree and commit
0fffed27f92d9d7a34de9fe017b7082b5958bb93 ("Input: samsung-keypad - Add
samsung keypad driver") from the input tree.

This just looks like two versions of the same driver (or two drivers
sharing the same header) - please sort this out.  I have fixed up the
header for today (by including both versions where necessary).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jul_2010_11_46_55_+1000_lg/M1miGI30F_z6_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMR6MPAAoJEDMEi1NhKgbsNRUH/05/2fZL8oUSPLzIy5MJOTOw
Wt9Xxyq9iX0NCW+ePDtNcQ5mmb8uJwM7LlfyPklbXBkayDtO+fVFgxm7uYEmXUsr
p/IOxs9cj8Nh10aVhX1sMwm3dHFnX86dSSPH4wVOOGUeH3JNyo31IOQcU2tlctRP
4Bft+78L3gYUgXsebNQx/OZQB6PkRbXEhtvu27NRFh0H7f0yTavsLBWtDENZEpV1
6hPKM1UUebPMbXkwxFkUYoXASrYv4Cc455SMX+8qycfsFd8Szkk+2LZ92QLaOdac
53Uevv8wafbtD9dP6F4c+Zfd4hYWK291OrY1i5DRuaCcs6F64Un9zBBRXD4K+hg=
=PyTG
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jul_2010_11_46_55_+1000_lg/M1miGI30F_z6_--
