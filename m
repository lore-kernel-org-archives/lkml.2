Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0GZBvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 21:51:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56567 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0GZBvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 21:51:14 -0400
Date: Mon, 26 Jul 2010 11:51:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: linux-next: build failure after merge of the xfs tree
Message-Id: <20100726115107.3c3b7303.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jul_2010_11_51_07_+1000_rYI3M=J/5F3ceXga"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jul_2010_11_51_07_+1000_rYI3M=J/5F3ceXga
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

After merging the xfs tree, today's linux-next build (powerpc ppc64_defconf=
ig)
failed like this:

fs/xfs/xfs_inode_item.c: In function 'xfs_inode_item_format':
fs/xfs/xfs_inode_item.c:319: error: 'nrecs' undeclared (first use in this f=
unction)

Caused by commit 0fd7275cc42ab734eaa1a2c747e65479bd1e42af ("xfs: fix gcc
4.6 set but not read and unused statement warnings").

I have used the version of the xfs tree from next-20100723 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Jul_2010_11_51_07_+1000_rYI3M=J/5F3ceXga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTOoLAAoJEDMEi1NhKgbsujYH/2MB9XkyGEwo7hdr71ETfkHW
N3vf5ZTZA0xv96geUS7mKme3FU2zBH6A4KcB4FSOCpz9tBBQNikPVghU+x7YY7GB
KDo+yxHvlklK0ZgJ1M/GUtPZuZNtbahHLe8aBk7aDsOKNUOF6VbEwr14RsMDRDhW
sZ+OADaxoo2FnFXfmeHwZFEya8Fsh9mceb/FSzhD64N3ynO6rGnD/pzhzs5K/6uZ
k2BggHWOhwZLgewIHX4XTTzmBIDEiY28cVfgWAGMycAyP27XqcL79JkBmNPbpHTg
B0qJYQy3y4NjSHajVCjOywdljsszi1u6DB9nShe41jl/PaJhRmnC3Ho3IxQB208=
=MTn+
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jul_2010_11_51_07_+1000_rYI3M=J/5F3ceXga--
