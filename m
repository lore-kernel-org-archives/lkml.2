Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1BASoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:44:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38518 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1BASoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:44:15 -0500
Date: Tue, 1 Feb 2011 19:44:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [leds-pca9532] Add gpio capability
Message-ID: <20110201184414.GB16160@pengutronix.de>
References: <0D753D10438DA54287A00B027084269764CEEDA479@AUSP01VMBX24.collaborationhost.net>
 <20110201080146.GA27955@pengutronix.de>
 <0D753D10438DA54287A00B027084269764CEEDAC85@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764CEEDAC85@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +static int pca9532_gpio_direction_output(struct gpio_chip *gc,
> > unsigned offset, int val)
> > +{
> > + return 0;
> > +}
> > +
>=20
> Not good.  When the pin is configured as an output, the direction_output =
method also
> requests that the pin be set to a desired level.  For this driver that me=
ans that the
> pca9532_gpio_direction_output function just needs to call pca9532_gpio_se=
t_value.

Ack, missed that. Thanks a lot!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1IVH4ACgkQD27XaX1/VRvA2gCggYT3QBl9kBLPSvF1Far+bpMs
KBQAnRwjPJLXlFcQJb9iNZQ9wjm1UWm+
=VtC9
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
