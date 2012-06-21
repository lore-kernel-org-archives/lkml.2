Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2FUK0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:26:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57273 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914Ab2FUK0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:26:55 -0400
Date: Thu, 21 Jun 2012 11:26:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: wfg@linux.intel.com
Cc: Jingoo Han <jg1.han@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Kim, Milo" <Milo.Kim@ti.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [mm:akpm 117/143] ERROR: "devm_gpio_request_one"
 [drivers/video/backlight/l4f00242t03.ko] undefined!
Message-ID: <20120621102651.GS4037@opensource.wolfsonmicro.com>
References: <20120621101721.GA12365@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zu8lIfFVzXMVnfzp"
Content-Disposition: inline
In-Reply-To: <20120621101721.GA12365@localhost>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zu8lIfFVzXMVnfzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 06:17:21PM +0800, wfg@linux.intel.com wrote:

> Yet another error on devm_gpio_request_one()... Interestingly the
> patch title says "export" but does not really export the symbol...

Yes, this patch subject is at best misleading.  We really need to get
the EXPORT_SYMBOL patch merged.

--zu8lIfFVzXMVnfzp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4vbiAAoJEBus8iNuMP3dz6IP/3O+hlOeKSvY7ZMjZmyVSlVO
gi7wWS8+TqCHmarq0EVd6liB0fbHmVmseSrt1GRyDDMjjQdWbqRoINZpM4DFmeG2
gFdPOKhN8h3SWO56B4q/T7Kxf320xJYC/9vRj+Vjmsv9q+r1d9FlifWNHauMuVCb
NFqE93X6lOQjpjS2RIxiCfnjhrKeMjZC10m9xkdAc+UzfLlua2vqj72cFgorAH6r
rmrIWGIIsdbI5plu5nkOcZG3I5AglSg9E+7oD1NK7uh/E2saG/UfdrDvGVKhMWtK
ayK/1HfgBhWUVt39WqdHDh3IS3QFrmlLRWFVgHdPrbLb2SdWSdlqKuv8Z1gkpYPl
a48dpuyPmj8xfZlzMqCby2mnERz/vPQ9D/uaLJyTuos5oFozyinfE7R8TOYfiQIJ
UOGJ+pwHqMAjdLKIlqtbWYVYE4T2uCKm1lrpzvMTUp8pvU7Kr087ayXk6Yx6OkNs
hBd3h5wEufpuatuKIGMfYFr7hwKesfx5H26lix1+7cl0WitXeGNmXQPhLCvTY+dk
oMuBRlQ1qm2T3+/hzw/1QuFIPrOPeS6Ib/ONfzkaM9ypF5mGmZ8qrm1XnpvDkGBd
ysOWYdbvS488BLvBAVUhcwiunpjAvT1hrNHOyDsZsFSAYyAZmiXWU7SDVzF7Jka3
ku5/QGfyQoTFuJIHgxX0
=Fh0O
-----END PGP SIGNATURE-----

--zu8lIfFVzXMVnfzp--
