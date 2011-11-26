Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1KZK31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:29:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46319 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1KZK3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:29:24 -0500
Date: Sat, 26 Nov 2011 11:29:15 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: fix nowayout setting in s3c2410_wdt
Message-ID: <20111126102915.GA7517@pengutronix.de>
References: <4ed026d9.TvJLr8ihQ2VtvqPD%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <4ed026d9.TvJLr8ihQ2VtvqPD%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 26, 2011 at 12:38:01AM +0100, Marc Vertes wrote:
> Set nowayout flag in probe function, otherwise option is useless.
>=20
> Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>

Similar as

http://www.spinics.net/lists/linux-watchdog/msg00704.html

which depends on

http://www.spinics.net/lists/linux-watchdog/msg00703.html

which has the advantage that it can be used for static initialization.

@Wim: are you fine with that old series BTW? If so, I will resend and try to
get the RTC-ack from Andrew.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7Qv3sACgkQD27XaX1/VRuJnQCgxd38tD7eogZ+5boKo7cUGIVr
O4sAnjVDRbktchLhMkkAdfrhPI41nIBN
=FRP9
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
