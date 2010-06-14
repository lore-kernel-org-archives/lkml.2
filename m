Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0FNM3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:29:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53192 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab0FNM3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:29:04 -0400
Date: Mon, 14 Jun 2010 14:28:53 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V2] gpio: add STMPE811 gpio controller support
Message-ID: <20100614122853.GC12027@pengutronix.de>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de> <1276511558-27121-3-git-send-email-l.fu@pengutronix.de> <20100614115123.GB14604@rakim.wolfsonmicro.main> <20100614120943.GB12027@pengutronix.de> <20100614121349.GC14604@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20100614121349.GC14604@rakim.wolfsonmicro.main>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:23:04 up 7 days,  4:51, 53 users,  load average: 0.68, 0.42,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,
On Mon, Jun 14, 2010 at 01:13:49PM +0100, Mark Brown wrote:
> On Mon, Jun 14, 2010 at 02:09:43PM +0200, Luotao Fu wrote:
> > On Mon, Jun 14, 2010 at 12:51:23PM +0100, Mark Brown wrote:
>=20
> > > Assuming you're able to do interrupts on the GPIOs you should now be
> > > able to implement to_irq() as well.
>=20
> > The chip can indeed generate irqs on the GPIO line. I, however, kept out
> > the irq stuff for now because i want to get the core functionalies done
> > for this turn. I'd like to add the irq stuff with a separate patch late=
r.
>=20
> It should be a trivial function - it just does a mapping from a GPIO
> number to an IRQ number.

right, to_irq is simple. However, there're some more stuff necessary for
gpio irq on this chip, since it has separate registers for GPIO
interrupt control and status. A further gpio chip might be needed
needed to get the stuff done. Hence I'd like to push out the most
importatn core funcationalities out for the first turn before I take a
deeper look into other stuffs.

thanks

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwWIIUACgkQkLuxfMCkDTYMzgCeP1B2mifNmw+2BZXSxYGvScIB
CFoAnjtz7Vy7u36qYJXIrfH0fVZHrO9X
=LpwK
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
