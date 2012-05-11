Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab2EKUg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:36:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37144 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932157Ab2EKUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:36:24 -0400
Date: Fri, 11 May 2012 21:36:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, linux@arm.linux.org.uk,
        lrg@ti.com, swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3 2/4] regulator: tps62360: add dt support
Message-ID: <20120511203619.GC29835@opensource.wolfsonmicro.com>
References: <1336718325-8372-1-git-send-email-ldewangan@nvidia.com>
 <1336718325-8372-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <1336718325-8372-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 11, 2012 at 12:08:43PM +0530, Laxman Dewangan wrote:
> Add dt support for the pmu device tps62360 and
> Add binding documentation with example.
> With this patch driver will support both device-tree and
> non-device tree registration.

Oh, sorry - I meant to say that I went ahead and applied this.  Ideally
the active discharge thing will get factored out quickly though.

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrXg6AAoJEBus8iNuMP3dyHsP/AgtZUk+LjHHIbPdLjrCB/dX
u10Xi4RSFSP7sgKVR/A7WuifEfXfzmykJDVkRGnKsWvfsNc/QKr5ZTZWcccGmCaI
hZimnp95b3KReT8y6vj2nQbXprnxb561Yu9wNuEFv5BCOih1oNZfO272JFqqtaXV
uBlxVySimxwnJFt9zvxqoZ5htIL6WohxXXbG8NfnU/5hH0g1zopIx7thV/k3rS8Z
SeQXAKqPIWn81cPVp7Lm5rKtpJXaYmIE3Zg/QUG7xk/rtMClP/D932d4yPY8kbff
dOCWjuds1RpnfAftXFLJx9AgRcvG4ruKIImvfF9V8r82GQICLra54gYiH5Cwfvq5
tEnoNhD3d/l7KTc6vZMKvVyuT6iL9K+bfVmTK+4y7T8W6s1Mb5jtlcx6wF3kXdla
uO1POwCEavqtNnec0mVcqZxPgQAtyYKi0l9FmwNYNJYKvgN+dSsZy96ZW7UCHwNz
L18fbuDsLYesTCLBnA/JQS8dJ4oDsXIP2JuHoI1QdpaZH9k5kYezGf6JDAU0+2fh
BkQ9EhIHU/iJG13n3LoOcN78tS0jMXGz8QpwNsc4G86AR1sQRhrqt/SiNRpDYuCP
WWlyElLYE8kMTiebivTNF6nVhVqe5tnDYsXLFOGiENLB2FCl9vLc9xbzX4CYvMUw
85ygqBYtBE+1jnIEhFpu
=tC4w
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
