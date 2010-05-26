Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab0EZXJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:09:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56707 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab0EZXJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:09:35 -0400
Date: Thu, 27 May 2010 09:09:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, matt mooney <mfm@muteddisk.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
Message-Id: <20100527090923.c17a7ed4.sfr@canb.auug.org.au>
In-Reply-To: <20100526095606.beed820e.randy.dunlap@oracle.com>
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
	<4BFD42A6.6060206@oracle.com>
	<20100527025020.da0c1bb7.sfr@canb.auug.org.au>
	<20100526095606.beed820e.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_May_2010_09_09_23_+1000_Z6PHGUsjHydyKpI4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_May_2010_09_09_23_+1000_Z6PHGUsjHydyKpI4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 26 May 2010 09:56:06 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> > The kernel-doc tree is a quilt series :-(
>=20
> Yes.  and it's viewable without pulling/cloning.  ;)

Ah, I shouldn't reply to emails so late at night :-(

> > You can, of course, see the above commit in the linux-next tree via
> > gitweb on kernel.org.
>=20
> Thanks.  Michal, I droppped these 3 patches.  Please keep them in the
> kbuild tree.

If anything, the kernel-doc patches should be kept as they are much more
extensive.  And the conflict was trivial.  The kbuild patch was just
fixing a typo (tey -> they).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_May_2010_09_09_23_+1000_Z6PHGUsjHydyKpI4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9qiMACgkQjjKRsyhoI8xDYQCfZnfaTbSOr8MyFyC5X5VxMFXM
5IQAn3DKfvppbR5msBLPs1m1oj9IRQTX
=W/bP
-----END PGP SIGNATURE-----

--Signature=_Thu__27_May_2010_09_09_23_+1000_Z6PHGUsjHydyKpI4--
