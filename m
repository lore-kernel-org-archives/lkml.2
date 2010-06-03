Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab0FCBsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:48:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48635 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab0FCBsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:48:22 -0400
Date: Thu, 3 Jun 2010 11:48:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the rr tree
Message-Id: <20100603114815.08387225.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Jun_2010_11_48_15_+1000_ujo4rpxT.QbgkbWx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jun_2010_11_48_15_+1000_ujo4rpxT.QbgkbWx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/module.c: In function 'load_module':
kernel/module.c:2407: warning: 'hdr' may be used uninitialized in this func=
tion

Probably introduced by commit 601b979485d01750ea17cf138e209d81acfe63b5
("module: refactor load_module part 3").  Its a false positive :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Jun_2010_11_48_15_+1000_ujo4rpxT.QbgkbWx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwHCd8ACgkQjjKRsyhoI8ygQACfTx0gipgeKmetAAEU1zs93kJm
PdQAn211IkXpFdoki3Of9oCmOI/jSQ8i
=5fnE
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jun_2010_11_48_15_+1000_ujo4rpxT.QbgkbWx--
