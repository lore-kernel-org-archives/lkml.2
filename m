Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2EaQoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:44:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60339 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758031Ab2EaQoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:44:20 -0400
Date: Thu, 31 May 2012 17:44:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 4/4] regmap: Minor optimisation for _regmap_raw_write().
Message-ID: <20120531164419.GL2666@opensource.wolfsonmicro.com>
References: <201205311622.q4VGMHGe015484@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1X+6QtwRodzgDPAC"
Content-Disposition: inline
In-Reply-To: <201205311622.q4VGMHGe015484@sw-eng-lt-dc-vm2>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1X+6QtwRodzgDPAC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 05:11:38PM +0200, Krystian Garbaciak wrote:
> Just to make things simplier inside the function.

Again, what is this actually doing (ie, please improve your changelogs)?

It looks like it's just factoring constants out (which hopefully the
compiler can do but still is OK) - this looks good but should probably
be at the start rather than end of the series.

--1X+6QtwRodzgDPAC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx5/cAAoJEBus8iNuMP3dD/0P/2D+upE8S94mjEg6+BX5yiOR
gGgoLT9Qf9xBAcB6rhCzVweLuww9+PW0EStDnw3j6gtfTAs6TAB7SSDoNuFU+Lcs
xO3EK0nSbbAkSYlCaNiqVRtENkZ7jj4kp9v1WpkKHSTq+tomTgGHs4K0NCj9iYab
n/v6YNSjP2GtxEI6oMIu1kLNo5VtLEzTjnyVYVHQjfy41vVTw+yL+3MJ13K3Y6np
9nSP8UG7zUwHTM+wl/bJrGr3NEHE4FY4Pe0XyKIUMprRvxqAmVWUw/SuxGkGj01z
jy4dx7uOFZ24qpB/Sq0MKEKoEic1sGQzQuPKRA7fa4NJFtN2QszSWGKxCxhplJhv
stcyt3OeHTVUzVvag5Hyvn56E/P/0WG4tM52Bi/JTT/L6miTO/+0VMfUOCHh/ErZ
UbzpZ244PkMyKZee3ZcGpw2wv4t/zGutQt+pDt4ft3jjbzanFB9R/e+VTbC2ljFM
kG592Cp4R+vBsJrqRCQuMuyGvdb0xAnJT99oabp9BQJj/rk1bAq9pgbzkfwfsbPm
LRTOnc5Dfk313lnruK0nXh3R3KMXZOxPfPxYO3y6gUGm6RJVuAxGYSv5tG5gsxus
9WcmossGsOXgIEf3vGES/UumhW6AXCvxOfrEgaQId1ov24TLi5XAmRWgPUikDchu
zXyFz8tShYQp2X9NocRu
=yd60
-----END PGP SIGNATURE-----

--1X+6QtwRodzgDPAC--
