Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2GCKBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:01:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2GCKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:01:01 -0400
Date: Tue, 3 Jul 2012 12:00:49 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120703100049.GA8455@avionic-0098.mockup.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
 <201207030806.49561.arnd.bergmann@linaro.org>
 <20120703081138.GA25183@avionic-0098.mockup.avionic-design.de>
 <201207030859.11975.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <201207030859.11975.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Hi97pPlE00/rkwqi0Ag4N68Q+IxrzYeMMjnSrwrD73m
 LKXaupF2IEaJ+MndZRmh/trR6THa5SauPa/jW1MFrImu03jYeV
 II7GTaphkwF2tiQ5l5yrK4+3/xwVcirf19L9SlpPXAECKuLsU+
 MxbzRT958T4RG307I8xLVcajsZgNNGiZ4sfQ3jOmx54UiQ6l+3
 0kI0hC2MLTtxgO3QA5+FLD23TwpcwthY1FHGXzYjHlL3frEqd/
 yfxKK+gaOVZ2Vxk9ejwJp6Ix1jxqz6TYOZ6XOIZmzMUeKG8ijO
 y83xrTo5zb143VynCIgZ99v1+AiBKlrNyk0TwATseqn2mS53L1
 8lTIZennnekHjChJC+fnrSEcDz3xohwRD9Kh0Abq5tEDtX54g6
 tGZu2gSq9zMoigFh/b0qlw9kUBMDXiCgEI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 08:59:11AM +0000, Arnd Bergmann wrote:
> On Tuesday 03 July 2012, Thierry Reding wrote:
> > I came up with the attached patch. What do you think? It fixes the
> > PowerPC allyesconfig issue for me.
>=20
> This one looks correct, but I would still do it the other way around,
> putting the depends statements into the locations of the other drivers.
> The main difference is that we can then independently convert the
> remaining drivers, without having merge conflicts in the same line
> every time we remove one of the dependencies.

The downside of that approach, however, is to make PWM override other
settings. For instance if you have TWL6030_PWM selected and then decide
to also select PWM, then the former will be automatically deselected to
satisfy the dependency. I'm not sure if that's desired.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8sLRAAoJEN0jrNd/PrOhfnsP/jhU4fXJpS831+3XsUGoyFHk
xsfSqbT73oWrxao+hv/i3Ni8zS7o6DGR72bllYTzK6XUcVNJz8ibPW3R4EWTsKlX
OTyR6s7KYixP0+iz/Yx0vPoOPmzED6OZIgUmC88/60ykFdzSv3/aHIP0F7aYDK5/
9OqvvrC2Tagkm1sEzLSUm10i7KKaCvZ7YFJzy3AvcRl3Kz3v2zZVPDmAbKZmgj9c
y1NC0IE/2S9uqHhrnDFiqv4Gp6kRrDi3rEy1zuV8EfSlNATFdzZMvUFpbGx//Fql
U14CsS8K9DqdjlePnwMv4V+IiUokdq3jomoWSs325eI6sX9rNaGDiR/5lkZjzjbP
lI585Vrh04Oh25EVqn3mjXkN5qff1hG8TSpApKW0weX3e+j9HFAcbX1M2gIv+aGq
gPhR/rLrPtMn7w/7VVHEGHaDhKI76hH/Z1o9dKcieLilKSpZ6JF+E2Aj2nO8IKn0
FTE57cQKMCCPurt+kaMqh6zMPS9JL3qo97n0cvAJ1O/quZ4m56Ns4mID0pRxMxz8
QOFr8cKKpCQBaXBSD8NIg2fYDA0huOJD7mgijeTih5X1tlKFQoiW8O64PpMBTe7T
j9+pFIKh5TyaRfKNjpCAjWNvo1AeBhOI1/UHoyi5iEzE8/9yQGxbeqO+gqa8hiw9
Bvcmr+kUKIT5hN1n9snq
=FN0x
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
