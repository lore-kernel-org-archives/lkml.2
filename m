Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1BUJsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:48:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57978 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1BUJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:48:01 -0500
Date: Mon, 21 Feb 2011 10:47:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Eric Miao <eric.y.miao@gmail.com>,
        Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110221094756.GC2616@pengutronix.de>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com>
 <201102211009.31381.alexander.stein@systec-electronic.com>
 <20110221091916.GA2616@pengutronix.de>
 <201102211037.19572.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <201102211037.19572.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> We had exported our 5V_enable gpio to sysfs to allow a user-space applica=
tion=20
> to enable/disable devices connected to 5V circuit.
> But on the other hand we had to read the current status of this gpio in t=
he=20
> power-fail interrupt handler to distinguish between false-positive (5V=20
> disabled) and a correct detection.

What about gpio_export() (description in Documentation/gpio.txt)?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1iNMwACgkQD27XaX1/VRspJgCfb2SiLkS/Z4fFEAmCogLA45fr
OPgAn2fbHZKsVMBWxPWKH+jIwoL0NRvv
=9xrN
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
