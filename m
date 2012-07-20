Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2GTJnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:43:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53061 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab2GTJng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:43:36 -0400
Date: Fri, 20 Jul 2012 10:43:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqdomain: Improve diagnostics when a domain mapping
 fails
Message-ID: <20120720094333.GN4495@opensource.wolfsonmicro.com>
References: <1342776799-8482-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjamM5M9kpPM/bcu"
Content-Disposition: inline
In-Reply-To: <1342776799-8482-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xjamM5M9kpPM/bcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 20, 2012 at 10:33:19AM +0100, Mark Brown wrote:
> When the map operation fails log the error code we get and add a WARN_ON()
> so we get a backtrace (which should help work out which interrupt is the
> source of the issue).

This needs a v2 - I had some other stuff in there which I'd forgotten
added the ret variable, will resend shortly.

--xjamM5M9kpPM/bcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCSg3AAoJEBus8iNuMP3dblYP+wQSxrv9Nqi6egU5X5V2+H29
L2QBBps1BXNEn9mmXBUB9xxOA6nqzG6welujfV3PUjtqoT9Cn7aDWouz/0MD7nRO
APAD4T24N4kCJzoZLW6jqv4Wx46Ch0kIHXBdhPOsHJ5qpZiTSmb8EcnEWpg3mAio
WpjbJlq60wbtiioZ0Uq7d4Z2Ii2kqqGljlwz6u8UsKzxhozWtYhhrywMKNAHYXN9
uIJroSP74FAxvF2ENJ4X1aFfu8rimw6b5nS2DeVILx+2bWn0kF28bVhB8n4rv1Cp
S2rQVrb8x2T81AH2pTf/KGO6ljcf2Ld4pOnaGcfE7QoZ2RKSQq5nEA79OV+6NdsQ
wLfmYNi5Jd5qmauZCQbmcwWjMQaQQaVp0HyhP5TZjPGE4GUykIldiHDkQnV5ffoM
Ro0ZIi22jX24K6EO9ExcriU7XXLukWppokeh57LgqNm6iRDddRrD1rkGDmwd7rRV
qddKG9PW7WUZQpC5CiERWJJBEQFLVVXpEowyrgnoYgzIeQPGOtSWD43ohepSFviq
KzPeCzvGFgJEEuabC46vxxJUYclH2BH5T3csMewpFEo8gaIjKZvbeND+f1SVu9f3
3/Zi/itFo/lDhjqF6mtKkLOqE1zhi47taEl5pCDkYLQuD/O0f6v3PxcztxF0toia
qK7o7Mtw4FQDvQK0KGBL
=8QOU
-----END PGP SIGNATURE-----

--xjamM5M9kpPM/bcu--
