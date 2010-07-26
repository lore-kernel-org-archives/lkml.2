Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0GZAil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 20:38:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37680 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab0GZAij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 20:38:39 -0400
Date: Mon, 26 Jul 2010 10:38:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: unable to fetch mips tree
Message-Id: <20100726103832.34ec95dd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jul_2010_10_38_32_+1000_BK/gQXzgKSMCHpBr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jul_2010_10_38_32_+1000_BK/gQXzgKSMCHpBr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Fetching the mips tree today, I received this error:

git.linux-mips.org[0: 78.24.191.183]: errno=3DConnection refused
fatal: unable to connect a socket (Connection refused)

Just a heads up.  I will use the mips tree that I fetched over the
weekend (top commit 18931956adefdb896025a3a03a9939571c84a2cf "MIPS:
Octeon: HOTPLUG_CPU fixes").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Jul_2010_10_38_32_+1000_BK/gQXzgKSMCHpBr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTNkIAAoJEDMEi1NhKgbsJbkH/2AiUipzD1mYBokmlbL+bRIw
qjOiTFddJipxdnjVKEpbJs2aeuhAhe2R6meRRPiCwzgQ/xSL73H5aGhVLQcxhErX
NKpmJo3GCvDvUY7Fr7kZnUznY/6STBSzpFiMFLPOgSJzb+e9bPeO8dMFIGwHQciK
vz93XAl+hvi91igUyf9fy33rOi2hTWVQYsIHI/QmCgFF3Ig3Dc0ymSN/9apq1ycv
hDKtUjEMWdVlYLkeXrgF/LVt3Y3ywHHAhNlCa3uQcB6pdKQjp8A8B5OyaMD/3JQS
CXZy8ENH/Ibp9O/Eq4OaPFofbai3MDlkwCR2/urw1hAv/JtWOIqrblLiQn/g3UE=
=P170
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jul_2010_10_38_32_+1000_BK/gQXzgKSMCHpBr--
