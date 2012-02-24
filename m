Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2BXHv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:51:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21330 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2BXHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:51:58 -0500
Date: Fri, 24 Feb 2012 10:53:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: bpm@sgi.com, elder@kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: Use memset to initialize structure member.
Message-ID: <20120224075354.GA3649@mwanda>
References: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F47419A.0047,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2012 at 12:38:42PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>=20
> Sparse is giving following warning:
> fs/xfs/xfs_bmap.c:4826:41: warning: Using plain integer as NULL pointer.
>=20

You could just do:
	struct xfs_bmalloca     bma =3D {};

But honestly, I'd just leave this one as is.  The xfs people are
grumpy sorts and it's best to not send them these kinds of patches
that don't address a real bug.

regards,
dan


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR0IRAAoJEOnZkXI/YHqR/84P/j4f0CsYWMeZkm06V4vIICwt
6yDTBYrqgzegoWrWOO1R4PM3htN4+Pjl2sOhv8lykMiC4gA0Fx7ZhI4F0F4iu/NG
oVWT9zgh321PwZbJMgXIkYdbJfFFToi++c5mLPV6zoEZb0cA5yxWKbXygcxACExx
975KtBZRjoLOK5jqChNL0ZMdE4xCM2n1cXchL7ym8R7WWzroFVKIlFaZxN8MjiR6
nXcqLPIICjyGl5ZmE2LRquL+es2bxlSBwTPOsgzic7fpDkanyBM3BGZBCbtfjoUN
E5k08dJ8DOr4YV1TGIatoekDSuDXGSzlLdUWXGd27L0E+MOv1XM479abDq/YtWxL
EqDyD5yXaebbJ36iYWyM/ydMwvHiJtnAlNYnezG04iJK0KDn1EkWKaBkWhXJ2yMO
ZWASCbZDkFNDesMgaoYtLhmPsSC8CCAo49U4h9TEo4XXKIq1CiF/3/3a2vbE1FhS
YJ2PsCMcAozWW4eLf6r6cIVEwxbm5N/kCLgPO0c//CC542RqkrZu7TNWvarej9Md
Lq65YgjkOeCQI3cXw3NESbbbTnKg6+bnNWWLAdAGtEQMA9lxMqWtvYPJnUWXP84q
TmpdODip7eVkmKfcaO9Dk1J/AUMILuakRvg5lLUaiipOdjrO3w8Kp/a6s1jBkF7D
+Ci39unsMJKpfpjCY/bO
=oEhI
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
