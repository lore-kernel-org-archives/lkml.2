Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2BQXO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:14:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57241 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2BQXO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:14:58 -0500
Date: Sat, 18 Feb 2012 10:14:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Feb 17 (kernel/kcmp.c)
Message-Id: <20120218101446.64a7ea590b66f337762bfb57@canb.auug.org.au>
In-Reply-To: <4F3E95B7.3010700@xenotime.net>
References: <20120217165045.2394d944d6efc37104421d2e@canb.auug.org.au>
	<4F3E95B7.3010700@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__18_Feb_2012_10_14_46_+1100_yje1+57JNYgadVaO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__18_Feb_2012_10_14_46_+1100_yje1+57JNYgadVaO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 17 Feb 2012 10:00:23 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> on i386:
>=20
> kernel/kcmp.c:153:10: error: 'EOPNOTSUP' undeclared (first use in this=20
> function)

Caused by commit 0e8a8193207d ("syscalls, x86: add __NR_kcmp syscall")
from the akpm tree.  Missing include of linux/errno.h ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__18_Feb_2012_10_14_46_+1100_yje1+57JNYgadVaO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPt9mAAoJEECxmPOUX5FEBDoP/Ai/8LiMdIpV1MLgSLjYfYHL
bRaIPf2Sbmv+1yTmnaHHdpB0LGjT3cpmYJk3h0ridXTMKa4TYlgeWWzrAqxY8ydT
GbMF5DxYGsEonyULoS1ge897ib5Nmo5q0sP2S50qrDcElqoNcQyZBXqj0BIZEjpE
Rh+uOkN+u94NznPwlXTWthetPsLZbLYxMrlDqBXQM2Iw+v7Jwr+OFLamJLUbvILF
DLrznDa1HmhL+va8SszFmn6L1CDJMV7CojYP0vGyGoqbchQrfQzNmkTRCty3d8R0
1FCmgDlN8wuUILdhR7jIaIx+pef0TS8kZwBSQ6KZ9JnnPrmVAQ0Y7idGMkZrTGkU
fc0mCUMEmF2sGGkrm3T7r1vZsdHB/0gkVq6uBEsHcpzKQ8VPeqRQwPmj1YZiO1mu
UgxbLwxWsshOoEswQpX7DxD+nnlq78pgVWtpT8U9YwG6iF4gwXxfH3IRJJ06/DbN
HED9c3MIhtjAHY4Vk7sguyhEP8Ks5VhHRKe1Cq+KeFJmWp68OIAkRtnqamjDyMRI
5U0u0SSsAGrS9RWM10ldBtd2znPb9LC08GUxyBv5DHKTqNDCiZRbjMw4d8z7EXtn
jV7i/Dn07nPgL5uOMSdOxtf8t9/uPDgDqVDOhBGL+ebrgUkTfR4wZ5XsNF/JPMtG
vZOVKo+CB5TN0SE8lRD0
=iySb
-----END PGP SIGNATURE-----

--Signature=_Sat__18_Feb_2012_10_14_46_+1100_yje1+57JNYgadVaO--
