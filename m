Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2FEKmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:42:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55408 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2FEKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:42:04 -0400
Date: Tue, 5 Jun 2012 11:42:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/22] regulator: Change db8500-prcmu match names to
 reflect Device Tree
Message-ID: <20120605104201.GR23408@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-10-git-send-email-lee.jones@linaro.org>
 <4FCDDE58.5010501@linaro.org>
 <20120605102900.GP23408@opensource.wolfsonmicro.com>
 <4FCDE0A4.8070107@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aH/0uqREc1VzwMkO"
Content-Disposition: inline
In-Reply-To: <4FCDE0A4.8070107@linaro.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aH/0uqREc1VzwMkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 11:34:12AM +0100, Lee Jones wrote:

> >>Are you sending this for -rc2?

> >No, nothing about this looks like an urgent fix?

> Well without it all regulator requests from DT will fail.

Oh, ffs.  Why wasn't this mentioned when the patch was posted, and how
were the original patches tested?

--aH/0uqREc1VzwMkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzeJWAAoJEBus8iNuMP3dBIEP/0zzFhnlYgZoJ4nwfvEi9n2I
FpK4YDvYUW62Ml1UKUjYrEWWbiOJVYiAXNVyhEdAWtjLqzsgAYjt9mvpfP2mKYdw
UiCLs9aLgNZBvIK+a4PRMM442qrZjIbSJJtIE8eOHv1L66oQ5u20uX+2pnwMul5W
FUQ365vNI/wjgBsQnDA0huIV+gQlp7LYlL4xU6jeGlpzxsW8xIlkULL7MRrN6UBD
yFNhiOvEnXmOxOUOy1hR2CmJG0bUYsCseak/FNUiuu5MofhdkibF2KpqhtYq3chx
xbkBVXeYLanBEL5xcN6roWv2vOnylL09O7lJFWY5AUyF9z07zjcDUSEKAe5/wVmc
Un7gfUbitizOwiDQuvHhgnFqZIlUbAIxeviDFZwtqaDf1hHWWDCyx9F4VVLXyvq5
1dsnwSEqTmn437SSuSLDt1cITyad7NZpoBwIo6AbB8yCRPiQ+yw4QwXO+LCoFac9
ghpKZUKSnExwVNs8PUUqGhe96+ciHxcJW5ntwbDRL1CEsnMpvMUehy+gEVicAsJA
lL/4OrKFn9cQJL92ZI8grdlYDVJjDV5WA6vTBa2QdaPm54V3hgrQI/+dPMc5jEwZ
XGHy/tqU3SwLj34kRdEv2929xeIls62A0rwPESOSLWQ+2fIX1RDlKHGkiG3QnMHD
prXu4MFO6jgIaojXqmIu
=e3aF
-----END PGP SIGNATURE-----

--aH/0uqREc1VzwMkO--
