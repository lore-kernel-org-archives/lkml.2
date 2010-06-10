Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab0FJDwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:52:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46129 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0FJDwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:52:12 -0400
Date: Thu, 10 Jun 2010 13:52:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the drbd tree with the block trees
Message-Id: <20100610135203.4649453a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Jun_2010_13_52_03_+1000_you=wQaCdG6.Z_Oj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jun_2010_13_52_03_+1000_you=wQaCdG6.Z_Oj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drbd tree got a conflicts in
fs/fs-writeback.c against the block tree.

It looks like the block tree has moved under the drbd tree again.  I used
the version of this file from the block tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Jun_2010_13_52_03_+1000_you=wQaCdG6.Z_Oj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwQYWMACgkQjjKRsyhoI8yEAwCeL6kicpb/0nbdh0HOzwoKfUZb
v6kAoIghvlDHLarzhUg2MYytPS4KT/As
=sfiT
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jun_2010_13_52_03_+1000_you=wQaCdG6.Z_Oj--
