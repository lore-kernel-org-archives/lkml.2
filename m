Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0HLDPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:15:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51285 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254Ab0HLDPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:15:10 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, stable-review@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <20100812000616.181969463@clark.site>
References: <20100812000616.181969463@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uXzhcrHPdq0tfoTqjX0k"
Date: Thu, 12 Aug 2010 04:15:02 +0100
Message-ID: <1281582902.7543.513.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [38/67] drbd: Disable delay probes for the
 upcomming release
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uXzhcrHPdq0tfoTqjX0k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-08-11 at 17:05 -0700, Greg KH wrote:
> 2.6.35-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Philipp Reisner <philipp.reisner@linbit.com>
>=20
> commit 6710a5760355be8f2e51682f41b0d3fc76550309 upstream.
>=20
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[...]

Anyone want to explain why this is important?

Similarly "drbd: Initialize all members of sync_conf to their defaults
[Bugz 315]"; I assume that some Bugzilla entry would tell me, only I
have no idea where it is.

These commit messages *suck*.

Ben

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-uXzhcrHPdq0tfoTqjX0k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATGNnMee/yOyVhhEJAQIokA//f7rZOIKwoLnDa+az8yIKJeztP556Potk
GKfyBRZDeHQGBJNN7MziwKj3qTxZFumN8jVQbZKG82LJC/2sfzxvdvzi15/QkB1y
mnzzUulTTSeYeJ3wfqApy3/jGLdrtCYTlhHuiTjl3ufRzaR6dO9Hdm/8GzO9dt4Z
piR1WOmByNjhdOlHzsM4nUS4Ao4gJAC/myJ1pYYWFqnSQfcW81JzG3rv+5dqQX8D
suPFo58L8yQGiD/OWk5GL5BAqfN5/4If558q/7Krbag4k/TmPbp9bZjQ2WVvZqsj
rgJMoH8v/q/idUAM6IkZVi1IO3uvkfIx1c5BDpKHl8yKiRdfWjfx+IPWad09594a
+5WBfxsMb9Y9GpxtQh0JvYvvxQ3gS2/v0prla6CzjozKvur4KqsBF1os0qMy4e00
emKGrKdY4Mr/tzvs+CEQPfB5Gv3WUs3X1cEc6Y8U6X8HpBwfSVXt+Tk4F+8To94N
EmyOAmOcMJywBOdquIoetXEHFDW0U32e+eP3D2YP/n/3zmPVh6dw1hBoMic2579S
EjOcKFR1s2WaGOdljK4NP0jo/AYo7pEjvUSbzkCy4PD6Qz0oGnVHaLYtPh88BBAK
xj7gdsilm8TlABj4+n0oOjiyDRqMAdUHo4xkHqMZEaz2vgKdNvEKFpR0AkG5IkXF
L4bLD45Od3A=
=5lW2
-----END PGP SIGNATURE-----

--=-uXzhcrHPdq0tfoTqjX0k--
