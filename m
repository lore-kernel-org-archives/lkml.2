Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2DXUJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:09:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47138 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2DXUJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:09:52 -0400
Date: Tue, 24 Apr 2012 22:09:29 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] i2c: Add generic I2C multiplexer using pinctrl API
Message-ID: <20120424200929.GC30172@pengutronix.de>
References: <1335289664-21383-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <1335289664-21383-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/pinctrl-i2cmux.txt
> @@ -0,0 +1,79 @@
> +Pinctrl-based I2C Bus Mux
> +
> +This binding describes an I2C bus multiplexer that uses pin multiplexing=
 to
> +route the I2C signals, and represents the pin multiplexing configuration
> +using the pinctrl device tree bindings.
> +
> +Required properties:
> +- compatible: pinctrl-i2cmux

=46rom what I know, compatible-properties should not be linux-specific
since devicetrees are OS independent. pinctrl-i2cmux sounds
linux-specific to me.

So, is such a binding acceptable meanwhile?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+XCHkACgkQD27XaX1/VRvwqQCgiaU80bU3P6v8Ba4mhyrQyN/Z
8Z0AoLNQTuSCKcfGTfA+m4qcFAQNdvLR
=iKNu
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
