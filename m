Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2FMLvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:51:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57706 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783Ab2FMLvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:51:51 -0400
Date: Wed, 13 Jun 2012 12:51:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 4/4] regulator: wm831x-dcdc: Convert to
 devm_request_threaded_irq
Message-ID: <20120613115148.GK4545@opensource.wolfsonmicro.com>
References: <1339467650.22991.1.camel@phoenix>
 <1339467849.22991.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M0YLxmUXciMpOLPE"
Content-Disposition: inline
In-Reply-To: <1339467849.22991.5.camel@phoenix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M0YLxmUXciMpOLPE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2012 at 10:24:09AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Again, this has issues for driver removal.

--M0YLxmUXciMpOLPE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2H7JAAoJEBus8iNuMP3dnh4P/0Gw2FI6b3rM9OgZmm7HzRIq
GSEw80pM0L1eI/IYES5VxbmKiihtqxCy8D8v/EeV6GnZNslFugJ6N6hE8DFJjVbG
0NIP9aphr13lGkBP08QRGhen3DXL7H4HuQmu1gIWMJQq+Mtq35p2dd8PoXenB9Xk
8i5rSGaweuCDvlZ5tMFyQAncoEuhWxAN857Xxf0SF/qjsv+a3y1XkIUzHwEJ7ifN
Yc7BD+GR+t+iFRd03BI3UnkV2gRgRqdh2RYu/SEohfoMxPnPHZb5lEa2wRWYQhoY
b2R9nITmeDi3gUYIVaEg0Gl7hDjxaewDE1U7lwtxwokxzBPOX7X5oLYXbkt5BXEo
W5xPkMB+ccVY3CL7Gf535tFiYjPPymiaCQy/X/G/ShpuXpPksuU2PJpCoTns6KWP
Kht9jrH9SoKViX0m9j6p5bzCNZLeiFSoeIWZxdvwtgAaraWNlurYTFYY0DWTkwFH
htS7Cq7nTg+gNg1NT/q/4t5BjLICpXCgz2wwEBdOMuUZGIYl2ibPESHaC7ui/b9m
nG7+Tp1DzXoMoYYwe5rbWB4srwtHCY4Gu1HCnDj5lKMmNpCAtXOjjC5Y38o0O4Ba
b554A2bj0drxg0ASil7uW2ZMIKGEFwujhy8PfI3ANTCVqod5ITEAUal3iYHOiPAx
y6Ns5fOSf+pb48qSf3YO
=g04Q
-----END PGP SIGNATURE-----

--M0YLxmUXciMpOLPE--
