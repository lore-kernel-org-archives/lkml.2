Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2HRJvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:51:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51587 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2HRJvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:51:19 -0400
Date: Sat, 18 Aug 2012 11:51:08 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>, kevin.wells@nxp.com
Cc: vitalywool@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
Message-ID: <20120818095108.GB24812@pengutronix.de>
References: <1344411752-23469-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <1344411752-23469-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 09:42:31AM +0200, Roland Stigge wrote:
> The I2C Control Register bits RFDAIE and RFFIE were mixed up. In addition=
 to
> this fix, this patch adds the missing bit DRSIE for completeness.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---
> Applies to v3.6-rc1
>=20
> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx, not yet =
in
> mainline). Can you please test and double-check the manuals of PNX4008 and
> LPC31xx? I only found this via the manual of LPC32xx but assume it's the =
same
> for the others, also.
>=20
> Thanks in advance!

Kevin, since the other manuals seem to be not easily available, can you
please check?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvZYwACgkQD27XaX1/VRtCJACfSNacfFhoVmX/2n9KeLLDCGb1
SpgAni1seSVbb1sIw9ncoS/fxlWrPb62
=puQb
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
