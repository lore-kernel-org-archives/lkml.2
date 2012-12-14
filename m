Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2LNGmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:42:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31515 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2LNGmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:42:51 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5b-50caca69e699
Message-id: <1355467363.16178.25.camel@kjgkr>
Subject: Re: [PATCH v2] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Fri, 14 Dec 2012 15:42:43 +0900
In-reply-to: <CAKYAXd8Q38vG83Hc2jB3tM9xjkgWH=dNae6qLTuVceBGqRvdsQ@mail.gmail.com>
References: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
 <1355460921.16178.21.camel@kjgkr>
 <CAKYAXd8Q38vG83Hc2jB3tM9xjkgWH=dNae6qLTuVceBGqRvdsQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-MWkFBEXA8LLYqJPnzw38"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+ZgW7WqVMBBiesLfbsPclicXnXHDYH
	Jo/Pm+QCGKO4bFJSczLLUov07RK4MppnH2Qq+C5a8XTNP5YGxulCXYycHBICJhKnd0xih7DF
	JC7cW8/WxcjFISSwjFHi0dc2Fpii6ft6WSASixglJt99yQzhvGaUWNB4ixmkildAV6K36y0T
	iC0skCLR1PaDsYuRg4NNQFti834DkLCQgKLE2/13WUHCIgJqEhOepYKMYRbYxShx7OgSsGUs
	AqoSaz/PALuIUyBY4uOF71CL1zFKPP0wFWw+v4CoxMnWT4wgNrNAlUTPzQdQLyhJ7G7vZIe4
	R1Dix+R7UEMFJL5NPsQCslhCQFZi0wGw+yUEHrFLdK3bwwTRKylxcMUNlgmM4rOQjJ2FZBRE
	XFOidftvdghbW2LZwtfMELatxLp176FqbCQ2XV3ACGHLS2x/O4d5ASP7KkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYyQqJTawbiyweIQowAHoxIP70ehUwFCrIllxZW5hxhVgOY82rD6AqMU
	S15+XqqSCK/kEaA0b0piZVVqUX58UWlOavEhxmSgTycyS4km5wMTSV5JvKGxsYmZiamJuaWp
	uSlpwkrivM0eKQFCAumJJanZqakFqUUwW5g4OKUaGJPepr1f+2mOZOva0/sMnz99aFD40d9m
	mum6K7O6J9Wo8CyNiOS48txO7MptD5VZv8x+7ph5Rtrl44mfPN/OcPAstlF2vMvEzrtM7sh9
	mcvyz2QK957NfHI24NTTh017Z1mcVWktFIu8krr4xKXinTvn1Kp/n/3TvccoJsqGa7GVh6pR
	tVT8s2dKLMUZiYZazEXFiQA3JxJiGgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd3MU6cCDH6sMbPYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaJ59kKngu2jF
	0zX/WBoYpwt1MXJySAiYSEzf18sCYYtJXLi3nq2LkYtDSGARo8Tkuy+ZIZzXjBILGm8xg1Tx
	CuhK9Ha9ZQKxhQVSJJrafjB2MXJwsAloS2zebwASFhJQlHi7/y4rSFhEQE1iwrNUkDHMArsY
	JY4dXQK2jEVAVWLt5xnsIDanQLDExwvfWSB2rWOUePphKth8fgFRiZOtnxhBbGaBKomemw/Y
	IS5Vktjd3skOcY+gxI/J91gmMArOQlI2C0kKIq4p0br9NzuErS2xbOFrZgjbVmLduvdQNTYS
	m64uYISw5SW2v53DvICRfRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNQ/k9rBuLLB4hCj
	AAejEg/vR6FTAUKsiWXFlbmHGFWA5jzasPoCoxRLXn5eqpIIr+QRoDRvSmJlVWpRfnxRaU5q
	8SHGZGBwTGSWEk3OByaqvJJ4Q2MTMyNLIzMLIxNzc9KElcR5mz1SAoQE0hNLUrNTUwtSi2C2
	MHFwSjUwzp09OUA1oDVm2+y0LzWsW5M6uf/vnH7QcMvMb1x9nbc+XzFaXvpg6zvZZuupM7wS
	Gp4eUzecuXGz3Zc3PitY7xhG/e18d0VY2/74C13XuzELmLdeC1v4xfuq5XrpOwLm354J6wVZ
	6tT/leRuCyhba9rB2iaqvmCRS8WrjASLH2tvHH16qcJVS4mlOCPRUIu5qDgRACaFWOBKAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MWkFBEXA8LLYqJPnzw38
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2012-12-14 (=EA=B8=88), 14:41 +0900, Namjae Jeon:
> 2012/12/14, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > Hi,
> >
> >> diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
> >> index a60f042..5e48bac 100644
> >> --- a/fs/f2fs/hash.c
> >> +++ b/fs/f2fs/hash.c
> >> @@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int
> >> len)
> >>  	const char *p;
> >>  	__u32 in[8], buf[4];
> >>
> >> +	if ((len <=3D 2) && (name[0] =3D=3D '.') &&
> >> +		(name[1] =3D=3D '.' || name[1] =3D=3D '\0'))
> >> +		return 0;
> >
> > If len =3D=3D 1, we should avoid referencing name[1].
> > Likewise VFS does, I rewrote that like below.
> >
> > 	if (name[0] =3D=3D '.') {
> > 		switch (len) {
> > 		case 1:
> > 			return 0;
> > 		case 2:
> > 			if (name[1] =3D=3D '.')
> > 				return 0;
> > 		}
> > 	}
> >
> > So, how about this patch?
>=20
> I think that there is no issue on current patch. Since, the strings
> are always expected to be NULL terminated.
>=20
> "." should include '\0', So we can distingsh by checking only name[0], na=
me[1].
>=20
> When we do:
> char *ptr=3D"hello"; -> it will always be NULL terminated -> "hello" in
> memory followed by '\0';
> when we reserver space
> char ptr[5];-> We need to reserver space for '\0' at the end.

Got it.
I found that NULL is added to the dentry->d_name as follows.

In __d_alloc(),
        dentry->d_name.len =3D name->len;
        dentry->d_name.hash =3D name->hash;
        memcpy(dname, name->name, name->len);
        dname[name->len] =3D 0;=20

I'll merge your patch. :)
Thanks,

--=20
Jaegeuk Kim
Samsung

--=-MWkFBEXA8LLYqJPnzw38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQyspjAAoJEEAUqH6CSFDSr04P+gPUYQig/v6F8w/qn4FFg+Rk
kZ+eSRkpvwNArE1L0VLMV4d2dXAeqWZO+fAE3z11Lp4bkpuDpxj9xEmGWOIjMRKG
rXpiAEqV1EITAPpxNJ4eojf4NZhwSSbQ+mLujDMKX+gvq4aD4GKtd+a6XLDgzGG1
lawnzft55lH/dcrt2AT/Zn3bcqYYXIZlr31+4yA4hlrGWuyo0dmnx78eiMgUaULb
I0k2z1AyQW8E4f+FlrCT9a8SZWhHIT0Yc8gcIZWfZ1jGkXop5az4EaJQkv8+ZzIV
P0ZLuT5tbWydCelKwMt/u4nTSCaGYFKT9AZA0oxsqbUxDaPNAoEIgjd3t9sazQrj
cmzKKSNGdM9og+N/lkj6ttgPBNDFbAzRcZMvh0xAL0aRMcaVhgfkZ5FJK2okButL
eIdea1eizKM6Zz0I7Ug3oytvN2cBxnA2QQcZKIq94msvQoa18oNc9txmS5hAToXf
Ss/Rd64gkQJBhjkdyzc5QQc1SfPrHj1TIlZO4ho/I8RnbX3oP4oYuXu4VjOMU2Ey
N8x+m6fvCTFBE4UrZIBw6QNnDfcxOzAXpXN4M7QhwxJs+n9MX0dOwF0UYgmSTk9l
dNcXLUMi78yIPMLKaHritEFQOWizcQC5AT+v3nLfSWWQLuxJfvGXn3MHUokAzEUE
cJdUcF/6cuGG5vY9owqA
=7gfp
-----END PGP SIGNATURE-----

--=-MWkFBEXA8LLYqJPnzw38--

