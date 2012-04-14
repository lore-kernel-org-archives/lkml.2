Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2DNLIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:08:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64907 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693Ab2DNLIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:08:23 -0400
Subject: Re: [PATCH v2 3/4] fat: mark superblock as dirty less often
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 14 Apr 2012 14:08:18 +0300
In-Reply-To: <877gxiha4b.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-4-git-send-email-dedekind1@gmail.com>
	 <87k41ihdub.fsf@devron.myhome.or.jp> <1334399070.2263.3.camel@koala>
	 <877gxiha4b.fsf@devron.myhome.or.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-SZPFWEkt1Lsk7HTMORNx"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1334401700.2263.26.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SZPFWEkt1Lsk7HTMORNx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-14 at 19:37 +0900, OGAWA Hirofumi wrote:
> > But could you please explain why do we need an extra variable? What is
> > the problem with doing all our FAT table changes and then marking the
> > FSINFO as dirty?
>=20
> Above example may not be proper. I meant please dirty FSINFO only if
> necessary. Your patch seems to be dirty even if code didn't change
> FSINFO.

Ah, yes, in 'fat_alloc_clusters()' indeed, thanks, I'll fix this.

--=20
Best Regards,
Artem Bityutskiy

--=-SZPFWEkt1Lsk7HTMORNx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPiVqiAAoJEJtuLFy+q7fesukIALdjHAPcMDL+wUKLsUbMfqoA
utuKtqNx4zxOvN83MRYvlr1D2vowpU5cQILsA03DEbFtS8iMb44l9tP6BWIAcrXg
s7fSDv9GJeYZu9cARnmbuogTlIzV5cv3Jt/6avbOYh/ey/+g3FKu6f/jiWvaK2ly
3q9Oji985djfEHrr2r46KrChDuStvhPECR9n+M4DCQIrcIm/TRnFd6QVWKhnOll6
oZlKPQ5VXOpyI64NG88exDb2wBSVkyNu9HYQg4ozJSSTxVqniBqEB2WUxenS2HJT
nUhZXQla8EdZ7ZcTuHQ9mZLGMv57DZ+bLZ56N+xiKxptw60O6ObcxFUeMRkTSBM=
=p/0H
-----END PGP SIGNATURE-----

--=-SZPFWEkt1Lsk7HTMORNx--

