Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2BTTIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:08:02 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45505 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2BTTH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:07:58 -0500
Date: Mon, 20 Feb 2012 22:09:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pradheep Shrinivasan <pradheep.sh@gmail.com>
Cc: gregkh@linuxfoundation.org, lucas.demarchi@profusion.mobi,
        devel@driverdev.osuosl.org, devel@linuxdriverproject.org,
        Andy Whitcroft <apw@canonical.com>, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: bcm: fix checkpatch.pl errors and warnings
 in Version.h
Message-ID: <20120220190952.GN2912@mwanda>
References: <4f428dfc.e302440a.02ba.6747@mx.google.com>
 <20120220183109.GL2855@mwanda>
 <CANz8tm3t5HM9QeNk+h4gNtbTs2UUW1qOe0t=TgnuSD3_gw_A7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nG9yj4eE4W6Oba0"
Content-Disposition: inline
In-Reply-To: <CANz8tm3t5HM9QeNk+h4gNtbTs2UUW1qOe0t=TgnuSD3_gw_A7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F429A03.0098,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nG9yj4eE4W6Oba0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 21, 2012 at 12:13:40AM +0530, Pradheep Shrinivasan wrote:
> Hi Dan
>=20
>  I remember the bug .. but i think in this case it would be ok as it does
> not look that weird as in the case of the single character brackets.
>=20
> In case you feel it is totally un necessary i can fix it and send the pat=
ch
> again.

So are you asking me, are the parenthesis totally unnecessary?  Yes.
Absolutely.  How could that macro possibly be expanded in a way that
would cause a bug.

Are you asking me if I think the code is better without unneeded
parenthesis?  Yes again.

Are you asking me if I'm going to NAK your patch?  No.  It's an
unfortunate thing.  Checkpatch.pl is going around telling people to
add bogus parenthesis everywhere, and no one likes to redo their
patches.  And I feel like a jerk for telling people that they should
redo their patches.  And checkpatch.pl is a robot which has more
energy than I do.

regards,
dan carpenter

--+nG9yj4eE4W6Oba0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQpqAAAoJEOnZkXI/YHqRFtEQAKjb8PcqzLrPReugn+IVwmB+
Osygdl36KQ0YjXXqcZcUrYleKIlNgQHcjbVMxxrlNRu+O3cL4a9Qp9m1DSV1MnpV
nWut+QhFlEKe9DXtJUYGA92VdBmcVFeJC+Lxf9QavoueoUqkbEFY8otmUSjBisD2
dQfnigrGlaLfS9lyAICr4mPi9pugunJPlSPmDwBk1oRo5w+ABgAb8NKlFZR1NTYc
CxxKdJ4t/IlqN54RR86ga9zmxoz19LntIXUfEIkLZe8F8laWp9VYWaJCdsAbtWO/
POAVOmAoNdWmob/LXTusYO/VjdASXGu00vr2+81iBqRSptQ0CvI0LHnN9mwQQQ4P
TZb8RtdufUdWJwxssLNdavP4CPS6c0OeC1VpCjuaHwcpD/PPfOKOfx9gEBp0ZHrO
+V+cAR22ILexLZGSwTY6rhcgUvZXhOp7pSXA/rVaDrVFjvx4qhFGlRW3i76SnE9W
OJ3Og3xLfwyS9QGHZe/+43VA9dUPJhEZa63YIQoeEipVHj06PuHFRAtZu81swevh
XzOk7Li8OrmW/eJwzuqz21XOoSieYZscE+AK0Z6E/GguJY/XTqVa1VwmpI8PxjGa
vUHAeGJJDZVaaE6we8DXkeZlT6qkLnbziX+eLAN/vtwhtQesWRIlpQ7j7GWLXJKx
6uZFThvoBBTm0txEKwVH
=gZd7
-----END PGP SIGNATURE-----

--+nG9yj4eE4W6Oba0--
