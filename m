Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0CWDJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:09:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34995 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab0CWDJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:09:53 -0400
Date: Tue, 23 Mar 2010 14:09:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the kgdb tree with the input tree
Message-Id: <20100323140946.b56c1d8b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Mar_2010_14_09_46_+1100_Ak6j9.Is96R_8W.T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Mar_2010_14_09_46_+1100_Ak6j9.Is96R_8W.T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the kgdb tree got a conflict in
drivers/char/keyboard.c between commit
edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("Input: implement SysRq as a
separate input handler") from the input tree and commit
4e4b600bf7160c11893bc3f4f8da8a70777b23ba ("When issuing an alt-sysrq-KEY
sequence with the keyboard driver in the")
from the kgdb tree.

The latter changes code moved to another file by the former.  I don't
know how to fix this up, so I have just effectively reverted the kgdb
commit for now - suggestions welcome.

BTW, the author of that kgdb commit is "Jason Wessel Subject: [PATCH]
<jason.wessel@windriver.com>".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Tue__23_Mar_2010_14_09_46_+1100_Ak6j9.Is96R_8W.T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuoMPoACgkQjjKRsyhoI8wXAACfRS3evzQSCBmt4nasxDm7jhDG
/x0AnRyoJH14ytaXwkMcEg0GUU7AgR++
=ag0C
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Mar_2010_14_09_46_+1100_Ak6j9.Is96R_8W.T--
