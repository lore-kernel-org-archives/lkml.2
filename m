Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2LRKCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:02:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42036 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2LRKCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:02:11 -0500
Date: Tue, 18 Dec 2012 11:54:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <svenkatr@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121218095450.GB27751@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <1352968293.10872.51.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 15, 2012 at 10:31:33AM +0200, Luciano Coelho wrote:
> Since the 32KHz clock was removed from the twl-regulator (0e8e5c34
> regulator: twl: Remove references to 32kHz clock from DT bindings),
> we've been having problems with our wl12xx chip that is connected
> through the omap_hsmmc.
>=20
> Our card simply doesn't get added to the system and we get lots of
> -ETIMEOUTs during mmc_attach.  If I revert 0e8e5c34 (plus a couple of
> associated patches), everything works fine.
>=20
> I've been using a Blaze device with a WiLink 1283 chip connected in the
> COM (internal) port.  The funny thing is that I don't have the same
> problem with a WiLink 1853 chip (which is connected externally to
> another Blaze).
>=20
> Does anyone know what the problem could and how to fix it?
>=20
> This is a regression that has been there since 3.6-rc1.

damn, this is still part of our v3.7-rc kernel. Original commit was done
with no testing whatsoever and caused a big regression to (at least)
TI's WiFi driver which depend on SDIO to function.

Too bad things break and even when reported nobody gives a rat's ***
about them :-s

--=20
balbi

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0D1qAAoJEIaOsuA1yqREfTAP/R/EuJR3L0b5QyM26YOQz4kS
ziQIA24R9u2q0ZLYl8x6lhqQm4LeUj8Neyln7OsOR0uNVe5CGPNGlo/ytPHrKriE
YGnHdA+PCAxXPnggrx19r1g+U75niMxN47JwUauoLuZoioHgcww4XlBFgiXQy5SD
y1olDxTYAow8zG2QuBW4rHDKn/q9l5Q02O1opEru66ZVMs8YScHAceJHs4CMn6t8
Dy6dYt+zRI04BUUGuhJxQ9ZVm3RtoEhK50MhE2M+qDAY4ComyO2qyY/cI7OX4ww8
hiU4d6c6PjmCBZWrmqRxOH2X72qYbdFYt6MsJmMFmx10UvCK4cRndM2onhyIWCV7
wHZ9Rp5eDZ4ZORJ/xqDA68e9b45DmMBr3OtewqOt+Gpc7SmdP5UBeQTpAd5eduSg
5XcZZCNNKh2VNaFtKxNDUT1dvg+wiwKAjUIs99zstA8gGPw9iMUGa7YRrDFkY0Yf
vit1gtahKrjbQQEMqAqTh7GYAxt3g7tCCmvDBGdd5a0DHpuD4WWFskLGao2a1FXq
ljdmosjft/PPSb1Esswa03d19KdtIMwOQgLylVhxrVzeBQN8adciV5lK+dKN0JgE
1fkqarMrXsmADlUlznC2iz2i026WQand1DfoxQEG3PtOYzTJ+6NtrR0CtRPdRrzo
9Hb9ehcfjPPogBs7ZRJA
=xrzj
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
