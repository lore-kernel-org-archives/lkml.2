Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2DJKGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:06:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115Ab2DJKGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:06:07 -0400
Date: Tue, 10 Apr 2012 11:06:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: twl-regulator: Simplify the code matching
 regulator id
Message-ID: <20120410100604.GE7499@opensource.wolfsonmicro.com>
References: <1333981969.9076.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Content-Disposition: inline
In-Reply-To: <1333981969.9076.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 09, 2012 at 10:32:49PM +0800, Axel Lin wrote:
> This patch makes the code easier to read.
>=20
> Also add checking the case when no desc id is matched. This is required b=
ecause
> if no desc id is matched, the poiner info is pointed to twl_of_match[i].d=
ata
> which may be not NULL. Checking info is NULL or not latter does not catch=
 the
> error.

Applied, thanks.

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhAYFAAoJEBus8iNuMP3d44kP/jLUaEOst78pCbVjZpIYB1wk
5uGp/GQ7lFdpVPOfkO3vBz+eryOHRl/wjQqjWUuT3EqI0fXSyUltOmjHkR949wKh
ecUPcKCnLSUNdPAO38Ba5rlZnUWcWATqsCy7EfO7Jh2uXwCiPKXnpdNn92VEbMwn
nmB6fs7Nv1altFgyd+QXcLlf3YaOsxKw9bPQI+MM8giTm/oeYRJV/3rml/cV/r70
854UsEsBEIc4s6MByBfnYVnnvS55vHmRdU6Ustr8wcOcb1p9k8Xdbruo1DA+TXS0
FsU4zHY0KkzIa5VkinaN+x3TMNrAUsTt8BQa8JF0CTQuS+coIZOvSG5g6L6rTlsE
bvVprqBjlMz848sWmWF1+tH6Y7lsJO09MnVE9n+VfdcfzWPaCyECr1juro+iXSj6
VQiIFTUz8FWYvBbGLwOO8AsBLgU4PaycZ8vDOmLll7T/nUXHQj+KoDie8822XCYQ
sj/LAi1Zad/+frIxJzRHOr5HklMYRhGGtFmNPmdc4J+gd9Lr2tKC3C3vXLFcFMyM
TrS9E+i9VHuBtS7b1Yk94eHu+dP/dS64QK1OI5EfFtCCHPH/N25ZXOqKj+qpPIAy
YWCOuQ5agB3WyT4tGlZ7AOinxsZXf9z/vz5x3ZTualzLksCcDP1ECkfy4FgOayfF
IvZvsQB3asUhHy3ErZ0h
=YEIz
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
