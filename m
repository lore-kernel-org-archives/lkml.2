Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1FCBAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:00:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56875 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1FCBAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:00:19 -0400
Date: Fri, 3 Jun 2011 11:00:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>, David Sterba <dave@jikos.cz>,
        Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: linux-next: build warning from Linus' tree
Message-Id: <20110603110011.77121203.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Jun_2011_11_00_11_+1000_BtTQmfWZpU_HAv6x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Jun_2011_11_00_11_+1000_BtTQmfWZpU_HAv6x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
produced this warning:

fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used uninitialized i=
n this function

Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
operation").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Jun_2011_11_00_11_+1000_BtTQmfWZpU_HAv6x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN6DIbAAoJEDMEi1NhKgbsraEH/jvR27nO5ZyKBN/JOE+er9Yk
pia8ss+gu+alisTt9+Z0+X50czwRrfrsuAZtyB0h4OLVfJk+/+vMGJPVDYyDl/F2
Ppd9mvYpeocAfyk2nJh1EyYL6GNKI7D5TOcaBd/ta09CI3CC/y1VxDQpvCbPSd0G
vYpihGkNpGbfVPkR7zCJS7I4Ck6aXj/3gosSWQEGCwNRmZvIJ4+FoHIfB5vOnTnD
Fn8mIyLenMLx4n+10oSntXLEMzDaxaXH1B8DZgY9FoRzwldFsh44yslh/MbExGiU
4wGbwUCwQkEa2M/EwNZYS8+XDQGqfgdqZZAU6dJEiU+0lKChUXjYvTHDVYz4hBc=
=fR8R
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Jun_2011_11_00_11_+1000_BtTQmfWZpU_HAv6x--
