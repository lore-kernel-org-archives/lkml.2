Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2L2LBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 06:01:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33812 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418Ab2L2LBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 06:01:39 -0500
Message-ID: <1356778887.4446.25.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 016/173] use clamp_t in UNAME26 fix
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 29 Dec 2012 12:01:27 +0100
In-Reply-To: <20121229080742.GD18903@elie.Belkin>
References: <20121228190330.025298996@decadent.org.uk>
	 <20121228190333.385175939@decadent.org.uk>
	 <20121229080742.GD18903@elie.Belkin>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-znM/zNWRhitQfq8WMQd/"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 31.18.9.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-znM/zNWRhitQfq8WMQd/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-12-29 at 00:07 -0800, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>=20
> > The min/max call needed to have explicit types on some architectures
> > (e.g. mn10300). Use clamp_t instead to avoid the warning:
> >=20
> >   kernel/sys.c: In function 'override_release':
> >   kernel/sys.c:1287:10: warning: comparison of distinct pointer types l=
acks a cast [enabled by default]
> >
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> [...]
> > -		copy =3D min(sizeof(buf), max_t(size_t, 1, len));
>=20
> I don't understand how this happens given that v2.6.36-rc1~68
> (MN10300: Fix size_t and ssize_t, 2010-08-12) was supposed to fix this
> kind of thing.
[...]

Neither do I, but I'm including it now just to be consistent with other
stable series.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-znM/zNWRhitQfq8WMQd/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUN7Nh+e/yOyVhhEJAQpDqg/+IRhem+eRgJxhEpyIyPAVxn+YSsdJOukE
XnceCpk+9bEdDsCDUEOIoxqWT8yh/nI/L8Q4RzffvN5BbuAAx1vjVy1uRezhFTFQ
miyEcd7man0NGJtNgMaf7gKoxFukx1YAERlMlTbVWqCMBVUpy2wRi67pmVVH2NiZ
MAzauYOmIo97Ybt6aT7rWuRMhbLlHXAcDxhlRxlRbQGOMSRj77/8ASfWAqvMlfl3
ygAklINTPZaMSc5OTgBSIkHvOP6oWHCMk8zN78DKf9aARrDye/7zcPLCWtkWXGAv
HLy1OUHfX3JNBTPJq9oIZMxzhTfkOwOUjLBHCLsVkganKkSUjq4H5NQHEgQLAZQ7
q1HueOnOJbi82ea+RwTk77qzJ11R1IALZT6aogLd5uZvW4AHmG0Fjbeh3aLzXFDh
tZSkQZsWrKcqoPYh2RZjieXTpyWdoF8tubv53yAmQ3NmrZTm+RWiM57rBN9R2+pp
ttBl+rkX3dDrhlbchadttwInFNWmXK8ZMiV/vfxJuNdOj9ml5V/Iuj8LsXBnIgOS
mbpsl4UI4OBXzCah97NKcHicRCjH6nDEVoB143Fum387JK3Uaq2CODuxpzJqTBBa
p6te6ZJkk56x5hPzpRtX2dTP1Zp7dzlAe8ltkAWof89nJT8dKMXX7ZIJ4Fos6ol6
gTkjU+xIeaQ=
=jN9Y
-----END PGP SIGNATURE-----

--=-znM/zNWRhitQfq8WMQd/--
