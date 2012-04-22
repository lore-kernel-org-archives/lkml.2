Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2DVQb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:31:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2DVQb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:31:57 -0400
Date: Sun, 22 Apr 2012 18:31:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 3/5] i2c: remove ixp2000 driver
Message-ID: <20120422163137.GB4201@pengutronix.de>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
 <1333503243-7702-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <1333503243-7702-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2012 at 08:34:01PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> The platform is removed, so there are no users of this driver.
>=20
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Thanks, applied to next.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+UMmkACgkQD27XaX1/VRspIgCgoRlmrxMwvB/muNf6wWeJXh2T
C/UAnR4dEuEb4nqT7WcH0wrAGDBsEbuo
=vFla
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
