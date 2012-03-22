Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2CVLuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:50:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48927 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757357Ab2CVLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:50:12 -0400
Date: Thu, 22 Mar 2012 11:50:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: gpio-regulator: Set the smallest
 voltage/current in the specified range
Message-ID: <20120322115009.GG3091@opensource.wolfsonmicro.com>
References: <1332396484.3842.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5L6AZ1aJH5mDrqCQ"
Content-Disposition: inline
In-Reply-To: <1332396484.3842.2.camel@phoenix>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5L6AZ1aJH5mDrqCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2012 at 02:08:04PM +0800, Axel Lin wrote:
> Do not assume the gpio regulator states map is sorted in any order.
> This patch ensures we always set the smallest voltage/current that falls within
> the specified range.

Applied, thanks.

--5L6AZ1aJH5mDrqCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaxHZAAoJEBus8iNuMP3dNFcP/iBt9y7sPeK9A8OH0cF1tfi5
cdSA0oJBKCZomO+lSD3sD5Ax8TiJqO7wiTwoDyXTrCfqWJ/7ayADvlBJD0yGhCXJ
v6l1++YK7Ex/GJUJF6Y7yHZSInqNLE4t+tDJpXZqdd08jCuHNsCwuOKuFdBxua0Y
NSWoKoiNhoUQGAz137ru2Svqj0/X/DI9Fl+eqpGhgRFF1ggwaSw96kvRPN/PxMtA
uGuYlU3yLl0lcHnRyn4Kdgj2n9ZrNBF9yVyA+p5FD/YlPCcxk6rKNf5zCM0zVLtp
CV+TwNZY9XpGxfYfVQaSu/ZmiSZ1a33IEhzOrCctMaPkaQQyKFAJVC9K+gymt9+M
059CLszG7mGLicPNxP70zVALwrFCq0IXqAq2ZUq0pwxUzewLJunA6Ymz2+MqV779
rAh2WjT9eAsHjdBraWdR1PiIsZRNoP4ajxc5OZLiTnimzb7YvXc7mmkTeocT+qnT
VdbM7sZCB8tbo+jHtC/rldTMq+JaOdNiGeAjc6ufBI5rmDc919I//KhH7Wv3qiwp
Qmh6MnBfi19QmCrvneqEUSxMskfXD34qj1tZyNSoe0vUzb1ZAvB/qRcyeNSezb0k
OVW6rID9p6KD7UaHO1isajF5rs0K8ROa4vEs+K9RzqrKSbgcGdn9mitUOsBy+WZt
Xz2zaDVGUBb/yHwpLXYP
=rLWe
-----END PGP SIGNATURE-----

--5L6AZ1aJH5mDrqCQ--
