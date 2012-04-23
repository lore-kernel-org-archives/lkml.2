Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2DWM0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:26:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50346 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784Ab2DWM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:26:00 -0400
Date: Mon, 23 Apr 2012 13:25:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120423122555.GM8318@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
 <20120423101804.GA8318@opensource.wolfsonmicro.com>
 <4F953455.3080002@stericsson.com>
 <20120423110522.GB8318@opensource.wolfsonmicro.com>
 <4F95495D.4050508@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline
In-Reply-To: <4F95495D.4050508@stericsson.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 23, 2012 at 02:21:49PM +0200, Ulf Hansson wrote:
> On 04/23/2012 01:05 PM, Mark Brown wrote:

> >To be honest I don't entirely understand what your goal is at the system
> >level - the current idea is that either the regulator will be marked as
> >always_on or it should be enabled by a consumer.  What is the scenario
> >in which neither of these is sufficient?

> The consumer do not want to enable the regulator directly from its
> device probe routine, it is handled through a scheduled work.

> Moreover the regulator shall not be switched off unless the consumer
> work decides that this is OK.

Cann you be a bit more concrete?  What is this device and why does it
have these requirements?  The most obvious thing to do here is to run
the work in the probe routine.

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlUpMAAoJEBus8iNuMP3dEUYP/2ldbykEH67BtQDY3kK5gUY+
bCQOBFh1fkRJBem7BwavSKPcf09z41ZE3KR/buwc/yLKhuI1bQUCAZjKs/anE3Ay
JT3Wr6v8MbVaqjMlKlzYmKQy5q1Q9rCz2soH3fUjDqoLpygQzg1dnc9t5OiZV1aB
LaziYfmYsGoF2YMrKX6A8xN6H5TIWlaROmDtY0yCgAWVCTXMzUp9AQr8AAKDDZep
TnhojJNb1aRal38BCQl1E01WrWwXMVNVTGTwHMQD9tHC3xBdNwQu1UkbeUTkOiXw
72LYqIap7zumnF2o9l219lSSzDtlCq+96kG4RzVP9XTPugS/MCxpDzXYKz6U2CLa
zTcpxkt4uOYlgIlyO9GQ6SLRb4youKn2IqjwrMY9d6uPL3qskxlu2sEys2Ek7sLX
rauQRp/aVRkrtcH8HNf86NlQ61y2b1khbYa3PVdV1dKVQH2kz3y4lmKKslT0cDKg
OA5cbCo6Fo9js3+glHqiAF7JYIeRjTus22UrSP0ynY1HzY2yxASqBSwRs3WBjCMI
dOap3kkfmLbkwgrViy6BgFEC1rUmAPmrcDrkAhjMTR2YlwjbHLUnowJBggZbvXvh
WvHtYLTzSFjxqu3EIYBn89LSxJ+oHH703MrZMsZ06Gl5dqPEu7sgyZIve9QOeQh4
uHSvAmey493EEbmqlQk+
=0vio
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
