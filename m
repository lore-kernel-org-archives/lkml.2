Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1KPRLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:11:06 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45337 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1KPRLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:11:04 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: update maintainers for blackfin arch and drivers.
Date: Wed, 16 Nov 2011 12:11:02 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: uclinux-dist-devel@blackfin.uclinux.org, Sonic Zhang <sonic.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com> <201111161020.53989.vapier@gentoo.org> <1321461375.16820.7.camel@Joe-Laptop>
In-Reply-To: <1321461375.16820.7.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1430709.s52lrfzv7F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111161211.03784.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1430709.s52lrfzv7F
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 16 November 2011 11:36:15 Joe Perches wrote:
> On Wed, 2011-11-16 at 10:20 -0500, Mike Frysinger wrote:
> > On Wednesday 16 November 2011 08:12:06 Joe Perches wrote:
> > > On Wed, 2011-11-16 at 15:48 +0800, Sonic Zhang wrote:
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > >=20
> > > >  BLACKFIN ARCHITECTURE
> > > > +M:	Bob Liu <lliubbo@kernel.org>
> > > >  M:	Mike Frysinger <vapier@gentoo.org>
> > > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > > >  W:	http://blackfin.uclinux.org
> > > > =20
> > > >  BLACKFIN RTC DRIVER
> > > > -M:	Mike Frysinger <vapier.adi@gmail.com>
> > > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > > >  W:	http://blackfin.uclinux.org
> > > >  S:	Supported
> > > >  F:	drivers/rtc/rtc-bfin.c
> > > > =20
> > > >  BLACKFIN SDH DRIVER
> > > > -M:	Cliff Cai <cliff.cai@analog.com>
> > > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > > >  W:	http://blackfin.uclinux.org
> > > >  S:	Supported
> > > > =20
> > > >  BLACKFIN WATCHDOG DRIVER
> > > > -M:	Mike Frysinger <vapier.adi@gmail.com>
> > > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > > >  W:	http://blackfin.uclinux.org
> > > >  S:	Supported
> > >=20
> > > Drivers or arches without specific people to maintain
> > > them really should not have "S: Supported".
> > > These should really be "S: Orphan".
> >=20
> > all the drivers are still maintained.  use the L: option to find the
> > maintainer.
>=20
> I believe I know how the MAINTAINERS
> entries work.
>=20
> From MAINTAINERS:
> 	M: Mail patches to: FullName <address@domain>
> 	L: Mailing list that is relevant to this area
>=20
> Mailing lists aren't maintainers.

they contain all the maintainers

> Maybe Analog Devices should create
> an email address alias like
> linux-devel@analog.com

so we should duplicate the ml into an alias to keep MAINTAINERS happy ?  ma=
kes=20
no sense.  use the ml.

> btw, from blackfin.uclinux.org:
>=20
> -----------------------
> We are moving the open source help forums for u-boot, GNU Toolchain and
> Linux for Blackfin to the Analog Devices' EngineerZone since Oct.24,
> 2011.
>=20
> These old forums will turn to readonly after Nov.1st, 2011.  Please only
> ask new questions in the new Engineer Zone communities after the
> launching.
> ---------------------
>=20
> So maybe the support links should be:
> http://ez.analog.com/community/dsp/open-source/linux-blackfin

no.  the ml/trackers/source/etc... are still on blackfin.u.o.  only the for=
ums=20
have moved, and generally the people sending patches aren't using those.
=2Dmike

--nextPart1430709.s52lrfzv7F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOw+6nAAoJEEFjO5/oN/WBQWwP/2zg+LrAcyUTJRTmMfBniSB8
ikM6ALaB38IgR5jjyG3Dx41Q1x6XNp+v/stNL56T4CItGKa3SJTcTf1Leq22gVRA
wJX8R7cMjTl+hYWmAY0vTS4Bx5uVLYm9xs3MdWwjzHY++JldQWhRY57TE1xI0/MW
DYpi0UABnPOiTZyohuMUZeLnsQ+GZCTjQSsVhve6zDZ72MFVnfWUuSJmxZ/rz8Q2
Q/cr/ObTryR4SI4DsAhM42boyHhVwVyUna30L6Jt2qXS0QEMgv/DkqmjiRWEWnuY
wE49Ye9eywhSTqb6kT0mV0PeZSzTWY3CYmpFZY6iDwBbNHYQYxMLE1fp464ogS2Z
C+kFsqcpYnzpxWhHkqBPhQmaLonD1IxNkjrxcqR57bHxQbjYKXPwrPa3zsTvW/oi
uolldX9uC+7kzBP6qB/Y+fGrUzIJDP9KxI20B4VJDJ7XopnjXTgNYddFObAKvEyM
LeQk5EgDMOqu3rE1t12h2tYOS35ppyCbKiAto3xCUTKmunBKPKJtIWZwuuyQ1GjB
YBHxesFQ8uTy4A3ziN1j4lM2uJuj3iDevDVhoGaDprAajO6x9XqIK3Ju2qDpxr57
WKjNUXjqvKcdV+2MtkOEHwxIzgHfWKZeZHScjn7PHtxav4o70zjM8dapp9tir5Xr
1chMamY6d83D48kCCDXm
=05gB
-----END PGP SIGNATURE-----

--nextPart1430709.s52lrfzv7F--
