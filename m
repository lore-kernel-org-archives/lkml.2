Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab1HODPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:15:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41137 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1HODPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:15:30 -0400
Date: Mon, 15 Aug 2011 06:18:33 +0300
From: Sergei Trofimovich <slyfox@gentoo.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Marek Belisko <marek.belisko@gmail.com>,
        Ondrej Zary <linux@rainbow-software.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ft1000: fix build failure
Message-ID: <20110815061833.39bc5034@sf.home>
In-Reply-To: <20110814222351.GA12930@suse.de>
References: <1313355177-12605-3-git-send-email-slyfox@gentoo.org>
	<20110814222351.GA12930@suse.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0kTGnIzCWQM1GuN0oj/6Kcy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0kTGnIzCWQM1GuN0oj/6Kcy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Aug 2011 15:23:51 -0700
Greg KH <gregkh@suse.de> wrote:

> On Sun, Aug 14, 2011 at 11:52:53PM +0300, Sergei Trofimovich wrote:
> > Found on allmodconfig build (ARCH=3Dalpha)
> >=20
> >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_=
read_reg':
> >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80: error: implicit d=
eclaration of function 'inw'
> >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_=
write_reg':
> >     drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86: error: implicit d=
eclaration of function 'outw'
> >=20
> > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> > Cc: Marek Belisko <marek.belisko@gmail.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Ondrej Zary <linux@rainbow-software.org>
> > Cc: devel@driverdev.osuosl.org
> > ---
> >  drivers/staging/ft1000/ft1000-pcmcia/ft1000.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> This, and your other patches, are all not necessary in Linus's tree
> right now, right?  I thought I already sent them to him.
>=20
> Or am I mistaken?

Oh, some of them really are. My apologies!
Only the one (nonstaging one) is still needed:

    'pti: fix build failure'

Thanks!

--=20

  Sergei

--Sig_/0kTGnIzCWQM1GuN0oj/6Kcy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5IkA8ACgkQcaHudmEf86owlwCdEhOT9hxpXuM5HqgOMTxbIIhs
Q08AmgOpA2JecN0Hryl+34+iZbadNj5G
=mWak
-----END PGP SIGNATURE-----

--Sig_/0kTGnIzCWQM1GuN0oj/6Kcy--
