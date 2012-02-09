Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab2BIWJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:09:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56575 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758552Ab2BIWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:09:30 -0500
Date: Thu, 9 Feb 2012 22:09:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Miller <davem@davemloft.net>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix mc13xxx regulator build on sparc64
Message-ID: <20120209220925.GO3058@opensource.wolfsonmicro.com>
References: <20120209.164301.1049075777681222673.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bJ3jXuwtxrXxD2iT"
Content-Disposition: inline
In-Reply-To: <20120209.164301.1049075777681222673.davem@davemloft.net>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bJ3jXuwtxrXxD2iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 04:43:01PM -0500, David Miller wrote:

> Since mc13xxx-regulator-core.c and the actual drivers can get built
> into seperate modules, you have to export the DT support symbols
> "mc13xxx_get_num_regulators_dt" and "mc13xxx_parse_regulators_dt"
> otherwise the allmodconfig build fails on sparc64.

Hrm, this was reported in -next and fixed with commit 234393 (regulator:
mc13xxx-regulator-core: Fix the build when driver is selected as module)
but didn't get reported when the commit was first introduced...

Given that allmodconfigs are one of the most commonly tested
configurations for -next I'm wondering both why this didn't get picked
up by any of them and why this is a sparc64 specific issue?

--bJ3jXuwtxrXxD2iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNEO6AAoJEBus8iNuMP3dGn8P/1pA3Hbwy4MDQ3ghoLf414OZ
Bg5BevEZs35+qhQLOnELTk9Gbzo/FckZUfmxElgqflMC4De4cVlbwwbC/Q+LIhci
Q6YcAVznqeTDItZoPH/Ilsm+vFlq6X+ZHcw9XzXzdGmTYwHiU8KHYnqJRnZo8CUv
xdGQahUb6B/aogd1jpClQeXtHHaloIiiS4LrsKo3yCyRsTXlLcZbNiI8EwJRQpKJ
QIKrntmZLVrH8qqe7zGgoCLkJSIwLUjkVw3YBD8X9+3oUySU84pRIx/4oNrTprdi
9a/t2OZLPf8PhHkNtgoMCknr3yTrMljKQP76D7wU5O7OjAZmjbU/EMQSMoMYOKA1
bTZ8c3Wu1pRNOfv074Uanj8inBV8TVOZKpmE2NMn3i2UbenA1DCL//E7L/lEMiTw
SinSbRhQdK1E3DjgfbZhig3LQLrGNeETUmfz+GMzsHAp8wztbOfl46EwDn6blFUa
blg6gLhIu5zR5yMSyloiJmJSRzPWm7d8YQgfjYVfZwvqkMEsXDswz2STXX03eD0l
za//7AbV1M76CWWIXywuobViEwNVhhYA9t13W/efCLF/q2cfLizMOlzl55RBBXKr
zuEhge/iyK8Bnvjvq9IRl5STDEWGEG7wV8IKUmI71drj2aItkk6GzftQQW7gX+a2
4oFPz2nPS8WwCcsazUdR
=WgmO
-----END PGP SIGNATURE-----

--bJ3jXuwtxrXxD2iT--
