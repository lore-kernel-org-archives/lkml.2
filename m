Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2BRGiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:38:52 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28485 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2BRGiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:38:51 -0500
Date: Sat, 18 Feb 2012 09:40:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jorgyano Vieira <jorgyano@gmail.com>, gregkh@linuxfoundation.org,
        devel@linuxdriverproject.org, jarod@wilsonet.com, nsankar@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
Message-ID: <20120218064039.GD2912@mwanda>
References: <1329521976-1326-1-git-send-email-jorgyano@gmail.com>
 <20120218062534.GB2855@mwanda>
 <1329546625.1753.7.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <1329546625.1753.7.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F3F4777.004D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2012 at 10:30:25PM -0800, Joe Perches wrote:
> On Sat, 2012-02-18 at 09:25 +0300, Dan Carpenter wrote:
> > On Fri, Feb 17, 2012 at 09:39:36PM -0200, Jorgyano Vieira wrote:
> > > Replace the usage of BCMLOG_ERR with pr_err and remove the macro defi=
nition.
> > This needs a pr_fmt line so we can tell where the errors are coming
> > from.
> > #define pr_fmt(fmt)     KBUILD_MODNAME ": %s:%d: " fmt, __func__, __LIN=
E__
>=20
> True.
> __func__ and __LINE__ are not generally useful though.
>=20

If you don't know the function and line number, then how do you
tell all the "Invalid args" printks apart?

regards,
dan carpenter


--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPP0fmAAoJEOnZkXI/YHqRwM8P/0IkZLdV4eTps5w+/iTgrp1y
KJgiB2JVlbg/3FaFrkaGOtdzr+zKpVP3LZo9tKx/dhcCCo4i/edH7RduGYb+WnIQ
4d0UMBzh5YGnVw8DgC3j5okFQ4/OzwN3/UVTxoQ4on2zZXiQLXS1XIeRwnFf6MUD
EyU3nxTH/QNw3MRW9wYBqBs6u0ti9E5GJOCh3LNdD287S0QacA1yziIz+0iVgSlk
o3Q4/r0rodBey+l64sc1KHTvenoeHU0+QJ73Ha/bQhVH0NFYbXNOpXq1yxYkxx8t
T5IrpTTd8M2rW5et3QFC0aE39HrIHKz9pyPotmdYsEj4do6bScI1t6wx68XNwYgQ
tBexueK4pbNlYlfASOadwLYoFfzfAoZn1kMT0VVrpgJKSsg1AqXS8vqqWewB5J3x
M4Z6d/CXlXcVTDh6tuNdYcF3T/pb0UV9t1YEeYATH7y2alVRPYgq+AGdic+E82T3
bfms1hG2eKbS4ZGLwHwjTk8W61dEHZGChM8/sGgxObJUpBFklTO0HiFJMgMVMgeb
w1VDq9pJQST4lK8YeTNSpFA9dO4biD46IMDcH9fVP8SkXK4D5VHt6+JofcdV93Fc
gBje1MEHpqzxs6k451E/7ymQDHGQCa8I1UfXm77uI5QCMpPvcNMMbzLwT9xRJ8Pt
tKJIIH4+ykPRGOqzZI2k
=kh1r
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
