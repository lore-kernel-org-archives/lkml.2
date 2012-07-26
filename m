Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2GZPYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:24:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60068 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404Ab2GZPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:24:45 -0400
Date: Thu, 26 Jul 2012 16:24:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120726152442.GR3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-21-git-send-email-lee.jones@linaro.org>
 <20120726115055.GD3099@opensource.wolfsonmicro.com>
 <501150E5.6010503@linaro.org>
 <20120726144336.GL3099@opensource.wolfsonmicro.com>
 <50116005.6050008@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOr5JpMIiGv/Oaxu"
Content-Disposition: inline
In-Reply-To: <50116005.6050008@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zOr5JpMIiGv/Oaxu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:19:33PM +0100, Lee Jones wrote:

> Okay, so your suggestion is to strip out all of the sub-devices
> under the AB8500. It's doable, but will take some restructuring and
> thinking about. This is a job for another day. I think it's okay to
> continue with the current semantics for the time-being. The line
> we're discussing does need to be split out though. I didn't mean to
> merge it in with the ASoC stuff.

Yes, well any that aren't reusable at any rate.  If you could relocate
the device into another SoC integation that'd be different.

--zOr5JpMIiGv/Oaxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEWEvAAoJEBus8iNuMP3dc7gP/3X+R0n3oHn9a5jis3fUJN6Z
bKkOnPzGVc5UmEgUMgX/YhiUQkxyKS704sT6PogZXURXJA/u8g1EBW2uFdidBLkd
VdCd746SqeCIvZQhC9aFv5Pe7GlzP3u4JWpk4zKzXHghMmYkMGcnoO+rJ+4zvfwA
DgG5iL/2mRlqWSc7SZI2CKZRR0/AkpSvqCQrmM8GnjuqXhi7Bm2XoPz6H1rXiHyx
yafxTEJ7Akq/kny/hm0hFEz7Kq342kcxha9Ge572fjYZaHWfIx0cLWZw6rjWSy44
szQ/O7RNbEUoBWiQfpzD2jNMLQraRgLZpjH6Zd8BiX2NbQRAVTKO8xIVNx733Hz+
YlyfUSGVIjZ0BxIfFWmw9c5TXoA9b+kL0J2hQ6dQEvLBP4l8es1grU4bXZol7m9P
6qVQpw6F2pjvezFGT76prATyicW0+edNKKdg6gKYYh7o01NMVykRnK0AIhGc3kOh
dPeJQ6qxLDWp5YYRFGTKL/9F3foTAU5UhyXNlEbe/gOFqoX2YmyxS6iHgFIvG2PL
4Bb8DVWDkuqDKZm4uT5ueZ6RqWPgzAPdiwDmJxf+X4ng9kx1SlepVdCxa/yaGl18
sI5rCm1Vwj9fIrXENq0o0lnYT1lZBeQXtueNk+xq9UDOMTtqczvPTh+duNzatdJK
KJ90WDMhi1xErUvWF0Uh
=V/FS
-----END PGP SIGNATURE-----

--zOr5JpMIiGv/Oaxu--
