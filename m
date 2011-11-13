Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1KMJsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 04:48:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43317 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1KMJsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 04:48:08 -0500
Date: Sun, 13 Nov 2011 10:48:00 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anatolij Gustschin <agust@denx.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/p3060qds: Fix select of 'MPC8xxx_GPIO'
Message-ID: <20111113094800.GA18470@pengutronix.de>
References: <1321141830.20271.22.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1321141830.20271.22.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2011 at 12:50:30AM +0100, Paul Bolle wrote:
> The driver for the Freescale P3060 QDS got added by commit 96cc017c5b
> ("[...] Add support for P3060QDS board"). Its Kconfig entry selects
> MPC8xxx_GPIO. But at the time that driver got added MPC8xxx_GPIO was
> already renamed to GPIO_MPC8XXX, by commit c68308dd50c ("gpio: move
> mpc8xxx/512x gpio driver to drivers/gpio").
>=20
> So make this driver select GPIO_MPC8XXX.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Thanks for catching this!

> 2) The config tools do not complain about selects that cannot be met
> because they concern a Kconfig symbol that doesn't even exist. Shouldn't
> they be made to complain in that case?

I'd think so.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6/klAACgkQD27XaX1/VRt5LwCgxo8vn3H8WKz9+5pEM0utFWh2
CVYAnA5FZG3qLAUHXjhTMp83Xi45S+Sl
=QaI6
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
