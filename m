Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2GTKOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:14:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2GTKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:14:06 -0400
Date: Fri, 20 Jul 2012 11:14:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: mc13xxx: Remove extern function declaration
 for mc13xxx_sw_regulator
Message-ID: <20120720101404.GV4495@opensource.wolfsonmicro.com>
References: <1342758634.6777.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZXzThk3vFZecBD04"
Content-Disposition: inline
In-Reply-To: <1342758634.6777.1.camel@phoenix>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZXzThk3vFZecBD04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 20, 2012 at 12:30:34PM +0800, Axel Lin wrote:
> This function does not exist, remove the extern function declaration.

Applied, thanks.

--ZXzThk3vFZecBD04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCS9QAAoJEBus8iNuMP3dB80P/05O85xTpsVhCglQ5rOsjtwf
54o9NZrLMHBsBbo/EauEZCWtDO/LxHFavQxLp6ur42rtqNA9GTKy3c4kG//XI+yR
GVIq/v+XuNWwHUa3AS+BddAqL7Cvbxrmz0VX6Ro1JFEgJAscd1ldlxVK6BdIbLCW
D7BuqVBD2rxVDOU+Mcb5334E6+wUlHeeYINZ0Pd710dVkFvWGynEZL1BC/yFzl5t
JKObpByT4bSwAtrebabRrS1x4Ih5CYXYPJcora+SeXBGF9xB4LoDy5vPQxRh1sZs
MvQoJA993nidugiB+oVvJU3Ju9nzw4zwPyhh1VXGYLttzeERgKFvnuXrOrQpVFiD
PEA4hRXTRq1YewJIrh/uuXbYhsa3khMHmRK/15SKMXnThdv7YaUUb06T5l85RCoS
XUwJ1g1jeVpV5lQjO9WQQ6wchQyl67SJbIo5qDj9tQUAsUBxgPXVHtlvL4uKB7nh
XiKhifZp/HBfbT6r8SAdhPahBoZqiL2bOEOYY/bJVLIyqn852sWxkx+XETGWBrHf
wCY4VP54NTVJ29W431/rwjrCa8cHb7kfcn+IafVLyYh6OO6jtBwtD46DCw2aJCYP
BC5p/6l9q8gXh4YbU7aSbv7BFl8TzQUhGweLuTAdDW/4/vguuva83UNW5Cb5gr90
Bz3ZzYB/g7g1uacQY0eB
=GG9X
-----END PGP SIGNATURE-----

--ZXzThk3vFZecBD04--
