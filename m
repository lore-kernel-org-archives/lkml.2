Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1KAEXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 00:23:22 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36760 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1KAEXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 00:23:20 -0400
Date: Tue, 1 Nov 2011 15:23:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
 tree
Message-Id: <20111101152312.5751b7ac8b4a998b6ef867be@canb.auug.org.au>
In-Reply-To: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_15_23_12_+1100_TpEuXExkYPudDulL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_15_23_12_+1100_TpEuXExkYPudDulL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Tue, 1 Nov 2011 11:58:51 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Presumbly caused by commit ea8bdfcff175 ("crypto: user - Add dependency
> on NET").
>=20
> I have used the crypto-current tree from next-20111025 for today (i.e. th=
at
> commit has not been added to linux-next today).

Same problem and solution in the crypto tree (obviously).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_15_23_12_+1100_TpEuXExkYPudDulL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr3QwAAoJEECxmPOUX5FEBsoP/0V27NAfL13d2/AW6wB2vaef
u53dxEm9DQdbd7lY5/fjaEhpPBjIR6Bqjj7S9GuspEpxmYFjELRsfb5q4p3JrVOy
O/wyiEZF/E/c8oD5zh9PNQNDowNFB2/Dzn4lmHqhiHEt3JnTzLyvDghlrkEUNqYa
cQ44hbAW3rg4l9+7hd6/TEUmRVqo466sdmjf9A+Z7BBr6zMFuLsw8Bt3oHZfKfE0
OvV/23unb3muW3EqFGfV6ORZWc12uyZTUPXuRjd+sPnMHnWRPZE8MjLmeEnAJPAE
+gem8zdY0GbJnApJnYKA9sWpmdc7pOCgU410sTR+jDWxJOhy1Zt3uaKSvmV5ezn8
9CkcrfrEW11oeV0SQAhmtOpDQuCiXysPo6JtT2583+FiA1lngIxgAqsttdl7pM8z
vD73Mx2AvawEYXn6bCDMARhHy8zvUlJWuDPiDOmvNYP+spHNm24d2MFYci0+BOG/
wSFY2drynjisB/6iVQ8UWfXLmUhve+Inp0IYwsAbGkACow1eIl8zGboOG14r94t0
OniO0GiTZ55nzrXxV0OhcOnNbg0hntcKTA0yDj2yWfktRM4NuujMffrOTwsx889D
3gDRgHzXNPnyLJM0yv8mZayXOH+z3pk9A+5g5a02a11iOUg8b/qDygrDSzietWDu
EPXIAbL8p0p+x7ghmyPp
=MdbW
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_15_23_12_+1100_TpEuXExkYPudDulL--
