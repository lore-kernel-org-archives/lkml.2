Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319Ab2COM4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:56:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53849 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761821Ab2COM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:56:34 -0400
Date: Thu, 15 Mar 2012 12:56:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
Message-ID: <20120315125630.GK3138@opensource.wolfsonmicro.com>
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
 <20120314172915.GB13393@sirena.org.uk>
 <4F61BEC8.4030008@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcccYpVZDxQ8hzPO"
Content-Disposition: inline
In-Reply-To: <4F61BEC8.4030008@samsung.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcccYpVZDxQ8hzPO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 11:04:56AM +0100, Karol Lewandowski wrote:

> Introducing separate type (TYPE_S3C2440_HDMIPHY) has been our original
> attempt to solve this issue.  However, this required adding explicit
> checks to driver code all over the place (if (type == S3C2400 ||
> type == S3c2440_HDMIPHY).

Another option is to change the type to be a pointer to a struct with
quirk flags in it.

--HcccYpVZDxQ8hzPO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYebwAAoJEBus8iNuMP3drkYP/1PZa56oyfKw8hJd1h9L+IZv
RKBh7G8R2Z3Yx/uLDIP5PlhYoPOdMeQ9ngg4svOh27maeDvhEXgXO5jP2nzxjCOo
Su62mR8sozezGe2OO6cFkX4zaa6I48gexfiSZzkMpr16HEkRXd5Cu/aSO4ruF50R
yduSDMPZVuiI/fnlKvYpSKmkOhVUfgRNI+Zg7qbV6YqQLDjsP5EvEia7NU4h3T+B
qs1RWcZC67LRvuDBWfB3akTHtoQqPAMLGqvqXgZfFOT860erAAVTfBj4jQ/1VIwo
blaycDLtSAD6iQhtXE6HL06exP57GBtfYnXrFdxFu0OtyMRsgbpUeYFPuNE9japD
dcC+t5gmGYrG8yVYtUjF607kP3HgQnKHDD/JmbGDo66IBxQC0F7gYJh/LBNstMK2
YXZLi5JEmUMuvMlNQ/aQE7HdzVf4m0FiJHWCNaL8z7cmNF7HLERHARvW3WlT3vgJ
2SMb3vKq9EQWQs0wvCqMfdROrVEXO8pEdjYwveZdiMXqNheCEuyPIjqG8tPPjwjv
M41QcfsCTwdZIfaoJlCAPc/qiw7HmlyFOlXvFIUrOrw6d0/06XYJmSoS5h5EQhyy
z2jj70jFdWTejb7ZBixO3RRD+J4j7psa/A7LzrlgJxKoDnhiITn6OHMwaS6UAVBf
ihCC5yudMnNesehNatHt
=NmrA
-----END PGP SIGNATURE-----

--HcccYpVZDxQ8hzPO--
