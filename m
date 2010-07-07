Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0GGBcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:32:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45724 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0GGBcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:32:15 -0400
Date: Wed, 7 Jul 2010 11:32:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
Message-Id: <20100707113208.02e49474.sfr@canb.auug.org.au>
In-Reply-To: <201007062029.34535.rjw@sisk.pl>
References: <20100705214304.GA24291@sepie.suse.cz>
	<201007062029.34535.rjw@sisk.pl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Jul_2010_11_32_08_+1000_CssBD.s7oT2CjEtV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Jul_2010_11_32_08_+1000_CssBD.s7oT2CjEtV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Tue, 6 Jul 2010 20:29:34 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> On Monday, July 05, 2010, Michal Marek wrote:
> > On Mon, Jul 05, 2010 at 11:25:56PM +0200, Rafael J. Wysocki wrote:
> > > Hmm.  Am I dong anything particularly wrong, or is CONFIG_LOCALVERSIO=
N ignored
> > > now, as it seems?
> >=20
> > (also reported by Stephen earlier that day)
> >=20
> > On Mon, Jul 05, 2010 at 10:39:41AM +1000, Stephen Rothwell wrote:
> > > After merging the libata tree, today's linux-next build produced this
> > > warning (but it should be a failure ...):
> > >=20
> > > /bin/sh: scripts/setlocalversion: No such file or directory
> > >=20
> > > Probably introduced by commit 0a564b2645c8766a669c55bde1f1ef5b0518caec
> > > ("kbuild: Propagate LOCALVERSION=3D down to scripts/setlocalversion").
> > >=20
> > > That commit really isn't ready for inclusion in Linus' tree ...
> >=20
> >=20
> > Oops, I'm an idiot. The below patch should fix localversion again:
>=20
> Yes, it helps here.

I also applied it to linux-next yesterday (in my fixes tree) and it
solves the problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Jul_2010_11_32_08_+1000_CssBD.s7oT2CjEtV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMM9kYAAoJEDMEi1NhKgbsKfQH/051xVC8jaz0Zy5vJC4v4K0a
RSHEMEjCEtOyUdgOewFUdxpCCnpEKfKisOwpg1o5kugpZy20G5u3odqumFStWrUV
OqQgUYdt+myJmf2DBtTqXEdIibq+jFVFMGEngNzCZottWWiJgTe6hN7BfRjPG01Z
UTuc3Gv4ra1vsMqGw3rE0VG5pRn6tRCWe2/tUiQz1oWinM0tXt24SeKdmVCLSqlU
X6ATzO1Md5aUxHhi3qJg9cjYbZtgySYr0X2+SiDfD/onk8aLeqV7H/8XWZ+ImNez
5jpKLyKptq+NwtiVVzLO2B+ndLOSLSGsXf6KQ5+R5rZJ0BfNIyeyKMRZ+8VDDrs=
=PP92
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Jul_2010_11_32_08_+1000_CssBD.s7oT2CjEtV--
