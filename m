Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2CAQR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:17:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab2CAQRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:17:55 -0500
Date: Thu, 1 Mar 2012 16:17:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: bad commit in the regmap tree
Message-ID: <20120301161752.GB10915@opensource.wolfsonmicro.com>
References: <20120301105425.ef188f8724204c55ec805929@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <20120301105425.ef188f8724204c55ec805929@canb.auug.org.au>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 01, 2012 at 10:54:25AM +1100, Stephen Rothwell wrote:

> I noticed that commit 0308333a9987 ("regmap: Add stub for
> regcache_sync_region()") is the same as its parent commit 868d3fdeaae9
> ("regmap: Add stub for regcache_sync_region()").  So the function
> regcache_sync_region() has been added to include/linux/regmap.h twice
> (the context is not sufficient to stop the patch applying twice).

Oh, I had thought I'd pushed it out already but was just trusting rebase
that I hadn't.  Fixed now.

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT6EUAAoJEBus8iNuMP3dhMEQAJCo1ZCQOU27guB/BvFFq9t0
61nTyLzIMOJPTj6tPqNOGt5p+6HXasYm8JZm8r4RLfyc0666mup9XUvwBJp5aqO3
0o8GwjykJyfWb1ULTsg1lnet986oCOytQ/f9r4TW1xZO6tIis3dMAn/zdN9k0LC4
qT6MJkJ5rRj8d6zy98Z84UttRLpWd8aTkfJYabsDCXcK7KskcpPi0ytyjC239d+g
bpkl/ekLpq6eCMMGMBJb5Ax72JIIMeHLNvUJKbM1r0LV2SPxaKqEzEbsvkfNSxH1
umdz9WHh2e2o7YgLt4FI3r7qR3QR0cYdtZPNXWjwkHNokaekLCNS04Fhg6x98KTn
RI8gROvDCvwBbq3N+3NWjDw00J1Aopp4cpiBbPzBzfFZ9FdQgnK9q47LXOVaayep
Xhu/qR/mgVYyEYLAnnQU/qjrU/56CLQzWeHJHIbge9KJsEAAWGKelrrXtZgbR5bg
ZSbOhpRx81CCEh3pA3bC7vBOEheTkSckXhMF+CwZazlBielOt9KMAp4Tas9dLEYh
eIyCvQ0mpNeqlBzWgxDJssC6r8dFpxr74/8CL4LilTd8gimJEQ/qzUXcJDW88DNJ
sL7d3VzfGmcgJhNZzJXMkTksbt6DygG+Oe70q0GLVkL+S/P/r4Gn+rkXjbF+CMy1
YI+NlzCyI3S77BJUrlSG
=rmY8
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
