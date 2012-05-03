Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2ECOvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:51:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47120 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312Ab2ECOvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:51:13 -0400
Date: Thu, 3 May 2012 15:51:08 +0100
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
Message-ID: <20120503145108.GI3955@opensource.wolfsonmicro.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-4-git-send-email-jhovold@gmail.com>
 <20120503104344.GC3955@opensource.wolfsonmicro.com>
 <20120503115059.GB15752@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCSxeJc5W8HZXZrD"
Content-Disposition: inline
In-Reply-To: <20120503115059.GB15752@localhost>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dCSxeJc5W8HZXZrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 01:50:59PM +0200, Johan Hovold wrote:
> On Thu, May 03, 2012 at 11:43:44AM +0100, Mark Brown wrote:

> > > +		5 - 4.194 s
> > > +		6 - 8.389 s
> > > +		7 - 16.78 s

> > Shouldn't these be controlled by led_blink_set() rather than a custom
> > ABI?

> led_blink_set controls the on/off times, but the LM3533 has the two
> additional rise and fall-time settings which determine the transition
> time between these states.

Hrm.  In that case these rise times are very large - I'd expect them to
cause issues with led_set_blink() users?  Though actually I suspect the
solution here is to pull these out into the framework later; we can
probably simulate reasonably in software with a lot of brightness
variable LEDs.

> > > +What:		/sys/class/leds/<led>/max_current

> > Shouldn't this be set by platform data, the maximum current you can push
> > through the LEDs seems like a board dependant thing which won't change
> > dynamically at runtime.  The brightness can already be varied.

> I fully agree and it is possible to set via the platform data for that
> reason. The end-customer, however, insisted that even this setting be
> available through sysfs to facilitate their integration and testing.

> I'd be willing drop this attribute if requested, as it would only be used
> during integration and could easily be added back by the end-customer if
> needed.

I'd strongly suggest removing this for mainline.  If it's present it
should at least be limited to the maximum specified in platform data
(just for safety if nothing else).

--dCSxeJc5W8HZXZrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoptPAAoJEBus8iNuMP3dnG4QAJZ8QTyGyPgEBIQu7u2wLHPX
+3T6HRWNeshaF+PCv23EyHr+YmOW62yQa3Z450P0Zym6LfIO3UiciCMOXALariUz
XB+ynKoKW+5e9jbaZv67fwMZ31vjjYo8x5B4D+ueEIZTZFy0RQqgUoqYxDo0CuQt
b+iAjRXy6/Bg890VYmL4lBTzfrDfco33uSJYCow0ixNZ237aCZnNjVEMks4TZ10O
+cLkGiUqtQ6BM0SwD5JNITiPDjFcNyHj3rJbkfoD5Y9kXZq64f1tmTi1Lxz7KnnE
PMMjIv1BEcuUPbgn1QiWE4VR8S/ShpE7j8u5bI9z12b3XYucaI8OMOiorPdywylZ
Yc8suNDg4lSZaADcWxPwcEP36npdTiA7rVvHixnl5aMzFYxceq4RdPxLtDGW/Znh
oLFEHVtt18Cw0lMXPjOB2jdgdyL+PmQxtNSRkWQf6tRgJ+SjEvbB7URW1BbU0h78
9JlmUf1LaQdEb9Nuoa5H4jtwI8IOkBKE8G0UZMbJrSfxiqvEYEGCJ6A2H3Kma6No
7evhq3jT+EaSd3vgKgcWU2pVOrMbPi+20PhQ+hPuJw5Rr1TIllp6mSqhHveHw0O5
UWWM/kVLzdPM02V7nWMJ9H5a1IzyfMs5a5aLj12A5VKUh/7KlcKAGlity8+cgPWt
oXUONtw/gd82qeS0QrPY
=mn64
-----END PGP SIGNATURE-----

--dCSxeJc5W8HZXZrD--
