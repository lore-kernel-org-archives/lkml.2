Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2CIN0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:26:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43382 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2CIN0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:26:35 -0500
Date: Fri, 9 Mar 2012 14:26:28 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH 0/3] introduce stmp-style devices
Message-ID: <20120309132628.GB2554@pengutronix.de>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
 <201203081603.12817.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <201203081603.12817.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I think having the stmp_device code is good, but I'm not sure about the
> location in drivers/base, which is otherwise reserved for anything related
> to 'struct device'. How about putting the same file into lib/stmpregs.c?

Fine with me in general, except that I'd go for lib/stmp_device.c.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9aBQQACgkQD27XaX1/VRsCYgCfU21hL+jxhVk1NNoutiZrAu0q
MkQAoKnXpPHoSdEZlXh9wQW3wkSGkPZu
=nnRl
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
