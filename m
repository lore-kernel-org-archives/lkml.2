Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2A3Svy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:51:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58611 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab2A3Svx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:51:53 -0500
Date: Mon, 30 Jan 2012 18:51:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: Regulator update for 3.3
Message-ID: <20120130185150.GA6684@opensource.wolfsonmicro.com>
References: <20120130134223.GG4882@opensource.wolfsonmicro.com>
 <CA+55aFyoTP3G_x9KzN_cdDYUxRGTBBdoRVT56nFODkqukog7aQ@mail.gmail.com>
 <20120130174345.GN4882@opensource.wolfsonmicro.com>
 <CA+55aFxPivRzaKaNnTseyWmRhfvxV1=gWSTzgmSZx5Nm8XK=zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <CA+55aFxPivRzaKaNnTseyWmRhfvxV1=gWSTzgmSZx5Nm8XK=zg@mail.gmail.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 10:22:28AM -0800, Linus Torvalds wrote:
> On Mon, Jan 30, 2012 at 9:43 AM, Mark Brown

> > tags or not. =A0Either that or complain bitterly and mock me if I'm so
> > foolish as to have a tag and branch with the same name.

> I won't mock you (*this* time), but I think the "tags/for-linus"
> approach is better, as it should work regardless of git version.

Yes, indeed - so probably git request-pull ought to just do that when
working with a tag (which I guess it knows it's doing because it managed
to add the information it pulled from the tag into the pull request)
since it'll help with old versions and avoids confusions like this.

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJua5AAoJEBus8iNuMP3deJUP/1AQovYKSC5iPoRR0Pc4fxql
Q/UtbzBViI5t1qAFwrwAEXyc3NlyFq+mcToG0DJmTs6FBQmN59CnvEKDiXzAhLeY
bia06i+lnYykldWkDhskEE19GqFXxTg7hx/o5JYA3W4/3vDVFuY5LdUjLOdILzor
oxL+GyYf5msj5S/5OpC99BITQi+nO/7iCcQ7HcPSd9PZQKmFTf4BhbdyI966kKG2
7TvYjM7qpmQkiKDdVwvC0s2eYVKEXrRgtJKbMJ3JrzKoRTe2WUZDzUg0HzXQIkff
iBGmP+ujNB/15UlVSeUvolLu8M3pXaczjQ64g3e20+olP0jeK3Qgb3ECWZo8SdhB
mlp9mTzrxMq8L6pqJuGPSJI38tgtQc8Qa/G2cEfR+vv++b8wRdh9BjkIXptF4/is
x8KG/nmT2rEszkT7li414vIBc0MtV2ntwy823oZLok/FFF+pP04n0KBeLC+lnNit
tKbCXGfXrG1bnXQXAxcg8f8ZY5bUtaFzXj7ZWIADk+imXlinJEeZIYaa7gHtwpZX
cgn6NVdmRA433W1U13xjIyr14PmjMTe7rBsTiNooxzeYTKLLl0H446TraqVXMUrh
zN6uPEfmfwfqK9oQdIQDmB8c1db/TZLkpsHaz8Snfzwg1Yr6mXlUXyLSd8Y5nAkC
VKrBtUa2XdHAabm0lDHV
=kST9
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
