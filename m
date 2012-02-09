Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2BIMes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:34:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49409 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2BIMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:34:47 -0500
Date: Thu, 9 Feb 2012 15:36:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] relay: prevent integer overflow in relay_open()
Message-ID: <20120209123617.GC4141@mwanda>
References: <20120209104433.GA5540@elgon.mountain>
 <4F33B448.1040207@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <4F33B448.1040207@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F33BD5F.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 09, 2012 at 12:55:52PM +0100, walter harms wrote:
> numerical this is ok, but ...
> maybe it is better to cap the chan->n_subbufs at a useful number ?

We considered this question already earlier in the thread.

> The user can still allocate an insane number of bytes.
> Restricting subbuf_size*n_subbufs seems more logical (otherwise is this a=
 real problem ?)
>=20

Yes.  It is a real problem.

regards,
dan carpenter


--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM73BAAoJEOnZkXI/YHqR2K0QAKZYavGkdsfIyee+J8QyZGG2
PCAwQN1MzKTKZvFHJruAUrOctRh36E6eeuu6fzUhdmDnrpOgws6vifZlBQSDWh2l
zC+aV6gRWPY05qTYDpPl8HvHC2u7BdT3/l8RtcKP089HqhRtGH9ukYvzbomKByPy
qTp/ipJrHdI6UfKOLBOg/6FR1YjLyKZg42/Q0vDiLk+A234/Ped01UsdKBKUcBWV
l0SYweTh1OMnYOFXGM79pgh7ViXtkPjwo4iykz9ejORfpHHE7XJ94+FcfsuM0fuo
JF8qLlrzIOSuGCnrOSxdXcdnmqzRgWdG/gu0AM4XLpcyV//wT3Sb+0GI93E4NXJ3
zSSXOqQmGWLV5D6fFcEz4stZdMpxDPwNXot1N9fmWGyxrrTFi7gTXOmo3C5ywltp
NbzdYQeZL6bx+amhdWNRg0c7/0fvcJiuPwHVkFJvWWQh3ezJMeT9loI5/TfT0KPm
jx1tHwHYEbPTivmet3qy8D29Bj1vPkd+zrbyceJ/gFkgnjq5Xh/RLXiO9sTOjQLJ
kcp6jmwdS6s7CPpdKeeHzEMcw3rgWRtA+iXdlahNT0cZld/G8iXyrkJA8EgMZIzY
OED3fxm5U03Wp1YtTI6SHIzXY3Q7oqCB78+S/bf7MVtwCPuW977rkBUjI4fcNrQt
AJIHcgv6CXwXDFinN6GE
=A+ft
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
