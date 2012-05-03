Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2ECKiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:38:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43344 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574Ab2ECKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:38:52 -0400
Date: Thu, 3 May 2012 11:38:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503103848.GB3955@opensource.wolfsonmicro.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <1336040799-18433-2-git-send-email-jhovold@gmail.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 03, 2012 at 12:26:36PM +0200, Johan Hovold wrote:
> Add support for National Semiconductor / TI LM3533 lighting power chips.
>=20
> This is the core driver which provides register access over I2C and
> registers the ambient-light-sensor, LED and backlight sub-drivers.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though

> +	dev_dbg(lm3533->dev, "read [%02x]: %02x\n", reg, *val);

I'd expect you can drop these log messages, if there's stuff like this
missing we should add it to regmap.  At the minute the regmap logging is
via trace points rather than debug logs as you can leave them enabled
all the time.

Might also be worth moving some of the sysfs stuff to live with the
relevant drivers.

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPomAuAAoJEBus8iNuMP3dGzYP/RRhvihM4RxQYmx0YBkTm8U7
ohi9ZbGh8VybP9Ab0liq2FRufhrEM4WLn9AgnVqwuAMrBKcUGfYmC8mvPhMpPrTe
z42KAL2G2bdoes042F3gOIVkzEX6ARH1kRYP2WTkOaMqB1zXp80EPbGPtzohQFOB
aq9Oeoyrk5FP8RNeNAXDRAIXGCL8JMbnXI77DbVlU+AEcGhfVHPXe9M7BOQhd167
cu3dvgKBVFlLnWPKVCdOIGB0T21n+MUkHjNM8YMtouPPJQWBJW3s9gtIFFlJhKlX
N0sjVex7Uag36cXyRTISChcGaaGTmxdmmRC+9cc/jXkTALSdyg8fTZmW5AJShDK4
rN8cZ0VMxlbStKOMfaNxjcFnZT99HPy4yqlFsHJ5TL7+4hF1bszql2C6JXzm5x5Z
hYd69a4zTBozG256Di6bGfTlq+Z7IlAusq8gp34+rJngFaguEKF31qQ2sSd7QWnK
eMDRdJyPtCa1r7+tC5/Bte5ssMOrGQqsLFHYf9rXOSoOpCN2wkQn30yzkAC/ZZOB
Iw0DBJRs+UgWQQ1Wd3koonMu3W4yT3K8cnv7Xsc+LDrXOm6rSlE8jQu+acD8R4MN
RJctRjEhAQf1J/6bOeC0NXXR1RiFD9EvRLuN+FfVZP8EoLZNIObwE3KDUSHwyiVP
XX3c4VG3X0AkP2mA0Z/m
=r8lq
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
