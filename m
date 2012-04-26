Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2DZIfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:35:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56224 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab2DZIfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:35:08 -0400
Date: Thu, 26 Apr 2012 09:35:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120426083504.GA3207@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
 <20120423101804.GA8318@opensource.wolfsonmicro.com>
 <4F953455.3080002@stericsson.com>
 <20120423110522.GB8318@opensource.wolfsonmicro.com>
 <4F95495D.4050508@stericsson.com>
 <4F954ED6.2040201@stericsson.com>
 <20120423180140.GR8318@opensource.wolfsonmicro.com>
 <CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 25, 2012 at 09:04:01PM +0530, Jassi Brar wrote:

>  Shouldn't the bootloader be responsible for ensuring MMC is
> put down after using it and before passing control to the kernel.

You might want to try to ensure that bootloaders always do the right
thing but I prefer to work on more achievable goals like world peace. :/

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmQivAAoJEBus8iNuMP3d93MP/3Re+83gXRmvEniYK2BDirSi
BUAqCnt9bq5Mkw8XdfjoWT9M/uI51JXnsfGmKC5Ub1K++TUNuQyxOMyyWwaN7M/e
2J6TSQK+uYeN3WjUJzMbno8S62vd0p+fJj527Rn0ePq+uniZ4ihvbuo+KQUuSd3+
ei+cbHPko8lCki4oi1dW9SGYFCgxO42tIwajfdqwxaEaeR/pBda6DuSgiX+1rrfs
uZJgV4AMb0tg7hc1d5xbnFtSk1LRn9UlA9tN4Fz4GQo1uvrnaCB2DSEoj2vDrHMG
KoDknaEoHLFqQGR3JAbD/eht+Pw/0vBVlolIELnD15mbNGDf3OwOoQaN4COLmXzo
xA/5d4Yx8yLzi3QCj4kAWN4/9N/htVKwEHCUI5K91wzdDJSvMA0O7f6XHP8ugWNO
gSbUp4fXMaqXefyK+8ne3UWHhge5JEVeBVLXaHiUPn5M61BEnOGD8c1yxmke5G9G
5svJk+jq1fCaRzcDqHWNpkIMaz55VWsn+ycOAy9t1NJ+8vOmPVAO1qg/NiMv6xBX
IHrkM6Uj5muvZxqkSJ6kluq8C7rzEIp9spMsfqvkRaKf1dBpggPsb2Xm0IHTC/vt
4Y9roQ6X0GGmJd3woOEO13wm76cvZN1RRFrI61pJurdwWmhYy5d03P7pRrH4MUYp
pMd6JeFEa2Gp+XwNq4l1
=Y4gO
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
