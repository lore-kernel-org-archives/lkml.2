Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0CUO50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 10:57:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab0CUO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 10:57:25 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269161010.4028.9824.camel@macbook.infradead.org>
References: <1269126097.18314.111.camel@localhost>
	 <1269126446.18314.117.camel@localhost>
	 <1269161010.4028.9824.camel@macbook.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VjhHYK2m1uzHb1ielEZn"
Date: Sun, 21 Mar 2010 14:57:16 +0000
Message-ID: <1269183436.18314.150.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 4/4] pci/dmar: Tone down warnings about invalid BIOS
 DMAR tables
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VjhHYK2m1uzHb1ielEZn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-21 at 08:43 +0000, David Woodhouse wrote:
> On Sat, 2010-03-20 at 23:07 +0000, Ben Hutchings wrote:
> > We now know how to deal with these tables so that they are harmless.
> > Use the TAINT_FIRMWARE_WORKAROUND flag and don't say the BIOS is
> > 'broken' as this makes users think of hardware damage.
>=20
> Nack to the string change. If you see this message, it's because your
> BIOS is BROKEN, and this brokenness has caused us to have to disable the
> VT-d feature completely. The fuckwits obviously never tested it even as
> far as booting a VT-d enabled OS on it even once=C2=B9.
[...]

Are you saying that these bogus tables are found on boards that do have
VT-d hardware?  I was working on the assumption that these tables result
from the OEM building a BIOS with VT-d support for a board where the
hardware is not present.

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-VjhHYK2m1uzHb1ielEZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6Yzwue/yOyVhhEJAQIwMQ/7BEG6UCOQZyl8JOO1MLYZQmOa/STYP2LR
CYNBV11Q1Jtm7/rqM59bteoKFb2boQ3zYTqfoXC9PBUvt+roWyq5LPQ5K+Qw3GMl
2LyLY4z7t7UUeeZLBJ/BVU2tZAINXAJ3ssxVYTCtInP46nASPT4XndpRSiV12c4h
cs05S3o7vFgIY7tDTNUcvj6NXzUckl9GOvrRBWBIv7ODUwt9II7XLJnK32LemNjY
/LE8IWiXcYwBvTzmVi9UJvd9W1WnAYnGrXqVAsUYgYsYER6mZhDexz2lsZQLHeBb
7xGVOjDeuI36HxMidVyM+OfSQoAPRLe4kZuGF55Gm/fERJo/B/H02PRGiJDbAsaw
G19mu2jP7LDD50J+brqiHTMNs6G+xDoLId3YARr3tIOk3Xhp72bXgjQuxqyGiZnS
6jtR1+AW1P/N45UgDSpJsB6JQBc96R1HhVVfJVGlRv4uSO+cTZIGSr9Eje2zQvTJ
T0BzWsIs9A7CagHiRYCj4kS/5Yl1sL1E7bxHH+stYsya1JFOGvPrZ9vxJUkTAlXE
X2/80+BHzLg0RrlxWlQAbHU5ddPIHi54VkkC8+TWLV1a0ltc3QxUiVhxv6J1UuvA
Eqt0vL3499zDUddHDphwTyg/3psipapuS4Z/NNw3oUZg2buNNg1Xs7L7XzIkJQKy
6l6RdNCFHew=
=+EYs
-----END PGP SIGNATURE-----

--=-VjhHYK2m1uzHb1ielEZn--
