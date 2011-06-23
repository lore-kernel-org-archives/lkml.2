Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab1FWL1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:27:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56203 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724Ab1FWL1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:27:46 -0400
Date: Thu, 23 Jun 2011 21:27:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-Id: <20110623212736.74bea79a.sfr@canb.auug.org.au>
In-Reply-To: <20110618183029.822f4d82.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
	<20110618183029.822f4d82.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jun_2011_21_27_36_+1000_2f_Z6tbGdKuQCEG6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jun_2011_21_27_36_+1000_2f_Z6tbGdKuQCEG6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Sat, 18 Jun 2011 18:30:29 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 15 Jun 2011 11:19:48 +0200 Geert Uytterhoeven <geert@linux-m68k.o=
rg> wrote:
> >
> > Would it be possible to build with `make -k', so it continues in case
> > of an error, and
> > tries to build as much as possible?
> > Yes, I know this may increase build time considerably, but in an ideal
> > world, there
> > are no compile errors and everything is built anyway ;-)
>=20
> Done (I think - it required very simple changes to a Python script and I
> only do "monkey see, monkey do" Python programming :-))

I also made the mistake of fixing things so that the automatic "git
bisect for build failures" would work.  That was taking much too much
time (over 4 hours for one build), so I have turned it off.  Hopefully,
the builds will now run in a more reasonable time frame.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jun_2011_21_27_36_+1000_2f_Z6tbGdKuQCEG6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOAyMoAAoJEDMEi1NhKgbsXcoH/0mQD3wYpYAOXSdnYydgrRov
4d8dpk6E/eV5vsch9u1jWMXc0DdRzw/3MbiP14erv3HsGuGsCy55oKnoP+p9UIvP
TVFHfcXbPHZkiR5RK33pUcMWTyRAThxdh8bp+P9mdE+LI2WcmsPL0Us6Oux7SEmj
oj1/qaDz8EUAzfdJ8jJDNWm3tcZxNlIJEhrHjnFReu2nfyDTsXJ8KNZKkLEUFvjp
SI+aK2o+HvJiySIjJOWf1yS5enb3LMY+zHEuYUrBBB752AK5xruRYUMcBhDEOg1C
Y9Bc3Wo9x0JtOacS3fRWZZcMihhHNNCBRTut4IZnhng65OW1uCZPrB9FulzXvfM=
=1Bls
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jun_2011_21_27_36_+1000_2f_Z6tbGdKuQCEG6--
