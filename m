Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1LGIxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:53:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab1LGIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:53:45 -0500
Date: Wed, 7 Dec 2011 09:53:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Ryan Mallon <rmallon@gmail.com>,
        Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20111207085339.GA7970@avionic-0098.mockup.avionic-design.de>
References: <201106301441.24493.arnd@arndb.de>
 <4E11994B.7070103@gmail.com>
 <20110704124318.GI6069@pengutronix.de>
 <201107041607.10265.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <201107041607.10265.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/359QgSEJWWgSf5R/aOZTQb8xKm5ZeTKZU1gd3+12o8
 iZEeppqNMEwiqzYLe/l9kT+8/DHNZeQwvKZcOMGkslF0zXtQr3
 sdnUB3ucVdtQ5Z2rr1AYTsuiiE7oY9goBdYQhAjwEWL6hCLKhF
 sX4Lt8iR7zGSqy8AzomF1RnFsQxvjFxnWJPbPWfebX0z5ciRSs
 Lftfx69R8mPccl/ap0ClaDe+jmhdMTkeffiEGdQS5NiJrgpXO3
 8NiL1g5V96CEFNiw/Qxo7RJhC3x2O5f0NNevce8Zoq0pONjvdD
 xApRRL6ufKk6Qdf8BZhbxusI8vopTbT700t2flcZl29QMknMPC
 IsyIproAXlxSLPpOPYy9p92iRt5rgr719omdEozPRhpLhA3Wmb
 hVz4/lo2TEMrXT+kVj9nNumHJLQlZAbMk8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Arnd Bergmann wrote:
> On Monday 04 July 2011, Sascha Hauer wrote:
> > On Mon, Jul 04, 2011 at 08:43:23PM +1000, Ryan Mallon wrote:
> >
> > > The fine-grained control api could be added now. pwm_config could be
> > > left as is for the time being (the new api could be a wrapper around =
it
> > > to start with). Polarity control and interrupt handling apis could al=
so
> > > be defined without affecting the drivers which don't need to implement
> > > them. Multiple channels and the sleeping/non-sleeping api are the more
> > > difficult ones, but at least having some sort of indication about how
> > > these plan to be solved would be useful.
> >=20
> > Again, why should we add these *now*? It only raises the chance that
> > there's more discussion.
>=20
> My impression is that there are a lot of things that could easily be
> done to improve the state of PWM drivers, but I don't care about the
> order in which they are done. My main issue is the lack of a subsystem
> core driver, which both you and Bill have patches for. It's clear that
> other people have other issues and want to see their problems addressed
> first.
>=20
> I also think that the pwm code is simple enough that we don't have
> to worry too much about the order that things are done in. Any patch
> that is making the code better should just get in and not have to
> wait for something else to be completed first.
>=20
> What we do need now is a maintainer that can coordinate the patches
> and merge the ones that have been agreed on. Or multiple maintainers.

Hi,

I'm looking at adding DT support for pwm-backlight, and I think a central P=
WM
API will be required first. Looking through the archives this seems to be t=
he
last activity in that direction. Perhaps we can get the efforts restarted?

I pretty much agree with Arnd and Sascha here in that we should try to get a
basic framework added. Everything else can be added on top later.

Thierry

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7fKZMACgkQZ+BJyKLjJp8X9ACeMUoyMBI+beoK+DOSOu73b9pu
WbAAnjDi7EuFCmknzhVYoAUS2Pkn9kTm
=F20m
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
