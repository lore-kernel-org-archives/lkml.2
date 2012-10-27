Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2J0W6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:58:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60446 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab2J0W6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:58:31 -0400
Message-ID: <1351378708.21585.8.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 108/147] ALSA: hda - Fix internal mic for Lenovo Ideapad U300s
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Date: Sat, 27 Oct 2012 23:58:28 +0100
In-Reply-To: <20121018185055.GC3025@herton-Z68MA-D2H-B3>
References: <20121014143533.742627615@decadent.org.uk>
	 <20121014143548.361462458@decadent.org.uk>
	 <20121018185055.GC3025@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dhwppUIBinSyNeJuSEi3"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dhwppUIBinSyNeJuSEi3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-18 at 15:50 -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, Oct 14, 2012 at 03:37:21PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: David Henningsson <david.henningsson@canonical.com>
> >=20
> > commit 18dcd3044e4c4b3ab6341c98e8d0e81e0d58d5e3 upstream.
> >=20
> > The internal mic input is phase inverted on one channel.
> > To avoid people in userspace summing the channels together
> > and get zero result, use a separate mixer control for the
> > inverted channel.
> >=20
> > BugLink: https://bugs.launchpad.net/bugs/903853
> > Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > [bwh: Backported to 3.2:
> >  - Adjust context
> >  - Change both invocations of apply_pin_fixup()]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> I noted today that a follow up fix for this is needed to avoid an oops
> in apply_fixup, please consider adding to the next 3.2 stable this:
>=20
> commit 83b0c6ba999643ee8ad6329f26e1cdc870e1a920
> ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Lenovo=
 Ideapad U300s"
[...]

Added to the queue, thanks.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-dhwppUIBinSyNeJuSEi3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIxnFOe/yOyVhhEJAQqfJw//dSDNL3R104CNGntb2+ZDnVZXA0bdeH0g
mqjdT+doa0nXSpEZ6IJB3d0b6jdg88c6L9/hZ94i4ePZHCQR+swDBVN2YCo1uOc3
N9xZGFZ6ODOwG9O14gF8ODXM41LJnSGxqIiirZDuMsia0J1Z+EMy6tO8eRKqSl3e
br0jU1Zc5UIyG5E5QdjuG5XaUorelZT59S+dfsfkgjH8XoiJ5X9pTMZPxz2Rd9CJ
k80epElY5kslSr++Jx+ZCln3RwoYL8GQ+Q8pAiCckjpBZ+5cZNc++oBg/Ld2En3M
spLPPUccUhzqbr0n1kPIDjbZtk6/SlucxtJPdQIx3HlCRfDv0UY9lOW61d0I/o28
Hmg2/VeUjmFNw2TBziY28PGIIoigQWRNbYxlBWeZ1WNkckI9WsoD+2B1qMGbPgQp
x3srmzoJ6VTgpgMw0iOhzeDUd0oxRuV+N3suBwtgRhv7bJuqxQ15fy+VG95Bb/0N
UdGFYD+sS/J2IPrXb2nmvwyvSvvzD5XWngzUwUeMv1DoAVo9NLmJSLE9he6ZX2m8
969A/rmdZUztZvmbotd+9avdP48INeoo+JC1RM4lC+8pRwTny87VrEkpaOVsGqW3
kZpu4xvxcCm3MKWJ/wjolnXfcGBJwvFOAIIl0w0kIpeUJZoDIWulxcrNzlU2a7eh
hYdFsH25vqY=
=InMh
-----END PGP SIGNATURE-----

--=-dhwppUIBinSyNeJuSEi3--
