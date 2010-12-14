Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0LNAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:16:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42642 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab0LNAQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:16:56 -0500
Date: Tue, 14 Dec 2010 11:16:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-Id: <20101214111648.c8c9ae33.sfr@canb.auug.org.au>
In-Reply-To: <20101214110326.10604c33.sfr@canb.auug.org.au>
References: <20101213023733.GB6522@amd>
	<20101213144049.fa3b14d9.sfr@canb.auug.org.au>
	<20101213034854.GA8018@amd>
	<20101214110326.10604c33.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Dec_2010_11_16_48_+1100_DBwEJfJyTCK5p/ap"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Dec_2010_11_16_48_+1100_DBwEJfJyTCK5p/ap
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Tue, 14 Dec 2010 11:03:26 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I have called the tree (for my purposes) "vfs_scale" and have just you
                                            ^^^^^^^^^
Actually "vfs-scale".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Dec_2010_11_16_48_+1100_DBwEJfJyTCK5p/ap
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBrdwAAoJEDMEi1NhKgbs9Y8H/jE8u+VkCgqxDwlZksoNgxuo
MR/21lSgKLXL+GK/m2rs+zQrKtwEBVAo36pagMkyR5+AnJVVyBz+nhSSvQn8JoCI
nODzBz0cK9QSzP4PAN9wqIl/tYKp6rgfiL7D/puD/kHpU6mQjpJmPAjn9pnuxrhv
pMLK+02E+HSJzmeon+I5e9JUxw/WUzsc6xye8yp8OkJSlFB2CdL1pMkBwQQ2Hegi
YrDQk4PDkwvFGCB1colLSJffy+M8HU4EOrnqTQbEC8+1ERVUfVBriMJml+0pmn0o
BpZSIaFHtfLi08ISMkeddRbskrKxkYXNcLBj8Tpcel+vm3Qz2vZA6pxNARwSVAE=
=KaW1
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Dec_2010_11_16_48_+1100_DBwEJfJyTCK5p/ap--
