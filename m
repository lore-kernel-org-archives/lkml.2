Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1KXAVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:21:37 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33188 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1KXAVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:21:35 -0500
Date: Thu, 24 Nov 2011 11:21:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: build failure of Linus' tree
Message-Id: <20111124112117.f9abeb7a3f4868be71389372@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_11_21_17_+1100_SCtczkjnaQU+X..Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_11_21_17_+1100_SCtczkjnaQU+X..Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

today's linux-next build of Linus' (x86_64_allmodconfig) failed like this:

drivers/staging/iio/industrialio-core.c: In function 'iio_event_getfd':
drivers/staging/iio/industrialio-core.c:262:32: error: 'ev_int' undeclared =
(first use in this function)

Caused by commit b46413367961 ("iio: fix a leak due to improper use of
anon_inode_getfd()").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Nov_2011_11_21_17_+1100_SCtczkjnaQU+X..Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzY39AAoJEECxmPOUX5FEO44QAICWQVPkZYApOoer3k4Ps5JV
yqir4XC1nlASGt8bOyhoIDjqZAnAYKGViyf59rvHPNTu5YYZ0IdFlU1sNCYZcVcn
Cr/AY9qb22UY6gulBvnTCxEN7prWzxev4kHWlCaurAFRGX0RieUpWHofc9m8upwA
g08yZxob1aNgBLF2N1LY58yIi9CBhfOzWXxrQURa7soMAwjUjNZE9FAIHjxmDvAa
BrSPMbCUxnSvtoIlUgGJajbOAyEvlFXAkHZC49YxSrwo7gvzMlDzAOYoYRINn2E5
5rqkSN2fCFwZY4FpmPy8CtsZPK/YuhtKHkLflaLEaTl2LSQNIgavCJ4o4AeNCTv+
qDUIYBt9Sp8zRjUoMHgHozeFr51ieVKh3X6y3LX98BHkjUL5KPzDW+2EFm440bwb
HGmTu29oiBQ4AVb/xO0xy6dR01eQ9tqdFuJ7XhSLiPparUbXBJLLHtJ6ctUBaRkz
ZgdJqF51DeBYSagQx8RtRnozKgBErZ4LtuISQTgDW1+4UtrEelvUrdNEvznrGlVF
fpNyEW7dafE+baozM8XBY6fV3iI+ORyj4PzLRwnSFjrYCJKi3K1zIrW1Zcqh9J+a
vYAEgqK76JgRkAs9e54dhnTNxmN7ldcSfL6sn9Uc+eF85mPgNFhI5kdV2LZZVI26
v7LbURyM2Y02iOVHXOJx
=vY4r
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_11_21_17_+1100_SCtczkjnaQU+X..Y--
