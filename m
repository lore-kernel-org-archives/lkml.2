Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1A2Vvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:51:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab1A2Vvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:51:48 -0500
Date: Sat, 29 Jan 2011 22:51:41 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.miao@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [RFC] add pwmlib support
Message-ID: <20110129215141.GA3493@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
 <20110129213821.0e51dc32@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20110129213821.0e51dc32@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > code is inspired by gpiolib support and tested using the backlight pwm
							     ^^^^^^^^^
> So I believe that hwmon drivers are out of scope for pwmlib. Which
> makes me wonder what you intend to do with pwmlib (back to my first
> question...) as the only use I know of for PWM signals in computers is
> for fan control.

It was meant for backlight control (was mentioned very indirectly).
I also pointed him to Bill's implementation, too.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1Ei+0ACgkQD27XaX1/VRvjkACeOhJonBEZQX8U+ihKtiMjQT/U
IfAAoMdZiOrAOvuH1Iv6ZKNYoT+VhhTM
=ROYN
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
