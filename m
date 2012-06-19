Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2FSD77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:59:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135Ab2FSD75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:59:57 -0400
Message-ID: <1340078392.6871.6.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 04/69] drm/i915: fix up ivb plane 3 pageflips
From: Ben Hutchings <ben@decadent.org.uk>
To: Eugeni Dodonov <eugeni.dodonov@intel.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 19 Jun 2012 04:59:52 +0100
In-Reply-To: <4FDFA760.5040403@intel.com>
References: <20120617175941.281333656@decadent.org.uk>
	 <20120617175941.924141588@decadent.org.uk>
	 <20120618215555.GD3263@herton-Z68MA-D2H-B3> <4FDFA760.5040403@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UiElswPpSf9Cn/k1rwuh"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UiElswPpSf9Cn/k1rwuh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-18 at 19:10 -0300, Eugeni Dodonov wrote:
> On 06/18/2012 06:55 PM, Herton Ronaldo Krzesinski wrote:
> >> +	default:
> >> +		WARN_ONCE(1, "unknown plane in flip command\n");
> >> +		ret =3D -ENODEV;
> >> +		goto err;
> >=20
> > Shouldn't this have been "goto err_unpin;"?
> >=20
> > It's not a problem in the backport for 3.2, same code is in the origina=
l
> > patch, just noticed it seems a problem while looking at it; but by what
> > changelog says the default case is said to not trigger in "practice"
> > (catch programming error), so I think it doesn't pose a real issue in
> > practice.
>=20
> You are right, it should be err_unpin. I sent a patch rectifying this.
>=20
> In practice, this should not happen, but still, better be safe than
> sorry. Thanks for catching that!

So should I drop this until the second patch is upstream?

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-UiElswPpSf9Cn/k1rwuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9/5Oee/yOyVhhEJAQqXhBAArzP1SzAkhEHgTJMia03Dd0dUuCsdUs2Y
aZZS03C3Tqp5REOyg2vzPy1xqNwAdyCwwgUz6VC+lKR08nHMf1+sz1prV8uaZN8O
OoWHSlYxo2Y4i5DryxCnC6x/ytFjzzQ/6M1iZIy/r0meQi+zHrp+7WB0pA4xDvB9
LPTSm6h1h+7kbouRUxEvjJ7UbMiEsl45xpGuaDwuEOnqM3ShebdIxymvj0meOpF9
ZjBkWfSR6fRY0uDsvXLKjM2Fps7dhYrdB/2W8Gx4ax/L6OSwxODb4NCtb7MKHlTI
/S2KDwVZ42U1xtYghuwRsA7Ic+mBMkdxDIjnfMJ6imLBvJ54QDMCer+zwSXj8pVb
c0OqXoxLv52O5FdQDkqSsxmBK4EPWozj+4gs98/dq26B2twQV2SBsQZCWLTAvXZY
rBwHPHdXo7Zt7KjfUP6D1mukdsHmTrUfAaVdHXLKu89moksWaBB+0BER7+QaLmvA
d0sLU99uqGt1ZttijAt68Jk34Gm94FoFLFrIBAaAuKmmgsFi6jOla01Grvj3yZK0
S02nZ8qym8gXZk6IoupCdps54ZvELBTLU+Qrj/MKsDh59gK2DoA6S7az2stYCQWg
I8UbIQVvqbyXIY4CX7l5DW8RH+cTYdLzW8YUe1UUrfFCKe3wz+3nQoxV+Ir10XsS
XPtav+j8L8M=
=gKzM
-----END PGP SIGNATURE-----

--=-UiElswPpSf9Cn/k1rwuh--
