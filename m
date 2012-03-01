Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2CAWpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:45:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50522 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab2CAWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:45:53 -0500
Date: Fri, 2 Mar 2012 09:45:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the cpufreq-current tree
Message-Id: <20120302094542.270f421effd7a241d10a3852@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Mar_2012_09_45_42_+1100_SGYycCfyT3BQD0UL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Mar_2012_09_45_42_+1100_SGYycCfyT3BQD0UL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Fetching the cpufreq-current tree produces this warning:

fatal: Couldn't find remote ref refs/heads/fixes

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Mar_2012_09_45_42_+1100_SGYycCfyT3BQD0UL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPT/wWAAoJEECxmPOUX5FEtYYP/0AYkZ1OZzkF7avWyojsGkAQ
axu/S9IRDYzr1qgdF/2vvdbWezWzPr4WeuWmNe7f0uAMsdHQp+Ojp5XKhxgSNeHw
glVqZGroMr5BfiHnjOJbneTbfABUSyMqpOcztMmDiDMZZ2/Sre/oWXx97W1oevYQ
f+7dWrWOa4a8Uwya1jhjEWgS/8fkVVV6IQGRTjLGNFVbHbF3dKE9SAkTiDBN3msN
J7+0g7IpwNgkqEOjCRb5pGt9cyeJIyG/61NEYx7bhtr0y+PfIM6DUcoyS5eEsGef
D6uc9U51FvPYBadNTP1dDrBB3Gbo6+iYL45h6znEVNLScUqeu6KwEP8fEHcEYnQA
m8faUDf4QygfBZQBRlqEqtbP6SLYiTqTrRLgiFE07H9gOphlOLEHwbHnCxEQc8ss
78glIHPZgv8CQWqKZslEza9kQDsE44YxoFlW0Mqu3cSFPC7+oCRult4kK0oKDE9i
qbKZ28MQbdNCN4yY9RTPrF1j26qM/0fPrSN2+T89+lEXL54cBNHS0QC/rjxtgsq8
BlT4iTIIB78B5ZiTwjaWV3gJphmxXg8f1xDTlQrPiOoISDvcfPLA/bYzEjBLe9fQ
+wZNqEAgfhoDf551Ob1Dp2iijesbHaRq6/VfZ04qT2Vdw83DEO/jEMKHQ64fi4kq
Kge3Kx3YsqYQOeIeN+bp
=W0A6
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Mar_2012_09_45_42_+1100_SGYycCfyT3BQD0UL--
