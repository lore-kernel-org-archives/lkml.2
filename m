Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1JYJHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:07:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43386 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1JYJHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:07:32 -0400
Date: Tue, 25 Oct 2011 20:07:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Miller <mike.miller@hp.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20111025200708.204caa3cb5d92d6f2ce35037@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_20_07_08_+1100_4uP4BoLaY37oslcj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_20_07_08_+1100_4uP4BoLaY37oslcj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the akpm tree got a conflict in
drivers/block/cciss.c between commit ab5dbebe33e0 ("cciss: add small
delay when using PCI Power Management to reset for kump") from the block
tree and commit c9e69629e873 ("cciss: add half second delay to PCI PM
reset code") from the akpm tree.

These are essentially the same patch, so I dropped the akpm tree one.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_20_07_08_+1100_4uP4BoLaY37oslcj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpnw8AAoJEECxmPOUX5FEAxkP/2oQjH6NqY+Igv+SGK6AgNMj
tMpsJjz4byWByTZb6ncMLHyMl/A79BWNoctqv2jBo0kwEEMZnvD3wtAfx1tuQEDK
sPigAAk5iuQT8PVDUlBz+hrfuGg55O0GlFTM8KAFriBDeIlMpYvpvDoT2aQftpqa
JCnD26thmU8u+hXJwnHZuBiRxeL6Amjddn9IOgGyVQFWWlsk3HCYGrj1WMt6gtxR
4zDpHwPDU0Q+q+p3nW2eIj29P/XYHLc68T4UJ1kgQYhHypOU3gNLZ6jD2vCBo4Q4
89NTNCxh6017RZAaldqrEmm72onAT3SXdAzzKo5DlQUPSthEkGpe3zyX9Ls2q1Tv
R/s5jN06PzUMMK+lzJGOHRmrI+R3R1GkXPWzCFGZYlrxoXwpGm6c1BqYk6aIG4IN
XddSyHx4Mzbm1sx3cY0PCvP0tf5Xq7sh2nKwLNCtQ10N2e2vKsCNJ2JS1GMAWc3/
p5rFeDGzNkQZcEvz2tz8adF+80SJovAxNKQ0cavBtP/RjPBMZB6oS8qGfLaGVuUq
L7kC2rcn86byDwVDal3hRrRhX5Omur0J6zAgMtQfVUNKDacK37m++NS6DC++Lnnh
kvGPHekHKSIu73r9og1E4YjrddzPGobq3fel7bw1tkLSz6IIf0w2LhUB8nYKM5Jy
VMQ+liBlTBYb91X2FF/B
=DHqV
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_20_07_08_+1100_4uP4BoLaY37oslcj--
