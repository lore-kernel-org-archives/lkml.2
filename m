Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1LMKQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:16:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44799 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1LMKQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:16:23 -0500
Date: Tue, 13 Dec 2011 11:16:17 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/19] cpuimx25sd: fix Kconfig
Message-ID: <20111213101617.GB2619@pengutronix.de>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
 <1323757911-25217-3-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <1323757911-25217-3-git-send-email-eric@eukrea.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2011 at 07:31:35AM +0100, Eric B=E9nard wrote:
> in 0d6cfa3a75f5cde5b3ca0dde748fd22625b4f34c I fixed the mach-types
> records. We also need to make the name consistent in Kconfig else
> the machine_is_eukrea_cpuimx25sd macro fails, and thus audio codec
> is not properly initalized.
>=20
> Signed-off-by: Eric B=E9nard <eric@eukrea.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>

Nit: The subject line is a bit sparse.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7nJfEACgkQD27XaX1/VRuGxACgnsiM07armoyuQEPoeTYLP7y6
sSwAoI0CxKSzbyO8g0XXkuIesFAgb7Gb
=kR9u
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
