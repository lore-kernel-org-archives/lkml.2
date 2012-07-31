Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2GaXUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:20:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56569 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979Ab2GaXUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:20:21 -0400
Message-ID: <1343776816.4642.73.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 35/73] ASoC: dapm: Fix locking during codec shutdown
From: Ben Hutchings <ben@decadent.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Liam Girdwood <lrg@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Date: Wed, 01 Aug 2012 00:20:16 +0100
In-Reply-To: <20120731161325.GD11892@opensource.wolfsonmicro.com>
References: <20120731044310.013763753@decadent.org.uk>
	 <20120731044316.865191013@decadent.org.uk>
	 <20120731161100.GB3111@herton-Z68MA-D2H-B3>
	 <20120731161325.GD11892@opensource.wolfsonmicro.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oZBl+bKT276IYKxJpW0J"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oZBl+bKT276IYKxJpW0J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-31 at 17:13 +0100, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 01:11:01PM -0300, Herton Ronaldo Krzesinski wrote=
:
>=20
> > Hi, this doesn't build on 3.2:
>=20
> > linux-stable/sound/soc/soc-dapm.c: In function 'soc_dapm_shutdown_codec=
':
> > linux-stable/sound/soc/soc-dapm.c:2982:18: error: 'struct snd_soc_card'=
 has no member named 'dapm_mutex'
> > linux-stable/sound/soc/soc-dapm.c:3007:20: error: 'struct snd_soc_card'=
 has no member named 'dapm_mutex'
>=20
> > Looking at it, I'm not sure the fix is needed on 3.2, and introducing
> > dapm_mutex would be several changes.
>=20
> Yes, this is irrelevant on v3.2.

OK, I've dropped this.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-oZBl+bKT276IYKxJpW0J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBhoMOe/yOyVhhEJAQrIzw//bnJ4hcG830jLXumQfu4arX8vPs9Jment
kSuTL3puF+VjQKu4zjPXGWPPH0h3wUDuxdgdcHNnZUtqyEwpdAb8PbOTrVGK1FBZ
88ZEJtFGnLcwArcd8cKYIfon5uLCv+6c5+IpppZl3tvCRtR2IfjAZhPQ0RO14Hfw
f1FttoSyLhRsKKh9pl9QbRxpS804im3cNdN6VlJE2bZ0tLtcM7TUF2G9nM29qigj
86ZX/pevMBgdfbqo9a+g8OKzCZxD1OiskBdFXQngBEM7FYEBjb85qswiM/5prcC2
b4sylX66TcnAJ+Jx8LVEhMb9GiaElgmAxaB7/PiUdwcDzht/znJt1sq0xJsyWsnL
ZTfEJMEFCSxS2p10bxP5MOuFvcb9oBOXy4QFIqRC61k2lcPRn3Y00Ssm0/3hXmj7
gwuizjQyWfhXkJFy9WOD4J57TKCKxWu0o3FJy58X3IEyhkODXxrfMXehPU6bEC2Q
dKHjoEQWuIuhdiGoUcEVuM+7cgmyeUBl/hlWWsI00X/NAwg9N6MzA7P9Qh94O3MV
83Pm76NZberSZfBSr5KumECkFzwt3+eXpnWPT9ZC+1kZouw1YI2NI0xyUcqwt57E
GU9phmdlYrO4gVYEOuEBUP8tyKL8tAYPDHE/KxrTN00WIAosQBjJxGOR9bpUrGaX
PL3g9iqSug4=
=lqIf
-----END PGP SIGNATURE-----

--=-oZBl+bKT276IYKxJpW0J--
