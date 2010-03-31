Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0CaXK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:10:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41603 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0CaXK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:10:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] NOMMU: implement vmap/vunmap with kmalloc
Date: Wed, 31 Mar 2010 19:10:41 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.33.1; KDE/4.4.1; x86_64; ; )
Cc: uclinux-dev@uclinux.org, David McCullough <davidm@snapgear.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <19891.1270076813@redhat.com> <14998.1270055484@redhat.com> <19923.1270076874@redhat.com>
In-Reply-To: <19923.1270076874@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3294520.skhYGag6QH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003311910.43861.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3294520.skhYGag6QH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 31 March 2010 19:07:54 David Howells wrote:
> David Howells wrote:
> > > how about putting this implementation into like vmap_nommu() and only
> > > rewriting vmap() to vmap_nommu() when we know it's safe ?  such as th=
is
> > > firmware case ?
> >=20
> > Well, I'd argue it's _not_ vmap(), so it doesn't really make sense to
> > call it such.  Perhaps some better name?  Perhaps vcopy()?

fair point

> How about vcoalesce()?

WFM, as does something like vmerge() ...
=2Dmike

--nextPart3294520.skhYGag6QH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLs9ZzAAoJEEFjO5/oN/WBMa0QAMbHnOZ69NiuVAlbAuQu41x5
ivbwf0E7muaaCy+7osv4TgNr3kXQUoGnYTXfQ7qQ/GFpd1zWnIP9lp2dMRs/FlEO
he5HRTWkjVldiZF170adKif+bTfwmdNRwunqHgxBiyr0siL+vn2CBt4NGqiDq7/c
5dtVeKy3zAQ9ghEwPKGMCrdYtDV3L5TwED9fNE6Vtxy5uS1tesAv2PAqqp5ktSv/
ab7yjuvyridGWf0ahwWHUcUB9yaIDacoPL8COPwlBeGAUGbgImyJ1jm2MfPTJyMZ
Dx4EvCj7Wk8bWAmBn8gO3vnXm11h519YDzaZAfnPUe0b1WdXMIxikV7H/PZQdkfT
D4rRLhylJ1BEKsuLR+hxENG1ggQQTLzqpqwhMojzzTG1fEm2g8YYWs7bHa9a7l+U
thRhA4iRBMdN8E/r48BEcDTqIq1RHbRVNnUZhpXtPr9+hVjZkChuNLbVQXWgoZ0d
M67HXng2zjKVN2wdIKdVKP88Xx91/ChThAx8JhDL1BWCd6NQrDBqENwk+i0R2QdG
kM8yAy3y5sLNzi+27eWzB0YyBC+qLJF7n4hDPaXNBHd2nThTWFlmxLaeC5nxnhmV
1/r0nT6okyJM5d0UN0sDUeKNCdSLgoAiXwQBGujny4TilTGvbo9vzRVdzPwtNM6v
mDIPMLcqKm8oR8gsgrFX
=58A7
-----END PGP SIGNATURE-----

--nextPart3294520.skhYGag6QH--
