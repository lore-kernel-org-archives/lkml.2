Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1IOCao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:30:44 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34606 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1IOCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:30:43 -0400
Date: Thu, 15 Sep 2011 12:30:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-Id: <20110915123031.104554f51c7642451fc31434@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_12_30_31_+1000_AQku8uvbKWMQXpC8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_12_30_31_+1000_AQku8uvbKWMQXpC8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in
fs/xfs/xfs_aops.c between commit 2d2422aebc03 ("xfs: fix a use after free
in xfs_end_io_direct_write") from Linus' tree and commit a826361aa4af
("xfs: defer AIO/DIO completions") from the xfs tree.

The latter moves this code to another function (better solution?), so I
used the latter version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Sep_2011_12_30_31_+1000_AQku8uvbKWMQXpC8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcWNHAAoJEDMEi1NhKgbs9jkIAJpc+csTu6vCo08g0urrYTl3
ahIHYqR4gkljpss0gmZz3L7tzgVsAI3QLowEWBx8Vn8M76SuYuYP344tAsFP+VOT
3ewvCWfLNHQWPL+BfxfVrvXNrVZQ+xPf3TB+YU+dZyfHVol/vTBX+uXf9/KcMrK5
sBiam1IhOusnqSAQsJjKcfqv5gAdtr99IR/+n45wsCG3V+bQLY9bIC07R+xtnzCL
1ZGKz+hF4VWKALEyy6TiNwF0lmRJDfZ2vCODxysZM3rNMmtLQ6WDl55mLEZNqqzF
NUFuTBeHTuIPv3RsutmutT8ncNnTYK0PZS2YveLz/R/BRKFoX9hJWZ5Ekk5EoGs=
=unLU
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_12_30_31_+1000_AQku8uvbKWMQXpC8--
