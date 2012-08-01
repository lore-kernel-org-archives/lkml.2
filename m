Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2HAHnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:43:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2HAHnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:43:49 -0400
Date: Wed, 1 Aug 2012 09:43:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120801074335.GG29673@avionic-0098.adnet.avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <20120731170741.GA4735@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:0iijPw/7Yqgdapwj1TgbbwYxaR6wBcDgLpLMX6DBnxK
 50V4EoVaKFm2JV6klWnrCGkcemSBmwCH4DkQcy7/AQSowdeu07
 ZSJ1kgnflL1TRrGV4QZhf9fxM//pidokBh6n6O9IE2vdUAMw7X
 MKH8wYpBqhRZvgGELoCinlQ+Tc/Zdxl7Nb/knWEGS3/tww8E+R
 abH/2MhuFMhvyHFZTmqURZxcsDQb6EhxgOsMQMnqpfIzw2HPWW
 cYWAzgXoQ+4sqOUOZMSj03Y9M08dEaFaq0QbzJpQn7RXB7xY4b
 /uZvJTOhMFT8tv/gDqVlKe6bNy1HP/qPmag4mKhgZPCO1drCZK
 EeKzwJW/BoPjZPC+G5kfdu5X6lUTb+Klz8+z5QncEwh8KPs2Ww
 6GbK9pT4y69Oun79Dpw7sSQhxGU/jh17tspuuztGg68/v0bxqy
 +mdJK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 07:07:41PM +0200, Borislav Petkov wrote:
> On Tue, Jul 31, 2012 at 11:16:00AM -0400, Dave Jones wrote:
> >=20
> > PWM Support (PWM) [N/y/?] (NEW) ?
> >=20
> > CONFIG_PWM:
> >=20
> > This enables PWM support through the generic PWM framework.
> >=20
> >=20
> > Well that's.. enlightening.
>=20
> Oh, there's one more enlightening sentence in the help:
>=20
> "You only need to enable this, if you also want to enable one or more of
> the PWM drivers below."
>=20
> Got it? :-)
>=20
> > I'm picking on PWM here, but this isn't an
> > isolated case.  Every merge window we see a slew of new options with us=
eless
> > help texts. They may as well be non-existent. (Actually in some cases, =
they are).
> >=20
> > If someone has to read the code to find out what the driver is, your he=
lp text probably sucks.
> >=20
> >=20
> > (I'll leave "why does this option even show up on x86" as a separate ra=
nt)
>=20
> Thierry, can you guys please fix this?

Hehe, those aren't very descriptive, that's true. I was going to go over
the documentation anyway, so I'll make a note to revise the Kconfig help
texts as well.

Thierry

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGN4nAAoJEN0jrNd/PrOhEsEP/36aZmEAugZY2iBLVNhAD4dQ
Zm2LUimEmqNPxtu17L708gJl4pHx0O59C5yw8dEUnrT3OWUhkPlIVRojwd1iyTvd
ZQStLoNGEFNi/FvWNddnfKuV2Ltejwz24zTsTdPS1aeg1NbLjsOU7nu8roF/76Qd
E2TnEmIMgfNInL9cpSnVRf68iSbLtQav2VzX7OnyWktNNQi2uclq7OCt3WpMfphg
g3x7LKROBknkv5tpx724Cmpm4Tm2ZqRgmPeF7q+I7bkVLAXuc33J2Qv5r68uBk/5
PkDhC91l1m2RohTese7vygDvBzI59Y52+SVwoDk109tignQ0hMcd8B7KBi699n/S
8K/KYzxo5wZT8Z37QjOrLjTVWyNeFU/hEbiVWcHV5tJPb/fUVTpU5lBLi2o+ULYM
lJaEHelW4wAJGkzxzCasvRjeoGkeIyk+J7zPzJ12L6m/AlzOh9T7ajTCYhoSgLPW
sz6WM/v3xn4GrMgapm10fm7dmeHJic1pHYINbEu5YbvyBzspD8IYv6PYk/2a4P/g
ppPE6+J+ttCAICPfdukArX+Aja/EexQVxyRsgsfeVIAc8tuWzZAp8Lu9Cqvn4rsK
iSYRdNP5yvZm3aD4AOoGl8bkPnmpvNuoEX9nJtYbFxuEdlsOF8WGQbSBXcQ45L2W
g6g4Xd2X+0hc+ifxcBqa
=WXo9
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
