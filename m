Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2BVXzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:55:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60704 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab2BVXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:55:05 -0500
Date: Thu, 23 Feb 2012 10:54:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt@console-pimps.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: Fix unaligned access and endian issues
Message-Id: <20120223105444.f0585f65e18be0360f9bfdb9@canb.auug.org.au>
In-Reply-To: <1329951508.4759.14.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
	<20120223093140.3f8ad47252f9f331d355ea57@canb.auug.org.au>
	<1329951508.4759.14.camel@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Feb_2012_10_54_44_+1100_0QZJP6k=RW0P7=im"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Feb_2012_10_54_44_+1100_0QZJP6k=RW0P7=im
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Wed, 22 Feb 2012 22:58:28 +0000 Matt Fleming <matt@console-pimps.org> wr=
ote:
>
> Thanks Stephen, this bzImage works fine on my setup.

Great.

> > One little thing is that those two new functions may we warned about as
> > unused if CONFIG_EFI_STUB is not set (I have not done that build yet).
>=20
> Should be OK because they're static inline (it at least doesn't warn
> here).

And I did the build and they don;t warn here either, so good.

> Peter was talking about exporting unaligned.h for host tools so this
> patch will probably go through another iteration anyway.

OK.  In that case, I will add this version to my fixes tree in linux-next
just so that the allmodconfig builds work again.  I will remove it when
it turns up (presumably in the tip tree).

Just to be clear, it wasn't the unaligned accesses that were causing me a
problem (PowerPC copes), it was the endian issues.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__23_Feb_2012_10_54_44_+1100_0QZJP6k=RW0P7=im
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRYBEAAoJEECxmPOUX5FE0IgP/jHI+cM1q/ovzrOJbh/FxN2U
DeGSEBk9ubxNSvlASGoq7jyaSRr/b8wvWyoQz3Ws2AYQHA3SFww/1fRL6IG8pF1X
wFaPU/XzeksVdSS2439i1N+r8hu66nu8Kj+Xwx3oDaa9uqNkpXYGSy3EoLLiZq6X
V4F6YfgewRp7xOABebR76CaQ0NradConTPe58cakX/+eWx4iKOKR7yItSwxhQ+gU
xMVcwKj1l9nBoeKhE2KBc3BCesesy9mVxtcXyO1qHT0aCNm61qiee8P7aV1RJwmT
HX5+aHziYtbnw/ONNVRJC4mTOnRtCXVPte3Y2cBkw8JfI06HMbL4NkiXEoBRp3Kh
RBVBocEta8BVu7wRjeXmJAAj6ZHvmnbkGJ2RquqyOGMMthtgOGSYYF1BVaNkFG69
NkYW2WKV8WCznCZ03DM416wwYYwnqh1FpoJORcFeKliM/Bh569OmH3suQf+yKq7x
7SvVWouWqSIEIXVKSLvNLfkoBtF9GbFW2Cm9ZgfXLEld5UEc9wwXkqDaExf5/bne
jPHCqMvd5vDvhKgXpSXkADxhv4g5HoJZ4whIVB9j7EQ6Svp8i5TCqZrbW3QfsN6T
RitQi4+C8VgZexxxZNl4wcBtw1A8NHUOulTrRWURczCIc1pOKUvJ1n+/AwGAE2f8
xoN3swFLZuW3Vu3ywYJK
=sIYo
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Feb_2012_10_54_44_+1100_0QZJP6k=RW0P7=im--
