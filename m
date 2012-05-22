Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2EVEOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:14:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60625 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2EVEOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:14:36 -0400
Date: Tue, 22 May 2012 14:14:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120522141433.586338919f5dc802f06bd5c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_14_14_33_+1000_oKwfM+yPbb7gTuYv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_14_14_33_+1000_oKwfM+yPbb7gTuYv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/regulator/tps65910-regulator.c between commit a40a9c436b62
("regulator: tps65910: Use generic regmap enable/disable operations")
from Linus' tree and commit 3f7e82759c69 ("mfd: Commonize tps65910 regmap
access through header") from the mfd tree.

The former removes the routines that the latter updates, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_14_14_33_+1000_oKwfM+yPbb7gTuYv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuxKpAAoJEECxmPOUX5FEn+oP/j+PiUiJol64HgBDC85/DE0q
8fPqofsdENAt9QLnCRlJRD4n5EEBYvxeiuEKgfp14YhofuEn7GUBZte+61kfogYP
/FzRPCt2qKr8o0nm9z20lEPq5Ea9KKYCEjlQpryyZaX9yjSJiKSSr0g+DvGtcbh7
pJGr/TEXJQ7NkySNDzyZVm/m4BhaFckNhw31INWgAkoXtbqLemRDUDHrrNGV7Mjr
VTlV2LBCMKhd5chqfatlSsdauMmfdcVWdmKpLZDoDsjZpLPIxwX0C/CKz4N+WcmP
czZr32UV5hFNMoRMUZDTZCX7U3M/bL8QXEJgU4DRG8rI/q1zFmWEx9qqok4/k9zB
zD9/UM0dP3fF1M5Mgksxtz9oGeknY+4i9gr2xGkOHoLETSy7+86bjDQ31uAaGY56
bjVg4NYFqZBo1GSf1sanMvSEVqm9/YfzcwPVKm/pNfo4bcmYvP1EUhV8wyDr1wt9
3YWkj6u0H06llt4p2cTYIbNQCPuT0PKtjRrj1U6IsZo2lmO94Da05hx90wIXVAgZ
SZoYMDrKungnrsnpzk5mRd3nG7nEeI2pOCcA2DxjR/1oqrGlq4y8aRGVW91bWeXB
5sCUHCzO3goOHC48pjPbCYJc4GaWPC1U3UMErnV2N1vCfTAVtWAXi7O5hfad6JC0
llVL8rtKDZ44wkEXrela
=PzPn
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_14_14_33_+1000_oKwfM+yPbb7gTuYv--
