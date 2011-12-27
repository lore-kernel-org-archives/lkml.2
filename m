Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1L0Xdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:33:46 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52428 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1L0Xdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:33:43 -0500
Date: Wed, 28 Dec 2011 10:33:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Javi Merino <javi.merino@arm.com>,
        Boojin Kim <boojin.kim@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm-current tree
Message-Id: <20111228103341.e448b4f44a2ba321a16f54ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_33_41_+1100_dTDl2_XIJ.yWl3Sl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_33_41_+1100_dTDl2_XIJ.yWl3Sl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/common/pl330.c between commit abb959f8a3f1 ("ARM: 7237/1: PL330:
Fix driver freeze") from the arm-current tree and commit 5f3f34eb0ed2
("DMA: PL330: Merge PL330 driver into drivers/dma/") from the s5p tree.

The latter removed the file and merged it into drivers/dma/pl330.c.
There may be further fixups requires to that file.  I just removed
arch/arm/common/pl330.c.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_10_33_41_+1100_dTDl2_XIJ.yWl3Sl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+lXVAAoJEECxmPOUX5FEyiwP/Ry41dR4MuXAEstZZXb+e4/g
B+f6Qz9DQV5lNbSZa/2B12xiBmQtn7DXbpLS0FK0BciFfDMdWsT8JIR/Z0Yt8pfh
Lt5stvwmJGsMeATIrGPr1HPdWuZ2i+Ujhyhb7cXGqOaTOKhi3ujqjBR4LDUJGC8G
dDMYN2ujILqCdSYuToOvNPSe4EJBTW1zT3BsbFhh9miK2yicdwibM8vzPteU8Yxd
Cr71EIDV+JvonZM4BK3wzepewgEcpyphT1EmRQ5P38kx1zUfi97TvIGaftn2oe9U
7wXTE9RcAeKvfj7YLQs/LLF0zo88mCFXN5xA5ngGriwTsZZZvp5Ct6fgOrfw0U6o
ojZhf7go7bT7zFf+bTkXXFSX2ElNJiftDy7J5QRTq/Ze7aD2y339bRtGTJtopuFJ
WKdUD8pfZ3cMiJFtwnRX+ZDhDqVm94ghm+pWLv8OFfaWZ4mH2JeiuTRUUfO2hD3S
TAf0NMajdegk1xb1WDZeWrijk3ViSivhZpr47xS2h+Zc9FJ51AtdnzCsH56efJ0T
bC8Pqkjt9L95ppVs/Iz5IBcu8P563ilqoi5TtNpDHCd451l06rTEvbc8mImRKLZk
OOmSmiPz4fONDw/zusAmDcfMD0adbK574RkCALpRf6LmCaiVt1n+OtlFHKfr4BJP
AXn7H7NffDUEUkEOpm4m
=P+QR
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_33_41_+1100_dTDl2_XIJ.yWl3Sl--
