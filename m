Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2L2XjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 18:39:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38770 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526Ab2L2XjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 18:39:12 -0500
Message-ID: <1356824335.4446.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 024/173] drm/i915: add Ivy Bridge GT2 Server entries
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 30 Dec 2012 00:38:55 +0100
In-Reply-To: <20121229082112.GE18903@elie.Belkin>
References: <20121228190330.025298996@decadent.org.uk>
	 <20121228190335.033137454@decadent.org.uk>
	 <20121229082112.GE18903@elie.Belkin>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FnVF5QSoz8+wJBT3cONP"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FnVF5QSoz8+wJBT3cONP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-12-29 at 00:21 -0800, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>=20
> > This adds PCI ID for IVB GT2 server variant which we were missing.
>=20
> As discussed at [1], this triggers a small regression with Debian
> wheezy userspace (X freezing instead of erroring out).  libdrm hasn't
> been updated in wheezy since then, and I wouldn't be surprised if
> other distros were affected, too.  Has there been a kernel patch since
> then to avoid that?
>=20
> Though I wouldn't mind seeing this applied anyway, FWIW, as long as
> the announcement mentions the userspace bugfix needed.
>
> [1] http://thread.gmane.org/gmane.linux.debian.devel.bugs.general/978320/=
focus=3D74843

Sorry, forgot we'd discussed this before.  Thinking over this again, I'm
not convinced that X freezing at startup is a significant regression
from X failing to start.  Either way, it's unusable unless you
explicitly configure it to use vesa.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-FnVF5QSoz8+wJBT3cONP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUN9/D+e/yOyVhhEJAQo1TA/9E/9qGrE85tC6NomhdD650KJc+/r5cYQi
T02aEhn0Q2kLMAfVswJRRaWMvHOUNksHccS2h0sryFj+xiCnla7HoW/pwU3qpPU5
BsBvcxBFTXiFQwAVMYdJFsBCHr5Bvkq8kAANrP7dTK3x0Dj+FsISq55C63mGYZzd
Gv+xozpNzSAIHXIoXx3TB+4O/jXfYlxgpEy2b+bbUkCsI56MzOAjVhSit2rV9DBc
CYIL/s990FEQLDs+JINeXXyZCK2lOqPG/iuMKcxvlfYburstMlLgknIZiumlS2hs
Esd3L6UraICIPJu3TRpRSaAAgBaGiibe1xBoefRlinimucu7zCQ/GexKZhcG3Cu7
2Ymk+69Rf4FP+AQKklGsOSkuPLgcnNC0C79cXJJSui3HeesICiQ0YhMWTTn2+e4i
vdWo3+My0w79KVdzgoJeD3fz/LtyQzMqV5aYJ00ztZOP09GmT/HTzHvdp/KIaevD
1LKOJHu6uLH4GYi94GuKOH8lj1Agdmcw4eOk7FkiWIsaTpq+ijxA3m+yU2uwWjLO
60xFmxXbwe+qNrQ4PoeWACYekLUP8pTJ5fBORK4nXVI2m2gVKmuRMFPbZkK7cUkE
xy1iXLuDe+9aK63039p5GQlt4Ueuq7cVYbY3tn7u6bB+aq16elsK3BUPszqttEMe
Em4uGWWSBHY=
=+1NP
-----END PGP SIGNATURE-----

--=-FnVF5QSoz8+wJBT3cONP--
