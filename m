Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935704Ab0KQXPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:15:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41995 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935456Ab0KQXPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:15:08 -0500
Date: Thu, 18 Nov 2010 10:14:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for November 17
Message-Id: <20101118101459.472d540b.sfr@canb.auug.org.au>
In-Reply-To: <20101117095920.2b9e2e6a.randy.dunlap@oracle.com>
References: <20101117140956.a8264c75.sfr@canb.auug.org.au>
	<AANLkTinBiGOPptOY18-D+=djKLsJj75mXxL6ht6xNJXL@mail.gmail.com>
	<20101117095920.2b9e2e6a.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Nov_2010_10_14_59_+1100_vI4p0LPVzqw8k4VC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Nov_2010_10_14_59_+1100_vI4p0LPVzqw8k4VC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Nov 2010 09:59:20 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> Why was #include <linux/smp_lock.h> removed from <linux/hardirq.h> ?
>=20
> I added #include <linux/smp_lock.h> to i387.h, but them mm/filemap.c buil=
d fails
> with the same error:
>=20
> linux-next-20101117/mm/filemap.c: In function 'iov_iter_copy_from_user_at=
omic':
> linux-next-20101117/mm/filemap.c:1936: error: implicit declaration of fun=
ction 'kernel_locked'

Was this fixed before Linus took that patch?  Also, the #include of
linux/smp_lock.h in linux/hardirq.h was the only line between #ifdef
CONFIG_PREEMPT and #endif ... was this patch even reviewed?

Maybe (after it was reviewed) it should have been given more time in
linux-next before being merged.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Nov_2010_10_14_59_+1100_vI4p0LPVzqw8k4VC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM5GHzAAoJEDMEi1NhKgbswGkH/i+IuOztcYLFtqM8YvdcwXdl
J+W0es+6sspbFryDrTeHo/7LqSj2sL06j4HQvd6V2eTCpfw6DXPLvHDO9Hiau31P
Yjm4HyId7/yVMRbwpu4/6NJohlSuT3302ho0pnZe+KrtHGz9+wm+b4S4PJqlLqIs
5JwnQwDxjhRf3T2rDrTd+6TaJ7PTA0C89ivWbuRqPC7t2Ms13728NhrTiwo4JSXk
RmrqanmirdEei4oA5RvHd7texwltkANEMfPQ2yaevALYUhHHOlHmcZY7RWITsUgG
TPS1Mpo++DfPAMvbq3+5fRRlbsVwfpPVG97/SQC0W7nvg3YIVuG9j8dvywuPko4=
=I7gh
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Nov_2010_10_14_59_+1100_vI4p0LPVzqw8k4VC--
