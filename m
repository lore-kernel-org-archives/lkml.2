Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0FNMJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:09:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0FNMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:09:48 -0400
Date: Mon, 14 Jun 2010 14:09:43 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] gpio: add STMPE811 gpio controller support
Message-ID: <20100614120943.GB12027@pengutronix.de>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de> <1276511558-27121-3-git-send-email-l.fu@pengutronix.de> <20100614115123.GB14604@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <20100614115123.GB14604@rakim.wolfsonmicro.main>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:05:41 up 7 days,  4:33, 53 users,  load average: 0.15, 0.27,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

thaks for the review.

On Mon, Jun 14, 2010 at 12:51:23PM +0100, Mark Brown wrote:
> On Mon, Jun 14, 2010 at 12:32:37PM +0200, Luotao Fu wrote:
>=20
> > +static struct gpio_chip gpio_chip =3D {
> > +	.label =3D STMPE811_GPIO_NAME,
> > +	.owner =3D THIS_MODULE,
> > +	.direction_input =3D stmpe811_gpio_direction_in,
> > +	.get =3D stmpe811_gpio_get,
> > +	.direction_output =3D stmpe811_gpio_direction_out,
> > +	.set =3D stmpe811_gpio_set,
> > +	.request =3D stmpe811_gpio_request,
> > +	.can_sleep =3D 1,
> > +};
>=20
> Assuming you're able to do interrupts on the GPIOs you should now be
> able to implement to_irq() as well.

The chip can indeed generate irqs on the GPIO line. I, however, kept out
the irq stuff for now because i want to get the core functionalies done
for this turn. I'd like to add the irq stuff with a separate patch later.

Thanks

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwWHAcACgkQkLuxfMCkDTYqPwCfTEB7xfSloWD/mabpXQhOEOlc
pTcAniFiHphROvbjxro+w1doeWVfscLC
=nAru
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
