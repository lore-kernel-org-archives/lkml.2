Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2K0Lc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:32:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51102 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab2K0LcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:32:23 -0500
Date: Tue, 27 Nov 2012 11:32:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        collinsd@codeaurora.org, khilman@ti.com, tsoni@codeaurora.org
Subject: Re: Shared regulator usage
Message-ID: <20121127113221.GB4468@opensource.wolfsonmicro.com>
References: <1b9aae54f83056035d83c049a7ac1876.squirrel@www.codeaurora.org>
 <20121126134719.GI9411@opensource.wolfsonmicro.com>
 <50B4A0D1.7010707@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <50B4A0D1.7010707@codeaurora.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 27, 2012 at 04:45:29PM +0530, Anirudh Ghayal wrote:

> At 1.4Ghz the cpu-freq driver votes for 1.3v, then the CPR kicks in
> and recommends a voltage of 1.275v. Now a set_voltage with this new
> level (1.275v, 1.275)  fails as it does not satisfy the limits of
> the cpu-freq driver. It is not possible to tweak this range any
> further as it would not achieve the goal of micro-adjusting the
> voltage to save power.

> Such scenarios are very likely to occur in the future on embedded
> systems where there is a need to conserve power by introducing some
> adaptive voltage scaling techniques based on various parameters such
> as temperature/sensitivity.

This just sounds like bad software design.  You've got two unrelated
drivers setting the same thing without talking to each other even though
the one is trying to adjust the voltage set by the other without
actually knowing the voltage that the other one set.  Why are these
separate drivers?

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtKS5AAoJELSic+t+oim9OasP/RbXlM5sIvHN7PT5nImbIYjH
K4nn96BLhWsex9yX4yChT3bkzgni1e3CJXSveJmf/ki8Gj3+6HrWxvoqrepcbvee
upzL7bAH5jdnzV1FGMG2JMGCf9fwlBoZm408UBoloeNBNdlGHNW4uQTEv7kY2GJ0
2iV91SDwqo5xtMT06RBJTSOLyl+mVZmWbIx4DgIAQohZQnHDg3ec/WqkeX1ILM3J
w5OpceiWbmSvwiloYW984PGlq29gPz2npRcxe12m90amuRsNtx7DE7v1ZZk93wRk
lz7BrSG13pQl1tJki3eDq7QtNkC36FjUy2eo/DYKC31mMEwTDdlP8xjtlGXGaUM8
stJUw4pEQfZ4oqIkM0moOWwQ1TB8xA/zu11J3hOE23H36nRpLzDdEy5G6hYFlQ2T
n3/SIUuReK93xc+tLFeCgnK4Q0Kh94qHF61vr5MNoVM5HQ8TDK+Z7LBlUqXLQioI
1tKqSoDK8Mp/cMzFw2t/NjkDdZv6UfRjJnEOfMuoDYrZEEzzOwlziUhJwfQKogNG
u3JI93X07ap/obUqc7metmOpPqmsqPzdkqThdx0UgBTYdYCFU6cwxN/XR6ztWJvU
iZBrL7lVqioNZxYqtbfrKGG5cwqBzFp+HPh7dBaKlwRRuqCkDREsEOxEWIHUyIBQ
35hw75CoVxAKoend36fF
=fz2e
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
