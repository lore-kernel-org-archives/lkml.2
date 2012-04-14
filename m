Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2DNMgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:36:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52076 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab2DNMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:36:16 -0400
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 14 Apr 2012 15:36:11 +0300
In-Reply-To: <873986h6qa.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	 <87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
	 <87bomuha77.fsf@devron.myhome.or.jp> <1334401307.2263.24.camel@koala>
	 <873986h6qa.fsf@devron.myhome.or.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HOVxd7YuvWEH3CqN640b"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1334406974.2263.38.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HOVxd7YuvWEH3CqN640b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-14 at 20:51 +0900, OGAWA Hirofumi wrote:
> Yes, I still worry about order. About ->sync_fs(), you are looking the
> following?

Hirofumi, you still did not explain why the order matters. If it
matters, it should be easy to explain.

But I will look at this and think about the ordering, thanks for
feed-back. But if you could explain why writing out FSINFO before inodes
is an issue, it'd be very helpful.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-HOVxd7YuvWEH3CqN640b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPiW87AAoJEJtuLFy+q7fex2gH/3H7EVic7pZCdgMttWzxJ+zX
GQBPiNZ3UcSmQ9evWYfg9kWFbDLWD5f0zhRkyC4TsT939bD9ZpFBDoOFCoXqVat1
VYdYdnDOcwCUjgI+9Ql5RaQsEkpHD2ojzQYfzkRPQCQwKAfMztDc/KluOBCGQDTq
e7LcWqpnM51QVw5dFePG0vHftF6HxbmytHlvb2XIKK7pBDEQr9tHf9OiEaYZ5TOa
/+Lif2l59e9aFMPa1jqn8fE5/6QMs1j9AUivnv1nmu8lAgcQJyuvQcHA1euAywac
cHaJBazYrjYwremUuEqbTg4Ukfp4UK1wWY0F90QoVgo+i00rLw+eVD6MeyvBcYE=
=OoIl
-----END PGP SIGNATURE-----

--=-HOVxd7YuvWEH3CqN640b--

