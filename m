Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2DJAi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:38:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33128 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab2DJAi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:38:57 -0400
Date: Tue, 10 Apr 2012 10:38:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tile tree with Linus' tree
Message-Id: <20120410103850.db4e6c388d09253d914b442b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Apr_2012_10_38_50_+1000_VlN4GGOzURsVVjsl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Apr_2012_10_38_50_+1000_VlN4GGOzURsVVjsl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the tile tree got a conflict in
arch/tile/kernel/stack.c between commit 5f639fdcd8c1 (arch/tile: various
bugs in stack backtracer"") from Linus' tree and commit aa127c855d1e
("arch/tile: Allow tilegx to build with either 16K or 64K page size")
from the tile tree.

The former removed the code modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Apr_2012_10_38_50_+1000_VlN4GGOzURsVVjsl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPg4EaAAoJEECxmPOUX5FE+FcP/AliM3c9CREWfMxP5lPtFE/u
HsfJSKYhMlUwa+TnYqKUfpmhnos5S+v8Ctq/5ARk0S3ozzbQClZ7AOvsenhZEAIR
kll245u/dCTo1AN5xY8OpCKT6H1VAuv+aRH420LyXxHAAQXXwxH1wJxIaJTYKm0D
f95FhaOBfwth82U3YXSNWJLHTXYFi8c54FOGaZ0DbCHBl7FzrXOxAVeWE/XX4Yny
KpXk03So+It+M9rmlfLDn7Iail/pPBT41tIf5PWmIke2mKdGxS4sKLlPHWIbyRch
9Wg2QP44oywT2+E9syxeslkLuQAvHgFV6Fvk76qbtjFkm3FtbXO9e8vuOdDPXp1d
3fvNsr07GoNqdB6HSIlvuekqKhoSsBXSuNNoPU+ktfMiTtHh/v17bQd0IiV79RFs
9g2jBTNTCImwWEr7u2cKKwvBF0MeJfnbvn7mGcA6VPXYPWaoVPT01FAKiHMCG4i8
jATgq/Qvh3eo1utrsmL6KOGHn/j8muJnG/ZkRTENlhMEP0XzIRCxJkT6ZYP1MT2L
moGE93+/qr6dM51K+/6oV/i2aAc5vMsZCTsC+9J4C0Y5k5SQP4Uf0ZJMT4gjtuYx
WkwBOuizlVl0Tczxfaaeq3KVANVXsN4dkWX015pmeLIB/JwMTUJhSVZTBOxyw3u6
est7C0V73FzEDPDXlocx
=wxn6
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Apr_2012_10_38_50_+1000_VlN4GGOzURsVVjsl--
