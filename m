Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab0DLCku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 22:40:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34880 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0DLCkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 22:40:49 -0400
Date: Mon, 12 Apr 2010 12:40:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20100412124041.4876c3f9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Apr_2010_12_40_41_+1000_W.FPXz06whO31.NA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Apr_2010_12_40_41_+1000_W.FPXz06whO31.NA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/input/input.c: In function 'input_default_setkeycode':
drivers/input/input.c:691: error: 'keycode' undeclared (first use in this f=
unction)

Caused by commit df7ad46fc171965103f02649f6c2f02c6ca8b331 ("Merge branch
'master' of /home/v4l/bare_trees/v4l-dvb").  The merge resolution is not
quite right.

I have used the v4l-dvb tree from next-20100409 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Apr_2010_12_40_41_+1000_W.FPXz06whO31.NA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvCiCkACgkQjjKRsyhoI8wy8wCfV/y6TotPLZXMNF5+8AQ016l5
dHIAn2DTDe4WVT604UNfE73PqOK9pmGO
=ip0r
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Apr_2010_12_40_41_+1000_W.FPXz06whO31.NA--
