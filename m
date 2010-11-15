Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0KOAYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:24:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36290 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab0KOAYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:24:04 -0500
Date: Mon, 15 Nov 2010 11:23:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the xen tree with Linus' tree
Message-Id: <20101115112352.6cbf5604.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Nov_2010_11_23_52_+1100_T4alB4AQUvpqCt0z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Nov_2010_11_23_52_+1100_T4alB4AQUvpqCt0z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got a conflict in
drivers/block/xen-blkfront.c between commit
02e031cbc843b010e72fcc05c76113c688b2860f ("block: remove
REQ_HARDBARRIER") from Linus' tree and commits
c64e38ea17a81721da0393584fd807f8434050fa ("xen/blkfront: map REQ_FLUSH
into a full barrier") and be2f8373c188ed1f5d36003c9928e4d695213080
("xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER") from the xen
tree.

I used the xen tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Nov_2010_11_23_52_+1100_T4alB4AQUvpqCt0z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4H2YAAoJEDMEi1NhKgbsoGMIAJvYjgUywKfHOPHo1Tp6D6GJ
3EraF48FDIceOqpJNIbcn5e4keuT8UsSgnTMuZOiZnP/6f9oTtY/7xvuZlnCqGJi
BH/Ai/iv9nw1QGA2laV5ZUAQp/ZnCHKXLBAPVIJRp4U1NRf2pU+CDOdIrZFn5nJ2
hFo3CshB9W5zG9ARQD+8i4tv0EVpFRAofH06UADj5mUozsGwJXNeTb1Y4UQpcJU0
0QNUMTqPfSf3nOWAfbYJ9wRZ7prXWAG6c+j2iAOHchcoRl26kFSkZTmSgzORVNxd
rcoiP2GBf7LTZuueHJEoXSTZ4qrfqJMFSZ38TOFbAG8Qk9aws8Pt8S0ZJ4oPEqk=
=uUJm
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Nov_2010_11_23_52_+1100_T4alB4AQUvpqCt0z--
