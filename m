Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2DTUjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:39:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2DTUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:39:46 -0400
Date: Fri, 20 Apr 2012 22:39:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] i2c-eg20t: add helper function for xfer check
Message-ID: <20120420203937.GB12691@pengutronix.de>
References: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <1334817485-7121-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2012 at 03:38:04PM +0900, Tomoya MORINAGA wrote:
> Currently, there are the same code for xfer complete check processing.
> So, I add helper function pch_i2c_wait_for_check_xfer.
>=20
> Reported-by: Wolfram Sang <w.sang@pengutronix.de>
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Both applied to next, thanks for doing this! ~120 lines saved, that's
about 10%. And also way better maintainable, yay.

My checkers found some other issues, for which I will send patches in a
minute. Please have a look and test.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+RyYkACgkQD27XaX1/VRvUvQCfSsmJo6aAYZChOsH+2rGKJl8z
Fz4AnRYC09uIa8jG7LPYyxapi6DUTc/q
=hBsq
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
