Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2DYKAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:00:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781Ab2DYKAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:00:02 -0400
Date: Wed, 25 Apr 2012 19:59:56 +1000
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl-regulator: Allow CONFIG_TWL4030_ALLOW_UNSUPPORTED
 to be requested.
Message-ID: <20120425195956.5b3d9c2a@notabene.brown>
In-Reply-To: <20120425082417.GE3195@opensource.wolfsonmicro.com>
References: <20120425122924.0f08f5dc@notabene.brown>
	<20120425082417.GE3195@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_Qzle9k_giEE7dsH=bvucM5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_Qzle9k_giEE7dsH=bvucM5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 09:24:18 +0100 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Apr 25, 2012 at 12:29:24PM +1000, NeilBrown wrote:
> >=20
> > twl-regulator.c changes behaviour slightly depending on
> >   CONFIG_TWL4030_ALLOW_UNSUPPORTED
> > However that config option is not currently listed in any Kconfig
> > file.
> > So add the option to allow it to be chosen.
>=20
> Shouldn't this be hidden behind _EXPERIMENTAL and/or enabled by the
> board in platform data/device tree?  Kconfig feels like the wrong place
> to do this sort of configuration.

That make sense - but I cannot find a good place to put the flag.
TWL doesn't have any twl-specific platform data, it just uses
struct regulator_init_data.  I don't suppose it would be acceptable
to tuck an 'allow_unsupported' flag inside 'struct regulation_constraints'?

I'm not sure how else to do it without fairly major surgery.

Thanks,
NeilBrown

--Sig_/_Qzle9k_giEE7dsH=bvucM5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5fLHDnsnt1WYoG5AQJlLg/+P5sVuRe4ni69jvR33GA0V0GSyPSGTMvE
YRqfIcdQMy67KcwxN62brB/COKdpBeCOwNJqq0c8Ybqkd0fE+i9W3zprVp3SziJI
dQJdNQMHmogVKpX1RiznzEBfxVS+Dx/W6Pi5SnyGaktcwkMpvk0G8lH8PhG/BXyz
0eWu7DUV7EPaskAvBje8igw3m9YNNPzCUjMOLTj8h+MsPleTTPcal38Q3BZ+h6bR
KrvjZqcV+tpO7R7id2kGTkr+1DUD0dtrUa3Vo9gEYXGwQjODa1JtDebv6lHFqCyq
Sf+Zkp+8vaM/SozshbojfzstQq9sHi1iw4VD1KNfUNk2AqmGgpPEtec0K1IV5wvi
ydM5+gXkp/WiBGX1aNMgTo2XgbBeGKWJ+BoEDsuMXAMXSQAI+rkwaOVj9GlJoK3p
jhrzpvGsaFQ09s1hq/ea2FrhY/mr4+nyFBdPWcFNNf+dvfVcdqVYZHAmkMwjhkUY
bCkY4+JXRmb5o0SMvaMXIYW3La+CgLjPRfl4U1f5D+TT0r0zyHfITHlTKcfXUoQj
j9Un3hgniKc3ehghQAlNablmLEuNvq1144j0bm8bumusok3aqv+N1nvcyBbjIMKG
FVpwBrC9ipNoqRTutarlVQPxdHpvyCljtzF11D0b5wqykb/3Fd18a228W2kfuhtQ
e7so0HvXY04=
=vmuf
-----END PGP SIGNATURE-----

--Sig_/_Qzle9k_giEE7dsH=bvucM5--
