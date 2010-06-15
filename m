Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0FOIVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:21:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0FOIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:21:22 -0400
Date: Tue, 15 Jun 2010 10:21:21 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] max730x: make pullups configurable via platformdata
Message-ID: <20100615082121.GA2478@pengutronix.de>
References: <1276588861-15663-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1276588861-15663-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 15, 2010 at 10:01:01AM +0200, Marc Kleine-Budde wrote:
> The gpios on the max730x chips have support for internal pullups
> while in input mode.
>=20
> This patch adds support for configuring these pullups via platform data.
> A new member ("input_pullup_active") to the platform data struct is
> introduced. A set bit in this variable activates the pullups while the
> respective port is in input mode. This is a compatible enhancement since
> unset bits lead to disables pullups which was the default in the
> original driver.
>=20
> _Note_: the 4 lowest bits in "input_pullup_active" are unused because
> the first 4 ports of the controller are not used, too.
>=20
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Marc an I already discussed the previous versions, so:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwXOAEACgkQD27XaX1/VRtxiwCggTNqDMucC1YDs8UQKYc+3fZH
UkMAn1tyQQHaTUfNrcCFVp0PIl7qOxim
=gcmK
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
