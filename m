Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2DJIke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:40:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45242 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758546Ab2DJIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:40:31 -0400
Date: Tue, 10 Apr 2012 09:40:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>, Liam Girdwood <lrg@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] regulator: Fix build error for ab8500
Message-ID: <20120410084028.GD3149@opensource.wolfsonmicro.com>
References: <1334036844.15859.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Content-Disposition: inline
In-Reply-To: <1334036844.15859.1.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 01:47:24PM +0800, Axel Lin wrote:
> Fix below build errors which is introduced by commit c172708
> "regulator: core: Use a struct to pass in regulator runtime configuration".

Already fixed.

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPg/H1AAoJEBus8iNuMP3ddhMP+gI9y5pH1ZmJ23TabjlCE836
LXeTkLe3bLXEFyUUkWqxtuBmbkcNPSsvY/L7PBFEM4nVxg94RjvD0j1HOfB/cnHF
WvOijhtIHnKgZYc4H8RQ2xMEsewtHK77EKs/Q1Y0Z6LRTZM+ZA41nQVnuHbYSDpK
wvSXBikqGt2E2BOryHjSP1BvAe07m2NDZb6iar2+DayxPbOs9RHMGlPyc19w3OKJ
41ydhWGNe7keMgym6+zBAgmnKkOFlwb/RcfziuCiVhM0XlYfZGnENUG9LIgtsOW7
yux7pa+qwKBy2/RadfcSqaHo4pIsj32mSbseaeZiWIU1E9Yny+1YvJTfd2j4eTVd
oYtrqs5sYXZ5z5vAgetA+ZWvpgWcioNNOt1AhqpeOIRtx599vTxl70mdFn8LG6kq
FH55IEmrq2dbdFOCHMqfD845ElQcUH3aUMNpCnSS+OYAednG6zYu4Q4QG6pyTWOR
Edz0a30H9w2Ogyg35KviBwa4DHOkNsCMXfkN+Xc+GhxvbeHi7sGvXsNPlX80+KQj
ObtnGkPPbCX0rVLBsVL2cUy7b3sj6ZlK+Nm/vxEFWkA2Vtqmsp7/LUurK921vX6X
5tWXrMrLRgtGVRl8luYxBacMUDq8oIt6Lp5BLmtEKG66pyQMyFG+/swAef3a1tam
YEKIhnOx+L05kQUTNxAd
=RMgs
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--
