Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2FQOn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 10:43:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48595 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757351Ab2FQOn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 10:43:57 -0400
Message-ID: <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Dave Jones <davej@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Date: Sun, 17 Jun 2012 15:43:43 +0100
In-Reply-To: <4FDB8563.3030805@us.ibm.com>
References: <4FDB8563.3030805@us.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8KTSpHXHYu9peRQtVuBg"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8KTSpHXHYu9peRQtVuBg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-15 at 11:56 -0700, John Stultz wrote:
> Hey Greg,
>      Forgot to cc stable on this one. Thanks to Dave Jones for noticing!
> -john
>=20
> ------------------
>=20
> From: Richard Cochran<richardcochran@gmail.com>
>=20
> commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.
>=20
> When repeating a UTC time value during a leap second (when the UTC
>=20
> time should be 23:59:60), the TAI timescale should not stop. The kernel
>=20
> NTP code increments the TAI offset one second too late. This patch fixes
>=20
> the issue by incrementing the offset during the leap second itself.
[...]

This doesn't apply to 3.2.y, unsurprisingly.  Let me know if there are
any urgent leap second fixes that will be needed there.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-8KTSpHXHYu9peRQtVuBg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT93tH+e/yOyVhhEJAQpbmxAAqHK2NxKWFuRNYgCt+6Q+b4rVzrdFtxd8
NuDjEU33kqZGzvDuTJDbLU7Nds57hh+bdUOMlYj3N4Q8sFlRbHnfKmEtg83V5FWV
qL9kgydlKx/XjLzhRIJhpuyNgt3Y4bWyDcqAEO+2l997oQR9gXb3021eFiwkxs5M
NgyC/vR7KzQSib5Bz1N6sevj2GSrfOls2PIb/Xiq2AMC1eyKPDNrM7dtlUG+8t1O
mWUqu/o15h0LeKdtTglpp+9TIDpKk/s6Gd48nUtlqH3b5XK+sLa4WIYBlaiuaBKY
Rk8x+9JgQeskSEmEdb902RqApGtknEvbAaH5WF5Ao29q69/C1KuGHtKOoh84R2rI
a/ZcYgD61cAXVncFiBoPrm3DN5ruWp2IIwWr7Z4pejuYPyDp5N9WML0Su+ITzrmZ
eLQ/znMLx66OH31NgIN/WEonGWRQ2N3m47evOFWUkrTC5JXUc/yzvYNS57T6+dsl
DsLphJkcHjcOxybv1z7UbyvvF94JCrkByw775piM3VZVFPEWjBHcL+sB6LTC/LYL
sSkSdiUQ2TJWpC9xK5C9YJ7ZIlcsE7uLwiibkZopTXMEUgRaeoh8/7OgqiWSVA+E
Qi61Th1ot+gLRyGpv1xBgVk4L0g16B6t5yXMkXG3eVT9iGV9Kyoamh7PTdohbFuU
mHdF/H05YUo=
=IAtz
-----END PGP SIGNATURE-----

--=-8KTSpHXHYu9peRQtVuBg--
