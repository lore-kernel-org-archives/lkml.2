Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2HANiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:38:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2HANiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:38:18 -0400
Date: Wed, 1 Aug 2012 15:38:14 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120801133814.GA19771@avionic-0098.adnet.avionic-design.de>
References: <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
 <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
 <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
 <20120731142607.GV4468@opensource.wolfsonmicro.com>
 <20120731143235.GA21126@avionic-0098.adnet.avionic-design.de>
 <20120731153941.GF4468@opensource.wolfsonmicro.com>
 <20120801074113.GF29673@avionic-0098.adnet.avionic-design.de>
 <20120801132651.GU11892@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20120801132651.GU11892@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IvmK9YhM1SEh+FI99y0tKGe6Fq4N+QVjtk+rK11eqR/
 NpbCJoAriIHRB01JIPzeDhYP3XGLIc8PttHVxttvUuS5IGvbHv
 vDHfJ7A9tjEgc97KZE/92OHziXImjdTrxF4T5IVteo6G/HEFSt
 bBs7WUIlNOuxNSRxiEF+Uqrxn+XW3pXJVZ24zBQcMm8Vm9BxU9
 9iAJEpq9Sc33s4qivPnHLDZH4e4JXBkfgDDy4Vum3ftHrp7gkB
 8p6Nu4S7igyZFRJtavG6+Ha6RdcwR+U4KfSxECVSIn/H2yLnx+
 RNfN3nn0cVzOYt9/cFzPFvJymkHYCHedmfFnpPAi52gx6oW+OY
 XDK/Owc9Kloe8suz6WKNGkbgVi6YGb5wPpGaRQnzKVcKEJD1yM
 eKcfvgQ2UhzBYo7IYkYK+n7oGHlyAFbwkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 02:26:51PM +0100, Mark Brown wrote:
> On Wed, Aug 01, 2012 at 09:41:13AM +0200, Thierry Reding wrote:
> > On Tue, Jul 31, 2012 at 04:39:41PM +0100, Mark Brown wrote:
>=20
> > > Sure there is - take a copy of the platform data in probe().
>=20
> > Yes, but that will only work for built-in drivers. If you unload the
> > module and that causes the platform data to be discarded, reloading
> > won't work.
>=20
> This is why __devinit data will only be discarded when this is not
> possible.

That's exactly my point. But I seem to have miserably failed to get that
across. =3D)

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGTFGAAoJEN0jrNd/PrOhN9QQALb2rZasbdKcdtx5OWeBu9B4
GE2sRXdQ08Rkr4gDbVIQqWd5oxwKw6biWwAOkbO38l0DBlfQ8H82Cg9BrWuxBzLK
oGNDb2f3DhhyvPcMrxKA369wlfpZd6OsHXI81Sg9Mez/H0CuqeU0MD9omEeJjLWg
DQCQ4f2w1CgaTdjxyQzHeU+u0Vnw0jNyi3og5QlEVNIIl2ntvIsrx1Ouif9bj8Di
Bg52fj1RqR4nBASVXKHGWHnK9bAdIUvIpv3nqxFt3a8Eqn7FtlhAdEVQZGAmLZD+
8yXvBhT7TMYUbzgqQyPLmNI9HFgObij3Ad5V88txVv9qY52AKg9QXYOossC4MPYw
1OsYfa4o8YZ5dh1IgzgeoN89rbPKd2XlZtmQc2Ll3Hs7EH8bdJx8rKZpe6GemGY1
NZS3nTrzMp0/adV5C2wbVfG2mOBZSsT6ByjAFCnN7+rYQEH5ynwL5IFJ/KnRQ/+k
QWiCnaO6yNDaXVwyb68SYZ1AcZdBlHDCJ/KNtBofzjaicWtJro6bBYXLcev6h225
8oxk8oodNlud6E7BPIEpI2F3kGxFRiK1gy9mIpMIS7LjST9V+cknRwvRW0W2URzm
OS3tzRZt74nFNW/SAZMikK/O2FWJBR5OYnL/c/RUeYDvSEvMp6SuJn5VJhb0Ij1o
pjz9SXQJuwRWrncgyb8F
=4DSx
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
