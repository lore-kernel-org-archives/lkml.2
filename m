Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0D0FGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:06:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35674 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0D0FGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:06:33 -0400
Date: Tue, 27 Apr 2010 15:06:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkZyw6lkw6lyaWMgV2Vpc2JlY2tlciI=?= <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the bkl-ioctl tree with my fixes tree
Message-Id: <20100427150629.cb526876.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_15_06_29_+1000_+Me6gW/=RL7jQ8l6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_15_06_29_+1000_+Me6gW/=RL7jQ8l6
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fr=C3=A9d=C3=A9ric,

Today's linux-next merge of the bkl-ioctl tree got a aconflics in
drivers/block/pktcdvd.c between commit
30d32c9015af1fa56795c5ba8d7d6635d6bef8bf ("pktcdvd: improve BKL and
compat_ioctl.c usage") from my fixes tree and commit
1dd97d3d546aa14db7efa5366b21d1336b91379e ("Rename 'struct
file_operations' 'ioctl' fn pointer to 'bkl_ioctl'") from the bkl-ioctl
tree.

I used the version from my fixes tree for today.

Arnd, are you going to submit this change to Linus sometime soon, or
should I drop it?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_15_06_29_+1000_+Me6gW/=RL7jQ8l6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWcNUACgkQjjKRsyhoI8xX3QCfXk0A9TDwBoPN/DozUYeA/F+f
jmsAnAiW1aDXMvNu0W3cg7B8alqL1ui1
=tXXe
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_15_06_29_+1000_+Me6gW/=RL7jQ8l6--
