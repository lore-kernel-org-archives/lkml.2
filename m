Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab1L1F3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:29:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55302 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1L1F3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:29:05 -0500
Date: Wed, 28 Dec 2011 16:28:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the driver-core tree with Linus' tree
Message-Id: <20111228162859.50b53b23e90ccf0145f2945a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_16_28_59_+1100_HhC3bYh0NP2lb4oH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_16_28_59_+1100_HhC3bYh0NP2lb4oH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-s3c64xx/s3c6400.c between commit 71b33a4f7c86 ("ARM:
S3C64XX: Staticise s3c6400_sysclass") from Linus' tree and commit
4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
the driver-core tree.

The latter subsumed the change in the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_16_28_59_+1100_HhC3bYh0NP2lb4oH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qkbAAoJEECxmPOUX5FESaAP/AkwUHinZBguefzg7hl/xqyV
4HKiXJdRxUzPtQrChQKsCXschRDrDUIS5ddt8s8RmNTvITWMnXV94UcpP+5OHbrx
mWwTAZEGnQQgC/X/fGNwWuqBvSMPbgHu2W+96r2nvzAv7Q7rFpv0fvShD0RetC9G
9EMbynYIknZZx5+nbV1LuyCVOtsiZfduEW3Aek4zBiDPjp6Xg6thbi2JgYUcs01A
H92NUBwZG1cYgBtrSJmd0Imxdsd2xCg9Opdm3mSdRfNb8bvDlS0MEz5oXFy4NtAC
ZkpsmiUvcNdG1Lz/5NKdwpj6gEeXgnOQgTZu1Un2sCbBR3EvXGqU4QdbT4HbqZ29
CLe3B4d78ltkXNmTufo6eVX0PQosxSuobaRCc6qMJbtU8p/jbiwsGS7H9Pnrj/el
/9K346TioPLfTbOKN7CtK/w8GVBfrB7gQHR0kwLwT9L4SuGkmtv1FaQVoRqvgwaT
SZ7I0i/B5edf50DEGTD99WVz4QqpjfvLC0Ijk1zCNAPWVF/7TBwuiz6JK8YS8GU4
vIOAPHtO04rRRXy/463NIKPG4dxB6oLfNQId946nb4HSMsv8CNQpavtQ7o34ye6U
S0BNclxBSZEcOvWyaKh0s3E5ZeLJkyoqbixecbSTH1pEc+pk5mpYPKlAuQNdEW5T
Y7Dnuv3iOixNITVqwqyl
=LybB
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_16_28_59_+1100_HhC3bYh0NP2lb4oH--
