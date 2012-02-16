Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2BPWdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:33:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab2BPWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:33:12 -0500
Date: Thu, 16 Feb 2012 14:33:06 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is
 not empty.
Message-ID: <20120216223305.GA1231@opensource.wolfsonmicro.com>
References: <1327112659-31145-1-git-send-email-arve@android.com>
 <201202160051.16011.rjw@sisk.pl>
 <CAMP5XgfpM8309wHMW+W0XrEYvsz6pYdcwdqxkp-Jgpbm1m5hgQ@mail.gmail.com>
 <201202162331.07051.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <201202162331.07051.rjw@sisk.pl>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 16, 2012 at 11:31:06PM +0100, Rafael J. Wysocki wrote:

> Can you actually select what keys may wake up the system from sleep
> (I mean "real sleep", when the whole system is entirely off except for wakeup
> devices)?

Yes, that's often possible.  In suspend mode you can get a two stage
process where the wakeup itself is triggered by simply looking for any
electrical activity on a set of pins.  This generates a wakeup and an
interrupt for the keypad which then powers up the actual keypad circuit
and looks to see what the keypress was.  The Samsung keypad driver in
mainline does this in runtime PM, while no key is pressed the keypad
controller is in suspend mode.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPYPXAAoJEBus8iNuMP3dLZoP/j5lM+XoPCXtB0BqlIqbsJlu
lZOheseUJJITBgbFDlsnDw96pYwiDSzoGAzNQLeQWVHWjZByN6syOZevaQ8llqiy
GEK2q5ifdnX4q/nSVqBYpnCJ9+xImn8edhkRGjZM/TbH6YQdCUMrmey7vkBPjH82
HfDpk41Yh+2Yn+IZiF/kltrYCdEj8JSqRHb2flCuzitWw+3oi6/Aik9kw3yVIk7Y
faDad8bePZ5skEzt86pXV3p9XYNvpwH19xiXVGgkKx5dsAi6oMHKHRlvTqVwNDC5
3bN+OtnL4MNC/JoAZc4u8olyZaEHeU2xTtToP8cK5R8ABZfAks5M5qwc/q7+oaoj
pksdk6OwJ57RGfTkbhsn9ASdzYduVqaF5+Ok46UNUfS1YjKCWOMNSp7GxC7Ub+IA
ETYvPBO0Jo9IQgfGtb7RIhdcSAmtcRTCx4qkuh90hj5PkDEGLoAZOGi95rj9ST7L
uwz9Dd3dzXo5XqrrybxXqgfnydbBo5I3r4xO9P93YHajxjV9xyiyxu5IISzRJpnz
fMOqhGhNq8zUEqui/pdPgB0Pbp1dCrTmrSXKkA3PNFknH6GfsK0k9/MGd7rfQ1hJ
kn0vL+hXTu0OtZjkZiNXnyC9hMfUVwgZOPS6SXAudn2nGLZhFjDgVf7jmo4+SDFO
shezoI5+vvi1IgRzEd4V
=eE+a
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
