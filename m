Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2ECKnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:43:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33470 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121Ab2ECKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:43:48 -0400
Date: Thu, 3 May 2012 11:43:44 +0100
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
Subject: Re: [PATCH v2 3/4] leds: add LM3533 LED driver
Message-ID: <20120503104344.GC3955@opensource.wolfsonmicro.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-4-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <1336040799-18433-4-git-send-email-jhovold@gmail.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 12:26:38PM +0200, Johan Hovold wrote:

> +What:		/sys/class/leds/<led>/risetime
> +Date:		April 2012
> +KernelVersion:	3.5
> +Contact:	Johan Hovold <jhovold@gmail.com>
> +Description:
> +		Set the pattern generator fall and rise times (0..7), where
> +
> +		0 - 2048 us
> +		1 - 262 ms
> +		2 - 524 ms
> +		3 - 1.049 s
> +		4 - 2.097 s
> +		5 - 4.194 s
> +		6 - 8.389 s
> +		7 - 16.78 s
> +

Shouldn't these be controlled by led_blink_set() rather than a custom
ABI?

> +What:		/sys/class/leds/<led>/id
> +Date:		April 2012
> +KernelVersion:	3.5
> +Contact:	Johan Hovold <jhovold@gmail.com>
> +Description:
> +		Get the id of this led (0..3).
> +

This should just be a generic LED subsystem thing?

> +What:		/sys/class/leds/<led>/max_current
> +Date:		April 2012
> +KernelVersion:	3.5
> +Contact:	Johan Hovold <jhovold@gmail.com>
> +Description:
> +		Set the full-scale current I_{LED_FULLSCALE} (0..31), where
> +
> +		I_{LED_FULLSCALE} = 5mA + max_current * 0.8mA
> +

Shouldn't this be set by platform data, the maximum current you can push
through the LEDs seems like a board dependant thing which won't change
dynamically at runtime.  The brightness can already be varied.

It'd also be nicer if the kernel did the calculation for the user.

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPomFVAAoJEBus8iNuMP3dwXYP/26BDCj2JjFnbKVydftL4SXY
bXWCVd8s1vyKT6O+1REW6+W00GMJMV0q+CKeLbyk/aJu3I8f8aAiKnYpgcImxnmB
vA7QxdsCRfpn4LbVa4lFYQ4SBzVyMpEUG4WAL6Oo8Yi102EskprXu0PhMehrQNyK
gGCBmxnZf1gIep4aytRBN2geAdWAcG27rkIWXBDD9/Ijl7u6XK9CrIx57sG4Qlnu
fKXQRuzFxRc/kPwfrq1Tmc7WE8T13SVDRksxbpssmMmvan+sXOTIJxuaZaLebPWg
l6m0+nnpjsfqEsGqtMoZvuJVolGfBFCipyEDSdRbBy9uzXlm2V1vBpapqp/3kmQ2
SzWV8e2ykDijaghkttGiLmecarLYjxZCRkNSWJwW13CNMDg/aUle0o5F5SchArrx
eL4R3QiiHaworVKqn/OGjHP1x2YYASHyTIjNLPjUdBkdTZryKWWKIpJ3HKNldx0X
rWVt1HpEKM2hywYurA+zT5raQkaVW7odM/DF2LFIk+Jm6Bal9iuLn0eA9Dp/fCbv
WHTAwFjq82UtJS364InYV2QjS7fKT+Op7QQoyC2oqTQslJhtTyT2PVwdH3lQyqbE
XzEKvzrXMXcY8QDuF5YLtBRMnupUiWhsEJ7lfcfGnc9bvm+KFoAxB0lz33R063EV
HU+IjxgVk0CnQgxD8G7d
=80WU
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
