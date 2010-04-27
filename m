Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0D0FGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:06:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35660 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0D0FGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:06:12 -0400
Date: Tue, 27 Apr 2010 15:06:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkZyw6lkw6lyaWMgV2Vpc2JlY2tlciI=?= <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the bkl-ioctl tree with the bkl-procfs
 tree
Message-Id: <20100427150604.2ad0b3fe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_15_06_04_+1000_MOIoqftT.bxhJO1f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_15_06_04_+1000_MOIoqftT.bxhJO1f
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fr=C3=A9d=C3=A9ric,

Today's linux-next merge of the bkl-ioctl tree got conflicts in
drivers/char/i8k.c, net/sunrpc/cache.c and
drivers/isdn/divert/divert_procfs.c between commit
64ef834551d7696f54553d7608eba80a5a800e77 ("procfs: Push down the bkl from
ioctl") from the bkl-procfs tree and commit
1dd97d3d546aa14db7efa5366b21d1336b91379e ("Rename 'struct
file_operations' 'ioctl' fn pointer to 'bkl_ioctl'") from the bkl-ioctl
tree.

I used the versions from the bkl-procfs tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_15_06_04_+1000_MOIoqftT.bxhJO1f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWcLwACgkQjjKRsyhoI8zfbACgmdLPe8b3W3qqK7oGhDItvGSN
DvIAoLvfoT5N2eajFYo4+Qd5bs0epNn7
=rFYQ
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_15_06_04_+1000_MOIoqftT.bxhJO1f--
