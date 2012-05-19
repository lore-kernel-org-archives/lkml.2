Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab2ESKol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:44:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60675 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab2ESKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:44:40 -0400
Date: Sat, 19 May 2012 11:44:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DT support for input-supply of regulator.
Message-ID: <20120519104436.GR4039@opensource.wolfsonmicro.com>
References: <4FB67D9C.2040909@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOEfHYdX8LquYLAx"
Content-Disposition: inline
In-Reply-To: <4FB67D9C.2040909@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qOEfHYdX8LquYLAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 10:19:32PM +0530, Laxman Dewangan wrote:

> But when it looks for the device node containing this regulator, it
> starts searching of the props from the dev_node of parent device
> i.e. pmu: tps65910@d2 and in search, it does not found the
> vin-supply property. It got property for compatible reg, gpio_cell,
> gpio-controller and then no more property.

> Is there any issue in laying down the regulator structure?

I'm sorry but I'm having a really hard time parsing what you're saying
above.  It sounds like there's some sort of device tree specific bug
that needs fixing.

--qOEfHYdX8LquYLAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt3mOAAoJEBus8iNuMP3d+LIP/i1BIOpgqRYatzHDpjWORw/A
cgxiCVyLcJp9u4k94pudUhRMMmYgZSCu3W7TotsISDJby5xvEZaFvnmEJqBqX5Fd
xOQKhGeUP/bLXuJpIh4pSD0f/5L11I+3n9UpJ+x7/4yuu5qiGgioOiPnL+y/302E
oHLFAsucyasGRrHjDM+lT3l+zxfuNyraq1SYR3w3pzyYWK4xOcgp9Jjr7pBk6OHx
+2ovfqPZC4qf4zOiPy6JEBYvNeeKo6jq16BgjjM2J0UjeoQCN+0A4/L6IycPfYAy
s1Q2q/8Srq42HL+xgt630JwPRNDpoAZzoE2ZB9dkcVpBZAQ/Fjal9K9CwxRk3Re9
KfVx/wv1EJH+HAEOWh+wYmC1GkDAhxz+zQDpBPaZ2rAAEu3H5qEY04RJsaJ4NKIS
pcmkKnKBqmf+TuxBTaVrMsXa09iPzgI5lSo2qHworpOCXoumUASJsF1mRpKZWALW
c3xHKuIadFLG6piHmcjUwgkBnjKpeRTOSSiWJ7j+sJbQRUJn5TPFhLAn16NxoSwN
/H/HFH/qp1fUnTL6KaTzIOHbK1q1bQoC2HkUUdRgc3zfT4fDP4Atz3yVNnTEAaQF
dFn0CvraRn7WEd9oqnDcyMGZW1KmpIg4NFMdp7ARLM06mGgyEF/JN7t3Se+YqdUm
/5wC6gyGvSS2hZuHRFld
=ybdJ
-----END PGP SIGNATURE-----

--qOEfHYdX8LquYLAx--
