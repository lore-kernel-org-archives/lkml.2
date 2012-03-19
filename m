Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032792Ab2CSTzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:55:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35359 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030753Ab2CSTzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:55:43 -0400
Date: Mon, 19 Mar 2012 19:55:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
Message-ID: <20120319195540.GH12384@opensource.wolfsonmicro.com>
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
 <20120314172915.GB13393@sirena.org.uk>
 <4F61BEC8.4030008@samsung.com>
 <20120315125630.GK3138@opensource.wolfsonmicro.com>
 <4F621EC9.6020106@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2NLGdgz3UMHa/lqP"
Content-Disposition: inline
In-Reply-To: <4F621EC9.6020106@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 05:54:33PM +0100, Karol Lewandowski wrote:

> If you consider code to be inherently less readable because of this
> approach I'll rework it.  If it's not a such big deal for you I would
> prefer to keep it as is.

The thing that was causing me to think the code was funny was mainly the
fact that we're now combining both quirk based selection and chip type
based selection into the same bitmask.  If the chip types were quirks
it'd probably not have looked odd, and that might just be a case of
renaming them - I can't remember what they do.

--2NLGdgz3UMHa/lqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZ46JAAoJEBus8iNuMP3dGgkP/RQpJ1YPK5e6mrLjrIplCMc1
lVJEVBVloDF70KFFIGj6SWVmf6aqwW3mMANpGlGnFPSG6H4nd0UbtUetKTYqmh2y
0mmb2nCmuTN47u7EWayrVKzBuG616EJkmXGJywxtmBzPAy9vIAwsrpc1DZ4bNS59
XyNZDcVr8B22ef4BRiietQ+HBtzhPEWTNJYy35dqKHSuwLwgl5jv6RykD8oLYbbt
2nduVPR7itWWdhmaskjlhvGr6Rbm2SLypBbcJJlLXFghoTjyAK5my6RyWAd6sjwg
UDM1vSeAijpC1Uk2CjjGFqk4HUc29XT6dq6dcqxB6WERChU/hrrGr1uh323Msbct
wEAOJL/RZbn1RTo4k0YrFk8e6mMqZTx0W429v3gMt/6NyabjCAXFFZ5ZeW28XGE3
59zVsFmNbRmSWmvmU8YqbmuvRjZX4rWc7QhPgIf0ao4S51Sz1z2k5qIn5EsJVR/C
v7ilhi0HBmVPkoobaUktBUePkZULd4sNUJlHKn0pWkYbrfiIpb8U7ns/ri5WNk9C
fx/EGtNd3hT3AKa/EUweWgQTOWQBTFIe1F/cfNaLHYTtsDfibwWtlrVYypC9dUT1
fjKXD9sa02cddCB9f3IZuL85R2oOEqdkvfMtZlDCuNX1F1H46qvXgN0b6rn9KbHh
INpEOLy1sWiyNpAcL6Kj
=R1iX
-----END PGP SIGNATURE-----

--2NLGdgz3UMHa/lqP--
