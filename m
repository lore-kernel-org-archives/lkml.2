Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2DRPAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:00:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42229 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2DRPAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:00:22 -0400
Date: Wed, 18 Apr 2012 17:00:11 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] i2c-eg20t: change timeout value 50msec to 1000msec
Message-ID: <20120418150011.GD19802@pengutronix.de>
References: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
 <1332741325-7746-3-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Content-Disposition: inline
In-Reply-To: <1332741325-7746-3-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2012 at 02:55:25PM +0900, Tomoya MORINAGA wrote:
> Currently, during i2c works alone, wait-event timeout is not occurred.
> However, as CPU load increases, timeout occurs frequently.
> So, I modified like this patch.
> Modifying like this patch, I've never seen the timeout event with high
> load test.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Applied. (I think we need to clarify the timeouts in I2C, but for now
this has to do.)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+O1vsACgkQD27XaX1/VRv5ZgCgpC7xcmFq4Y0ODfB4lSyiBiMV
qgUAoIY4zxqbvpENwaHFK2SJRkU/ajs2
=cyZ8
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--
