Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2DRR7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:59:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52316 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2DRR7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:59:02 -0400
Date: Wed, 18 Apr 2012 19:57:59 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 5/8] i2c-pnx.c: Fix suspend
Message-ID: <20120418175759.GA2548@pengutronix.de>
References: <1333528480-17134-1-git-send-email-stigge@antcom.de>
 <1333528480-17134-6-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1333528480-17134-6-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 10:34:37AM +0200, Roland Stigge wrote:
> In the driver's suspend function, clk_enable() was used instead of
> clk_disable(). This is corrected with this patch.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> CC: stable@vger.kernel.org

Picked up for 3.4, reworded the message header to "i2c: pnx: Disable
clk in suspend" since "fix suspend" was too generic.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+PAKYACgkQD27XaX1/VRsj4ACgiUS75cGf7WchOPKqs45Qt3FO
qp8AoLRRAJSMxmDd+MA5CdNa8su5WzMG
=ErG9
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
