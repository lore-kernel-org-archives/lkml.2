Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1K0ItT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 03:49:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36514 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1K0ItS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 03:49:18 -0500
Date: Sun, 27 Nov 2011 09:48:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert drivers/i2c/* to use
 module_platform_driver()
Message-ID: <20111127084848.GA5263@pengutronix.de>
References: <1322374332.2226.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1322374332.2226.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 27, 2011 at 02:12:12PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/i2c/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7R+XAACgkQD27XaX1/VRulvwCcDy+/N8L+uZkYG69/Qs/prIIW
etoAoIZjWZlaqpDc1lqLSrxVdkjyvvv0
=g860
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
