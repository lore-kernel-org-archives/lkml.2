Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0IPCEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:04:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56946 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPCEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:04:50 -0400
Date: Thu, 16 Sep 2010 12:04:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with the Linus' tree
Message-Id: <20100916120440.f3fdcbda.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_12_04_40_+1000_.PGR7eW5iQEIXGeW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_12_04_40_+1000_.PGR7eW5iQEIXGeW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/block/loop.c between commit
5e00d1b5b4c10fb839afd5ce61db8e24339454b0 ("BLOCK: fix bio.bi_rw
handling") from Linus' tree and commit
6259f28459a9de820f47a9ece4ffa22d4596a9af ("block/loop: implement
REQ_FLUSH/FUA support") from the block tree.

I fixed it up (the latter removed the line that the former changed) and
can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_12_04_40_+1000_.PGR7eW5iQEIXGeW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkXs4AAoJEDMEi1NhKgbsXXoH/jN3l+Ay9CEbY2/gttzBdhet
uUFSKkxqb1NPOJ7XkkPDd72XeLq61GkXNJ/qHSEnK/+ET6nddu+MgSUl232tU9rT
oTnFIZcNnQTTNFhVBUiHrsewEnjUe9G32eMZwEQ0oZe1IJhh54RxAK8mH20M9r3s
JEX4stSxprqozciS4mAsmp3pMPEhqcWgXEV7pwHfO4krBSHv/QQ/pAY92107F5Kc
V+tEQLx9LMLYf66vRvdEeCISfYoI9ioktm8ZflM6YuVlgCnWW/R950da+bNZ1s7L
+X+7yMetNqVWHXKG6oIrmCMCe/rhPATtiWLjljILKyIuAOkm0SsUeZjYdKRHid0=
=wR2T
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_12_04_40_+1000_.PGR7eW5iQEIXGeW--
