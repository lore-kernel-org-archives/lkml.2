Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222Ab2DLOsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:48:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36177 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964991Ab2DLOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:48:38 -0400
Date: Thu, 12 Apr 2012 15:48:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: regulator: core: Don't dereference config->dev before NULL
 checking for config
Message-ID: <20120412144830.GA3181@opensource.wolfsonmicro.com>
References: <1334208502.15182.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1334208502.15182.0.camel@phoenix>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 01:28:22PM +0800, Axel Lin wrote:
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Already fixed.

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhusQAAoJEBus8iNuMP3dOjgQAIjnavwo7oKfb8gcNJfN2HIQ
CUT2liSwmd5kHDD9HxB0UwEEerUDNbqxttowpd8Slmeocn3dOdUGdAn5b5Bfiloi
z4hkPQD8fQMAVRyK7iwNOibkiYriZ5SorqKtSIrtrAPvHn0ZMArKy2jGe94MXzGt
NQOqdONHHfOob3KOJHi+/8uLWavwyq5M7fVzExAHfe+tduISXYqwUyDMchlKGnNG
v5cAGCDfyJgntPjE+SsL2u1YgtA35hmOYVS27lzWEvLGclr1w8NryTjAZe1Gr3Oe
ikXKIkWEiEk+m3YLVlADFaKHKTVWDIFOZ/3ohxvlfp+DSJWUN/F8A9yP6mA4pCJH
lD8L3fNCT8v4dA9MbIJolxZTJdhjlajH/Q4A9s5VPHB21LyHwPYotPdG+SEhwCqR
G9/VT6yn8FdVIsxzh7PdsqolYk9yr6I5uOaElzw7TlmfO2Kgru0s2GVgzmwRl4jT
foqRXjEBOY5rLGOSX/NGsh7G7lp6ixY+4feCciv4GG+E29PZcB9idrmYYrO+cr3D
RF1/96tXwltZRLUrTnzb6WknEo81z99GemFUrsmwScczeE3hr1A94+96lakJfY+U
pn1LCwP1/W/SkigTyC+VK98bydiWdIs+nnlvzL8FT+JWj8l4Tp8tkXg2n8AoknPy
LXgw5s6jsw3p+/GUZdUQ
=TV6j
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
