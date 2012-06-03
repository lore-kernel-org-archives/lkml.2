Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2FCSh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 14:37:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43673 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab2FCSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 14:37:56 -0400
Date: Sun, 3 Jun 2012 19:37:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator
 tps65911
Message-ID: <20120603183753.GA26676@opensource.wolfsonmicro.com>
References: <4FBBDA97.6000006@wwwdotorg.org>
 <4FBBDE06.5080806@nvidia.com>
 <4FC916AC.4060804@wwwdotorg.org>
 <20120601204052.GB4258@opensource.wolfsonmicro.com>
 <4FC92990.5030104@wwwdotorg.org>
 <20120601210451.GC4258@opensource.wolfsonmicro.com>
 <CAOesGMgYAR938F8PnVWaymzMBQwDKeAiUgEP81bv2nN14NmLGg@mail.gmail.com>
 <4FCACFB6.2060601@gmail.com>
 <20120603120506.GG4258@opensource.wolfsonmicro.com>
 <4FCB8CA9.40602@firmworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <4FCB8CA9.40602@firmworks.com>
X-Cookie: You are number 6!  Who is number one?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 03, 2012 at 06:11:21AM -1000, Mitch Bradley wrote:

> >What device tree seems to need rather badly is a way of representing
> >key/value pairs -

> Perhaps ironically, the fundamental device tree construct - the
> "property" - is a key/value pair.

Yeah, I know - the problem is when the value is itself a node, at least
as far as I can tell.  It's also frustrating that nodes have this user
bit of identifying text that we can't seem to use for some reason.

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPy676AAoJEBus8iNuMP3dgnAP/1nGZPU82o4zcr7oswuksGca
2jh7hSaLhMk2yfhp8W7Ctp6gZxOCMSYqQ7+lPkg+Si/lgGzsNbdn4Mw/LadlYOco
4tYl3eIXiShN1CkQaDKz7Cvdk8gR5pOjgnk0PrqUBmBf59w5hkxAe+/Yqn19Lyqh
6vKMN93ZD0fd8eC9Gy8WTxQUJ/h1qu+eD8dDB1m1ZeZf2e27Cqlja0meYpNm1Y1Y
QV5cfCFUajoMM7Eg4qf18arXGP220gqP4WU6zt1VRfjXLMqv3VvEh+u2OGU5R6ic
M07M7h/BRmvDC/3xoiUYDKZrM1HwXgWDggoUWIzIsbqaUgC/4b4OF7v/w63doAmQ
1BFd/NaJhi3ApFhXQb6O2fO2NvA1CuM28zAHpWk1LASgDAjMES4eaR0cEvzhtRMe
Ftc3l70pqXLORdbGm2RY+6O+4KIhPfpZzpJINxHwzCLeicUbyFitilnD/t2vj5gj
cU8GP6Qlu7kS/PgKmVW1qpcEmryIX4IwkdWIgGVW3PyE8XTIrCLUNogFe2GlxwYm
xPROmdrKlkvlPl6A0Q0DsjwndmrXumvBSlx3XluaD1DleL9O2bpTHqcIgMUzLVCq
wyTH0qCGD80ej2j/FrbCM0qeSr4mwULoQFpN5X11EugGTSxAUeFxXyGer0JTNeTx
pKmGPOVeir89Zbx2x3xg
=xL82
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
