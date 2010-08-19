Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0HSN0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:26:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58567 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0HSN0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:26:52 -0400
Date: Thu, 19 Aug 2010 15:26:50 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC] gpio/stmpe: add bitmask to block requests to unavailable
 GPIOs
Message-ID: <20100819132650.GC2747@pengutronix.de>
References: <1281971684-16505-1-git-send-email-w.sang@pengutronix.de>
 <20100818100950.GA19706@bnru01.bnr.st.com>
 <20100818103137.GB3528@pengutronix.de>
 <20100819130605.GA25901@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <20100819130605.GA25901@bnru01.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 2010 at 06:36:05PM +0530, Rabin Vincent wrote:
> On Wed, Aug 18, 2010 at 12:31:37 +0200, Wolfram Sang wrote:
> > On Wed, Aug 18, 2010 at 03:39:50PM +0530, Rabin VINCENT wrote:
> > > On Mon, Aug 16, 2010 at 17:14:44 +0200, Wolfram Sang wrote:
> > > > GPIOs on these controller are multi-functional. If you decided to u=
se
> > > > some of them e.g. as input channels for the ADC, you surely don't w=
ant
> > > > those pins to be reassigned as simple GPIOs (which may be triggered=
 even
> > > > from userspace via 'export'). Same for the touchscreen controller p=
ins.
> > > > Since knowledge about the hardware is needed to decide which GPIOs =
to
> > > > reserve, let this bitmask be inside platform_data and provide some
> > > > defines to assist potential users.
> > >=20
> > > Could this be done without the platform data, say something like the
> > > below?  (Though this does assume that nobody tries to request GPIOs
> > > before the STMPE subdrivers reserve their pins.)
> > >=20
> >=20
> > While I'd also like to skip the additional platform_data entry, your
> > last comment is in deed a drawback.
>=20
> Yes, especially if the subdrivers are dynamically loaded.  Your patch is
> fine with me:=20
>=20
> Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>

Thanks.

> The only minor comment is that the STMPE_GPIO_NOREQ_811_TOUCH name could
> perhaps be clearer.  STMPE811_GPIO_NOREQ_TOUCHSCREEN, maybe?

I thought of STMPE_GPIO_NOREQ as common prefix, 811 as type, and TOUCH
as function. But I don't insist on it; will do what it takes to get this
patch upstream ;)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxtMRoACgkQD27XaX1/VRuWuACfcMB6Zb62aDN7/nMJ+V6iUvCq
5j8AoMLvkk6vfhBf14rN1nd/wxsPW6gw
=5UJM
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
