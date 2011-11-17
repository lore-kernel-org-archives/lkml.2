Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1KQKOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:14:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33695 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1KQKO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:14:28 -0500
Date: Thu, 17 Nov 2011 11:14:26 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Juergen Beisert <jbe@pengutronix.de>,
        Matthias Fuchs <mfuchs@ma-fu.de>
Subject: Re: [PATCH 5/8] serial: 8250: reject delaying RTS with RS485
Message-ID: <20111117101426.GD2535@pengutronix.de>
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
 <1321460685-15753-6-git-send-email-w.sang@pengutronix.de>
 <4EC4D72F.8030702@evidence.eu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <4EC4D72F.8030702@evidence.eu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> The delay must not necessarily be done by hardware. The drivers/tty/seria=
l/crisv10.c=20
> driver, for example, delays through a msleep.
>=20
> I don't know if having a software delay in this driver can make sense in =
some particular=20
> circumstance.

Uuuh, I would be against software delays for the same reason why we
don't accept software based direction switching: No guarantees. msleep()
might easily delay longer than what was requested. Or are delay_rts
values to be interpreted as "delay at least"?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7E3oIACgkQD27XaX1/VRvfuwCgrAyHc88uIh2OcnAZD2wRucfs
stMAn0rE9s0VfJ/cABtCypX3P/l35XPz
=bl6p
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
