Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1KVSk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:40:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1KVSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:40:58 -0500
Date: Tue, 22 Nov 2011 19:40:51 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marc Vertes <marc.vertes@sigfox.com>, Wim@vger.kernel.org, wim@iguana.be,
        Welte@vger.kernel.org, Van@vger.kernel.org, Sebroeck@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com, Harald@vger.kernel.org
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111122184051.GA30941@pengutronix.de>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173227.GK6624@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20111122173227.GK6624@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2011 at 05:32:28PM +0000, Mark Brown wrote:
> On Tue, Nov 22, 2011 at 06:05:48PM +0100, Marc Vertes wrote:
>=20
> > +static int wdt_start(struct watchdog_device *wdev)
> > +{
> > +	/* Nothing to do. The watchdog can only be started by the BIOS. */
> > +	return 0;
> > +}
>=20
> Shouldn't we just update the framework to cope with missing functions?

For start(), I dunno. I don't have enough experience with watchdog drivers =
to
judge if this is acceptable, although I'd think so. For stop(), a few drive=
rs
already activate a timer to keep the watchdog happy; such a mechanism should
definately go into the core. It's in my todo-list, but I won't be angry if
someone is faster ;)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7L7LMACgkQD27XaX1/VRvxlwCfRsnYWSb04pvAYfS8KX8tBkM9
S+kAnj7yElwOMX8Arz6p7DOQAdXGYxYM
=sMx8
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
