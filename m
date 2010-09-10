Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0IJBKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:10:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46907 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab0IJBKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:10:34 -0400
Date: Fri, 10 Sep 2010 11:10:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the s5p tree with the arm-current tree
Message-Id: <20100910111023.671fdba7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Sep_2010_11_10_23_+1000_433dw75kxY_t2ZWx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Sep_2010_11_10_23_+1000_433dw75kxY_t2ZWx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/Kconfig between commit 9e84ed63dc71e13b62cea5ec6b0049260cca0b7a
("ARM: Partially revert "Auto calculate ZRELADDR and provide option for
exceptions"") from the arm-current tree and commit
03c1ebb0c4e84c4de78f522a73fe1e813b9a1fc1 ("ARM: S5P64X0: Update Kconfig
and Makefile") from the s5p tree.

I used the arm-current version, but there may be some fix required for
the s5p tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Sep_2010_11_10_23_+1000_433dw75kxY_t2ZWx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMiYV/AAoJEDMEi1NhKgbsnU4H+wQ5qZJFPUf7Er+Z78l4r2gX
j01JCsJrX+n9lF/4uGY3mhYgyf6pGbqAp+z0J05pR2H4gh7X/sxDHZ1f0ytTqvoS
9Hhop2L+h9Knu01WMAK3Nfq4H2fZYq+hML4BXMlfJ5qYYY95pdsUJiY8uvyGUsp7
Av9pztEblC7Cdh7wUFlqeAHowHr4TAkFdtYOvIOwFozdomsQEpKNAzw6avxkSdkq
I1PVxdECkI1G+jfWKTohHxpnbzCCEj7wsTdI1+8MkACUee3iCzfrNjh20EuwskHl
/YK6UOb0BvQkrQMcJlZwXxqr9CvJsEUDrCezEaFZzYKwLaZLI5psBzjnUEfNnTw=
=GQGj
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Sep_2010_11_10_23_+1000_433dw75kxY_t2ZWx--
