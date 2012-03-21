Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2CUK3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:29:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab2CUK3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:29:06 -0400
Date: Wed, 21 Mar 2012 11:28:47 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bernhard Walle <bernhard@bwalle.de>, Bernhard Walle <walle@corscience.de>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
Message-ID: <20120321102847.GA13630@avionic-0098.mockup.avionic-design.de>
References: <1332262083-9375-1-git-send-email-walle@corscience.de>
 <201203210839.06258.arnd@arndb.de>
 <20120321084856.GA17472@avionic-0098.mockup.avionic-design.de>
 <201203211003.28019.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <201203211003.28019.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:m/Aiba9OgABaL0ovKFLLDohha0Fviw93Msudq/C3M2g
 MhbuWgMXWvr1tsaCty6KR0vVwAu5LTWpjx+Sk8+HrelkIkbWx2
 hNwWQNf3cHCfDVAQgZ0U0Ucyk4ANNwXwetU2scI2iypuP+oADs
 aie3cJDiMX2Q+jMcCNr0RyRfePhRUYQ+unwwdmsmw1C7JInh6F
 ZjQ/+GxCyAo1Mt2oFxpp0thFlLk3mSiULrnSnAs264t/N4m2ay
 rZ3DD0Gv8VFfbjsK2yp2lp6p9H5q6t7CLGC2Z6/SmsfhSsfBxM
 0KsiSR7pqN+bDrw8dznRxgouC2tGNIrf06F6nGuhpvdd+Q4SHS
 cUOI5jmRzJ44/w3iRdAtzALTaoaCv31IQ4v2J3myTun3+uaNYh
 r+oZVVlz8B8IPnFgAprHsyb8unjfP6WYbk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Arnd Bergmann wrote:
> On Wednesday 21 March 2012, Thierry Reding wrote:
> > I don't have a public tree anywhere. Does anyone have a recommendation =
where
> > I could set one up? github or gitorious are the first to come to my min=
d.
>=20
> They both work fine and are easy to set up, at least as a temporary locat=
ion.

Okay, I'll check both and will also investigate whether one can be setup on
our domain.

> If you want to have something more official in the long run, you could
> either set up your own git server on your employer's domain or if that
> is impractical, get an account on kernel.org or linaro.org. Both of those
> try to limit the amount of accounts they hand out to external people, but
> since you are going to be a subsystem maintainer, I don't see it as a
> problem.

Maybe Sascha should have a say in this (adding to Cc). He wrote the original
code and got the ball rolling, so I don't want to jump the queue. If he's
okay with it, though, I'd be happy to take over.

Thierry

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9prV8ACgkQZ+BJyKLjJp/pZwCfTWxWDUw/klAgt72xDBDK7ogA
+mEAn22Vva/mN7pZQkA82AQGPmHWfZSC
=3es7
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
