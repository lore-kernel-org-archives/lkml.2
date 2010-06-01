Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0FADLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:11:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54619 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0FADLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:11:53 -0400
Date: Tue, 1 Jun 2010 13:11:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the rr tree
Message-Id: <20100601131147.4c2de43b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jun_2010_13_11_47_+1000_Lv/tyLO7cYb8uJyR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jun_2010_13_11_47_+1000_Lv/tyLO7cYb8uJyR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/module.c: In function 'SYSC_delete_module':
kernel/module.c:787: error: label 'out_stop' used but not defined

Caused by commit b50e0d273194c53851fbf6d119047a9b742c49c6
("module:reduce-locking").

I have used the rr tree from next-20100531 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Jun_2010_13_11_47_+1000_Lv/tyLO7cYb8uJyR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwEenMACgkQjjKRsyhoI8wSMACgrOlCKMrouEK2kmX/6clJJZKJ
cMMAn1utsYA09fwgVKpIo2zz8xuVm9O1
=4Z9b
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jun_2010_13_11_47_+1000_Lv/tyLO7cYb8uJyR--
