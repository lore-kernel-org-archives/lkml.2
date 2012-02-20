Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2BTC1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:27:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42851 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab2BTC1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:27:43 -0500
Date: Sun, 19 Feb 2012 18:27:32 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 4/5] Extcon: support mutually exclusive relation
 between cables.
Message-ID: <20120220022729.GJ3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-5-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <1328856038-21912-5-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 03:40:37PM +0900, MyungJoo Ham wrote:

> +What:		/sys/class/extcon/.../mutually_exclusive
> +Date:		December 2011
> +Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
> +Description:
> +		Shows the relations of mutually exclusiveness. For example,
> +		if the mutually_exclusive array of extcon_dev is
> +		{0x3, 0x5, 0xC, 0x0}, the, the output is:
> +		# cat mutually_exclusive
> +		0x3
> +		0x5
> +		0xC
> +		#

sysfs really isn't supposed to have more than one value per file so this
should be something like a directory with one array element per file.
It'd kind of be cheating but the values could be used as the filenames,
though serial numbers would be more idiomatic.

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQa+KAAoJEBus8iNuMP3d/hsP/29/JTAPJe9PU9nGzo1axVE3
dQ6Fq8StWmSh4Nk5i5/cIgqU9ACsYGs/XQI2s13g6koGRpkFDmc64zOTsViIfIUS
usR8F1O4Udv86yRA2GiUXLa8zvjJbK7tE5sFVHRfEYan+0PURlrObkhH/5DSN4YF
8KUBYKFqbc72Bk2HjdZlve10kxs7TqtU0osm2G4ypg0LMefhshYi4273/8XjwqgH
oUj8X3ZSiI+uRNGYJwKZkhlmUazTcgEX04nnz+wpo4pteL49K/0DBW8HbgvFGauf
Njyd5xgS6n/gx07Aj+Mc34Rg2+nFTVjccv0Vfb+r8bqxxQZGMHZ+aR6xCxDzh3kY
SdAQe5BFzdZLVvsoBqG/cdaD+rhaZjF34P+vs3acYnkJ/F768PQfPIoPlUpCumsI
Nrluf2IAx5Dg0z82WFb9lC0aN/1/Nue0zk5iqUBVIbIUJQ4Aa6Q0svVMm3cAJVaQ
79xWm+oWoZi2mBMUE727GYfonkCbRJbDRA0vnZ6jFE3uDP3pHMopI7OyM994iZfm
i90cE5E+rAm8b4pb2I8joSWcwicATqA4gd37E6W2Nfoou9uqKOLakAf8+eOSQw8p
06mKGB+hRyKZDUF6GkMFIyIsCLFsZL/MG+TjHMkBhVzTOWn4Y1CQ+mf7pwwNk1Wb
oXBxFDtlmeWli9mw54Xl
=WgFS
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
