Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2DTPSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:18:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44039 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2DTPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:18:00 -0400
Date: Fri, 20 Apr 2012 17:17:43 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, robherring2@gmail.com, vitalywool@gmail.com,
        khali@linux-fr.org, ben-linux@fluff.org, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v6] i2c: Add device tree support to i2c-pnx.c
Message-ID: <20120420151743.GA12536@pengutronix.de>
References: <1334928849-18079-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <1334928849-18079-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 03:34:09PM +0200, Roland Stigge wrote:
> This patch adds device tree support to the pnx-i2c driver by using platfo=
rm
> resources for memory region and irq and removing dependency on mach inclu=
des.
>=20
> The following platforms are affected:
>=20
> * PNX
> * LPC31xx (WIP)
> * LPC32xx
>=20
> The patch is based on a patch by Jon Smirl, working on lpc31xx integration
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied to next \o/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+RfhcACgkQD27XaX1/VRv43QCcCOXA+kSK6XH+2glVcVSZV9Nf
oMEAn1KeQpBiGSbH8/WZ9ZozNZi/oSnc
=BqDo
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
