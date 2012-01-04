Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2ADCSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:18:37 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:32982 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab2ADCSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:18:31 -0500
Date: Wed, 4 Jan 2012 13:18:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20120104131830.ec4341de50a69f4f3f2c5b7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jan_2012_13_18_30_+1100_p71o9y7xJChHRaH1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jan_2012_13_18_30_+1100_p71o9y7xJChHRaH1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/plat-samsung/include/plat/system-reset.h between commit
281c8724c10c ("ARM: restart: Temporary #error to persuade platform
maintainers to take the restart changes seriously") from the arm tree and
commit 08c6fc52956c ("ARM: restart: EXYNOS: use new restart hook") from
the s5p tree.

The arm tree patch seems to have had the desired affect so I used the s5p
tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__4_Jan_2012_13_18_30_+1100_p71o9y7xJChHRaH1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPA7b2AAoJEECxmPOUX5FEmbIQAIUp3xtyumnk3dGtlj3xsXJx
5mb7tSbwYnp0/VbSqLA0Z2v3btk4KYYHYMTNvHB650eZmzVm+nTy0aLKA6J/6jiR
dZpdRYBIffCIqADUwylMZGf1ok3ZEx88YukZ0CCrp9SxRLv+ypJ2wqQexbD5051s
U05uNGG2GH29JNUzKFN/UHsuQviUdD5gDnlygAwCTkAx3u9aZ/9sVIkq5rF7HAQ3
Th0uKNgdjGxq3dTaP6UzIzOTZzXOLoIe75U6ddY361jJOyZzL95jANHpi7upY9F6
mBZ9jOkI2MsJIHCKf8daultXOQdBtjlKtf4kWe2mmA23RxH8ns8TlDvAbxsEQqke
HsbZzyh29xgopzzJ28R6aOYRGytu8+vaOvTDHBIc6zCmeYEftvQ+xJ7UWgBkU/Y6
XuJjqBCjklAyds9hcueQpeuLmu34I5LK/HBGnI4sWbhLgkuYV+zpxNIqmNpABEC7
IZRVfxOFkSAnVCbGsxCAvBJnhch7anXeeoGnyXRg7TURLaiFIHeLDX8riumj/ju2
C1JO4MXTGlNdQggBBv9R05tRsnwOdLknAA6V/AC1Hwx3F1BPX7ySr32JdHmlm+QY
uQJrf6OkdA6bBDtHbJSrMMwgXE+6mG4czRsXLRMp3jJ0e2lkSrjVVTlSXGiURe8z
70XlrNjZu9bQlD+uknlg
=t9fs
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jan_2012_13_18_30_+1100_p71o9y7xJChHRaH1--
