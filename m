Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2EMQnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:43:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36080 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2EMQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:43:09 -0400
Date: Sun, 13 May 2012 17:43:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
Message-ID: <20120513164304.GB6381@opensource.wolfsonmicro.com>
References: <4FAB15DB.5050702@googlemail.com>
 <20120513122946.GD706@sirena.org.uk>
 <4FAFE1BF.9050805@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <4FAFE1BF.9050805@googlemail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 13, 2012 at 06:30:55PM +0200, Sebastian Hesselbarh wrote:

> One question that remains from my original RFC is the missing
> clk_unregister() as i2c can be removed there also should be an
> function to unregister previously registered clocks?

One of the patches I've been sending adds a dummy clk_unregister() for
the sake of making the drivers look nicer - practically speaking it's
not likely to be terribly important as these things don't get unloaded
terribly often.  It looks like that patch didn't get applied either.

Mike's stuff is due to hit -next on Monday so I was planning to refresh
my driver and resend it then, probably with the unregister() though I'm
considering just removing the unregistration code to try to get make it
a bit more likely to get applied.

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPr+SDAAoJEBus8iNuMP3dGQoP/1u+gLA29jKSrP0Xdeil/eMw
6zFr7EeaDyhianDKj83hQEgpV08Yj9i9j/QT0QVC+ThVvDE0fggn89Yo9EBoqfXL
OEzOdVTHVbwyiXbSWZg1wn+Dq76yCCUxAz3vlqhYqvJcLNFSpe5VsKTmmpPKX56E
2G3rHT8sGzw2llYZTWmkhG7+ixLSJT3rVtbZI2zEpLbXtVyNqlgWBZ1aXz2sQOXx
BxKPEMmtP7Y5ajVqLL3LXeGsJgcp7+4eAq1GRoElT56NNw6m57d9iBUMLGgoYLsF
BZE+4ZbbIRLvY6z9WorLfbSFPHwXFwY+eFQ2FZVujin5ZxmxHSQk8Xbjq6BMnYQ5
7Yyrj9laYsnfGdUN3US49/wlSTZRPC5bb1ZMPsUhsAnvMyTp6PC2ozJEZl7OLhlR
9TBwF8xCtYJSM33su6hS78Y4X0Duu9bOadV9SqEBA0PuRfQqfxxqoRi5rFRg4+aC
EGIKy+U2nWqaZbUNN8JRITWBw8lKDxE3UCaNbU+52TrCg/PUda+umDOf6avrg+o2
pHodbD6lDHIsgMobcKynLyXaJ4aFXnLB4y9rvobsTvuQJ2FLEvMq07c4epjHdZxn
nsNMlOKcVSs+aweVUrUICX4zZFlV5cWhgZUPx67obgjEgzsAfkV1T6AGwmcw37lG
tGxmrQo2gThIFa3iLQwQ
=U03i
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
