Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0KJCYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:24:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35487 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0KJCY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:24:29 -0500
Date: Wed, 10 Nov 2010 13:24:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20101110132420.fe81e1b0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_13_24_20_+1100_31pWY8JIIh+oNZxm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Nov_2010_13_24_20_+1100_31pWY8JIIh+oNZxm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/bcm/Bcmchar.c between commit
eccbf04a904fc99c54ab37c29a2a4dedcec66e33 ("Staging: bcm: use get_user()
to access user pointers") from the staging.current tree and commit
ada692b09f4707a8e06b087b1546d9f5b3f2d37d ("beceem: fix character device
ioctl") from the staging tree.

I just assumed that the latter supercedes the former and so used the
staging version of the file.  I may well be wrong in this.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Nov_2010_13_24_20_+1100_31pWY8JIIh+oNZxm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2gJUAAoJEDMEi1NhKgbsszkH/2dSo04iH+VbsgkoU4aDFdMz
3EugRCI9svm6WMddzMHzMIe0Xmp4sV6DBcVVhFwq4L0t3zMW8xz/DdVH0Qanjmu8
nUN3HwZA4zA6QLgaubBUUrtFHFZuveXARJrZ7ssf0q6T9jSuC5VN0FJghmNATCqh
u6chQEHirqWrIrQikj8kbNp/RlWcJKNnC9Kgx/2QJ/83qXrjnyhkbDDs6ecsWRAc
/NwW4/QF+9498qoXOmhEMO74lXmkqtODGKcNFsHCZINi0su/9oVRuSh+6T/UCOxf
tSXk44w5oy1b396OMUVpd2QYSV4ZLAQNMgiLVSfgfv0Km1HmIfVXR4vSAcFQduM=
=oqEM
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_13_24_20_+1100_31pWY8JIIh+oNZxm--
