Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab2JAEX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 00:23:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48698 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2JAEXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 00:23:24 -0400
Date: Mon, 1 Oct 2012 13:22:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: import of the device-mapper series failed
Message-Id: <20121001132246.85b1943b16ec7a671fdd1ff6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__1_Oct_2012_13_22_46_+1000_yxL0GXiJ7__YtXty"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Oct_2012_13_22_46_+1000_yxL0GXiJ7__YtXty
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Trying to import the device-mapper series produce this error:

$ git am ../quilt/device-mapper/dm-thin-support-discard-with-non-power-of-t=
wo-block-size.patch
Applying: Support discards when the pool's block size is not a power of 2.
error: patch failed: drivers/md/dm-thin.c:2762
error: drivers/md/dm-thin.c: patch does not apply

and indeed the code in question is very different from what the patch
expects.  Is there a missing patch?

I dropped that patch and the following
dm-thin-move-bio_prison-code-to-separate-module.patch that also did not
apply.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__1_Oct_2012_13_22_46_+1000_yxL0GXiJ7__YtXty
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaQyGAAoJEECxmPOUX5FEL74P/0VquYduX+FWRk0O6CDITAFO
obbiNv9/x2xo/ivy0F7XcnG7PTS2A/YUGDv8D9PZdUFScVEH8AvEnyQ/5zc8VUyX
P6MjH0YHth2jv1rlMbLN+7tq+qjeI3qf66lI9RzOpwipSQENrbbCVvvpsxqJwQAp
5P7HtTbWDPaTkA91DeWwwgPmE019lsuP+NBgS/38drPmWwr49QGbpA/OrN7cbPvT
H/dieknOxrI9Ts4nUN58eJO61xi5h4+NNweVZNCLPHkt2T0ZLf8+VROtas8q+95e
8IGJ3nIuOGZpLfC/Ny/ZqIXuUlJzFjT+h8K1hpOGjkyqTIKXVBdTX2cF5ps7iKxF
AaelUO8zQnAcEPsDZoklDYh/QaHH73q5qE4ivLQN2+mMRgFMWRok/k1TL9f6CaZp
t1qmQS8B7omaZ1mamchkWwIAUa47kWp3+PVpYwu16fiEqqEyi+dieaos7hqnd1VB
/NJPsGruTWbzuUNxMbGTcRLl3aRQ7booPGvcyz2MsCqe1nDYF17256+m4ZBNBEIh
b1W5xIhM2QNeWjyWsBgzBcwXSGdteWouz+j8moOu2JDw9vEvH0CKz8i8Xxc5oUhl
ZGIGawSX58Ec+T/fYgoXzalFwyQpydM8bSGRDqGotE8FuLxkVgcRrRHfupXbKeQI
Lt5Y1xoPaSZZme6p+xZv
=cmDc
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Oct_2012_13_22_46_+1000_yxL0GXiJ7__YtXty--
