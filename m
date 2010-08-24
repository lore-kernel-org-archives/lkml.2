Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0HXAxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:53:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37330 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0HXAxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:53:39 -0400
Date: Tue, 24 Aug 2010 10:53:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the block tree with the s390 tree
Message-Id: <20100824105328.9bf22335.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Aug_2010_10_53_28_+1000_75.op3XUQ3XJDyxm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Aug_2010_10_53_28_+1000_75.op3XUQ3XJDyxm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/s390/char/tape_block.c between commit
7dc74a8fdb22f4410a2d8e45353c9ea75821a9ba ("[S390] tape: fix kernel panic
when setting tape device offline") from the s390 tree and commit
52cc2eef31587b22ce9fbe77b064a031a9613ab0 ("block: switch s390 tape_block
and mg_disk to elevator_change()") from the block tree.

I assume that the latter removes the need for the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Aug_2010_10_53_28_+1000_75.op3XUQ3XJDyxm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMcxgIAAoJEDMEi1NhKgbsHlsH/A2X0PUGfBSZhGoy4p3I24hg
3vqqtOc24o0lwTjWYMWsOLLdnVeAfrZt+Pye/Gg52nHbnB0EINIFJzUbLHCPBqI3
EGA5efdQDy8GwxsPyg8YryV2jb4XklrAVqV4iPmWiT+KPrWNECSz2nOICF3AQ/fY
R6q//9wY19Po/yIM1XDB5GTdxPQOTjbvTVSxm9MDyg7i9i29qjLg2ZqHm3ZVx5Wj
noW4w/xbY2Ppj/TcDhUU29T3jwtRZ++8J2x97s2u8lZV0rKUa1Cd/fDUQs1+4gzH
/kYKNYdrrAkJh8tjOC7dyqulJWjnrwc/Vk20o8NQIH8BrXdxOE3x2CH4XSVr8Zk=
=L30R
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Aug_2010_10_53_28_+1000_75.op3XUQ3XJDyxm--
