Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2KZLT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:19:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2KZLT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:19:27 -0500
Date: Mon, 26 Nov 2012 22:19:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20121126221925.f6c8bdcbd35718989dd52b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_22_19_25_+1100_3G39VC=6tIsGD35a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_22_19_25_+1100_3G39VC=6tIsGD35a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/boot/dts/exynos5250.dtsi between commit 24025f6f5821 ("Merge
branch 'next/dt-samsung' of
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
next/dt") from the arm-soc tree and commit 5d706af5ab0b ("Merge branch
'next/dt-samsung' into for-next") from the samsung tree.

I fixed it up (by using the samsung tree version) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_22_19_25_+1100_3G39VC=6tIsGD35a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs1A+AAoJEECxmPOUX5FEa6cP+gJq70u34K5ClpoY15HsrphH
36XBS4YBHSCANRY7lOzaH0wIXFlyEbcL5+RVjNA73XYBVdI1rni/5b4utHkNsX8L
tWbKTK6uJcuESkH1pps570wYMuvw4tHJdz1dmhlEnCuRynqQR64+Rdn56epQ6QTD
ByZ0fS9p8zLF3LP9tOIbwggarI6vbZ54lW1Lxf8gZjOmMyUKqXKKBKpKnD4xN8D0
WF0gwFHVCmKBQMW4Nh1DcqvNji5rTvj8xwl68EXQCG0hh6HASC2ekM9OWwJQ4WPl
nWFTqcQMGjggwq9LSbsD7TV5Pqcz2OksbX/EuZ0iuUcLNO5LX7rzV1CdlqV0T7Tc
5UeKw+/W9hxRlE8Z+CJyxz70+cxgg4gKgMQdUV76gvicfMivSixsl0pK3oBNEdNA
zQPHHaTngrFmQCULG6ecNHvy/p6UGK1BguGu8XklpK6ZvS4rL0b1DSrhGeIeep9X
TCt0vCUbOn/mmnur4AuTn+y8unCC2Qa8G359qtmh1v284lcuBxBS9aZP89WfW1lP
wO2XrZ2P3PjgKh9n/Bh5Spa12aWQw3O6kMQUcDVIPFIx4qZrXgPtcFv2kO1SNH+z
b1Naw1zHr+hWGZC4tc+ETi5VcTlEnYGwieWeMzFZrBAo5Wn87idk/BNzvennL9Nq
C68FWVOMhj4Scw23q06K
=GyTn
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_22_19_25_+1100_3G39VC=6tIsGD35a--
