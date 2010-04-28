Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0D1GWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:22:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37122 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0D1GWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:22:16 -0400
Date: Wed, 28 Apr 2010 16:22:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?B?IkZyw6lkw6lyaWMgV2Vpc2JlY2tlciI=?= <fweisbec@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the bkl-ioctl tree with my fixes
 tree
Message-Id: <20100428162209.cc9b2487.sfr@canb.auug.org.au>
In-Reply-To: <201004271102.35904.arnd@arndb.de>
References: <20100427150629.cb526876.sfr@canb.auug.org.au>
	<201004271102.35904.arnd@arndb.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_16_22_09_+1000_2eMq+FtfqeF_=g5V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_16_22_09_+1000_2eMq+FtfqeF_=g5V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arndt,

On Tue, 27 Apr 2010 11:02:35 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> It's not clear yet how we do it. Ideally "pktcdvd: improve BKL and
> compat_ioctl.c usage" should find its way into -rc1 in some way, but
> we need to reshuffle the BKL removal trees to make that go in nicely.
>=20
> Where is your fixes tree? Maybe Frederic can take all BKL related
> patches from that into one of his trees.

My fixes tree is here: ssh://master.kernel.org/~sfr/next-fixes.git it
currently only contains your pktcdvd patch.  My understanding was that
this patch was a fix for a build problem with Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_16_22_09_+1000_2eMq+FtfqeF_=g5V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvX1BEACgkQjjKRsyhoI8yXQACguHlJxUTus4r2hBYK8GIIVONm
rR4AnRSjGbYRMoHm1OTbZ4ey1snLz4HI
=sQ8R
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_16_22_09_+1000_2eMq+FtfqeF_=g5V--
