Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2BAOt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:49:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695Ab2BAOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:49:28 -0500
Date: Wed, 1 Feb 2012 14:49:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@st-ericsson.com>,
        Alex Macro <alex.macro@stericsson.com>
Subject: Re: [PATCH] mfd/ab8500: support AB9540 variant
Message-ID: <20120201144925.GE17170@opensource.wolfsonmicro.com>
References: <1328094155-3320-1-git-send-email-linus.walleij@stericsson.com>
 <20120201113154.GA13723@sirena.org.uk>
 <CACRpkdZjh6J_=DG58DkWO0bnj2Np3ujagcdOgNtYq2GfN30uRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <CACRpkdZjh6J_=DG58DkWO0bnj2Np3ujagcdOgNtYq2GfN30uRQ@mail.gmail.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 01, 2012 at 03:42:59PM +0100, Linus Walleij wrote:

> For newer ASICs we solve it by not providing platform data
> and instead fall back to reading chip revision.

Given all that it sounds like it'd be more accurate to say that for old
chips we fall back on platform data - fall back sounds like it's a
failure mode but it seems like the opposite is true.

A more idiomatic way of doing this would be to register the device with
the appropriate name and then use driver data in the i2c_device_id to
pick the appropriate variant data up - this has the added bonus of
getting you a free device tree binding.

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKVDtAAoJEBus8iNuMP3diqYQAIAAf40VpIk8lCX0H0nZ0Ipx
Sqzt2il1lT9O5GRzZy9o9QX0izOKIdqFBgJ1bu4kReEZFaxn4Kyxe25BHe/aKnt+
2iIukz5h3Z2kC/lbXoGuOCp5Qlp8HFVYkRXhkfT/7v1PiGmJ9xqC6DgdiXiXAdTP
b4GgugmjPQNi9tf8J2R5JyNf3wte4lETunU8PMVRhZXtKph2okeVvRJdC0U/IMav
EvwpgoOM6STUx5z4oXpIQfJRgELMz0jB5F8kMXdjP6AenanA0qm9+E8l5w+AwJYW
fpjcOEjg9/mea9Tvy8Gsxw4HrY9H5n8nXFdFDxxx305QHTXwbArNaMRxhtQ2sv8X
XZ6RID9HuANRo8aVWaJq3xKvlqX3wrtge6lh8q87eWsvN0/uB8PU0rMl+kSOWJqA
qfVK0I6WaLax7qtuK4coO7qMduIgW+ZziioQHCW9FdWfmYFLWTR/rW3BGtqK7Ad6
h/vzaVC5jSWHJVqIVizQX9RBzNZlL7mgLJ7/hig6+kM9H2oBuy8rPY0yTKp5RpU2
D7NNf33z+n2u5MfNV4EE5S0GHT3dM9AbG5+nT1ZuZPJo3IM5gE4ot7N4OQXoRZlj
OAeRMb6BCQ85z3To1k+bNWK7Jb087Guyy76mymySRoxEBSf1Iq6oYCEVveAxE+pA
C8FZcvdJVdR/hxV8R4Az
=0NjT
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
