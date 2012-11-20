Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2KTKia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:38:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57826 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab2KTKi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:38:29 -0500
Date: Tue, 20 Nov 2012 19:38:21 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: DVS regulator drivers
Message-ID: <20121120103818.GG10560@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
 <20121120010547.GD4483@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1211201054260.21420@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8qjQX3lIKI8OJLo6"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211201054260.21420@axis700.grange>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8qjQX3lIKI8OJLo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 11:02:57AM +0100, Guennadi Liakhovetski wrote:
> On Tue, 20 Nov 2012, Mark Brown wrote:

> > On Mon, Nov 19, 2012 at 12:52:09PM +0100, Guennadi Liakhovetski wrote:

> > > 	/* Always set the ON status to the minimum voltage */

> > > but I actually don't see, where the minimum is selected. It seems ins=
tead=20
> > > in this case the "ON" value is just set:

This is where I was asking you to clarify what you were trying to say :/

> In other words, I don't see where voltages are compared to select the=20
> minimum to be used for .on_vsel. Instead, it seems, .on_vsel is always se=
t=20
> to the new value, and, if it is also higher then the old .dvs_vsel value,=
=20
> .dvs_vsel is _also_ set to the new voltage, in which case they become=20
> equal. Is this the intended behaviour?

There's no need to do any comparison because we only ever get one
selector value, there's nothing to compare it against.  We're setting it
to the dvs_vsel since normal practice is to keep the upper end of the
voltage range constant.  This isn't going to do much good if they but
anyone who actually has that use can worry about it - it's rare.

--8qjQX3lIKI8OJLo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQq12TAAoJELSic+t+oim9J3cP/00iw6/wrMCozn1Y8ShMPjwL
FdVYL5wK+dO9YW1BxZmDor8lzYJrcHyvP8nd3dsGv/IIGHcWq7PkVV+pbqK0tpnK
eW86BJZ/P3+TftVmU55B1F8WY0gtjoh+1GJxsFfuYwqCRbKjqDRsY66Tmn+5uSpG
9ZAOR1qmos1nISqzfi3kHra7t1/YSNkg60oG5NecbCd+bIwEFspvCaGBLx6VwIUd
l9sN/Je75/sCRju3RjkrYfCpON2T5LJksf1gjYrFctQ7H0SNbxPyTGwCEbZ40O9V
6awGR9P+JEqvFZzoie1k+607KZxdct37Msc34wvP44mGzwlzAcjyfAHsVfWN7ha3
QZKjY1v5vugXE5yMlOHg0px/x0SxycQ0IBF1LRPd6lBLPlQ+eSWNaJBYd374cTyu
YTzGXD4Xd9KdexlkAPIhg47jo9y1ochfOECB4jhxDgZTTPeugaZvjUbxV6jc2UGK
OivsA986jChvK9yn2VmA6xbIIJEiudBS0c5HUBI1CtW+drUHWlYSw+NuBHXDoIoJ
+T4kSsnTat0dxGous3mxgMs/1z7QT1u7+zzL8SNHvvBbRKF+ZkLBgN6zNZGr7GRu
nATWb8oBQ3XE9WaixKEtE/OKb61v+BqDwIw5ejz0mjhP3j7veW02U6l9J5pWWOiq
G7XN3kZw550E7Xlh3fRo
=6E9D
-----END PGP SIGNATURE-----

--8qjQX3lIKI8OJLo6--
