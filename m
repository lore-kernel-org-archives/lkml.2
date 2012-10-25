Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab2JYDnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:43:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35027 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502Ab2JYDnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:43:01 -0400
Date: Thu, 25 Oct 2012 14:42:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2012-10-24-17-15 uploaded
Message-Id: <20121025144258.60c751a4ec733f7a1dfec4cf@canb.auug.org.au>
In-Reply-To: <20121025001628.1DEDE100047@wpzn3.hot.corp.google.com>
References: <20121025001628.1DEDE100047@wpzn3.hot.corp.google.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_14_42_58_+1100_51PLtnKt7_QU8KmN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_14_42_58_+1100_51PLtnKt7_QU8KmN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 24 Oct 2012 17:16:27 -0700 akpm@linux-foundation.org wrote:
>
> The mm-of-the-moment snapshot 2012-10-24-17-15 has been uploaded to
>=20
>    http://www.ozlabs.org/~akpm/mmotm/

I have split this series so that all the next tagged patches before
linux-next.patch are in the akpm-current tree (based on Linus' tree) and
all the rest are as before (rebased onto today's linux-next including
the akpm-current tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Oct_2012_14_42_58_+1100_51PLtnKt7_QU8KmN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiLVCAAoJEECxmPOUX5FERXcP/2aUDKWe5gqOp4EkgFuTdSRn
GCYGZUXwxl8aynEa31jx6iBs5i1QiCYeBagwMJ0bagjDj0lElv4KW9vwl2rsmgpo
B9g90rwWh99rAaMNBb9c+vopH5FsIuP5MvgQnKMccpY/oZsPCJ6d3XkGWTO5bbOr
6ziUeVBrr6WOBWKaSYZM/U6Zq8R+dyhHdX4TZoCaX8+7Ts+eJnsTVhgu3WPFO4nJ
aLWi9+yA6BAi14pOA9nYCEnXBjB5+eX7/01CBPGj2OK2HXBN6uA8FOsFyKCwEL8U
1xts+gG4fXWateGd9Wx6PCllqTNuHNkt/uAJOrPMwWC9IEa8K+XZ26SssD2mKSkK
R0bK4idC0ygXkjrBvOKO5wi/vFoymBuUZr7ntc1ipnIyIbQutlkGKW4uBEW2VwNt
TRghRsr+fyRQfZWpPG01MwRQtkKaheb/z7+OfueUD6rE6kX8w2LRFkospA+655Fa
qF6331bGibD9bHL4EbDZZSuw4bK0lbMN+TLJFxRZNTHuEScDTeWR2jHaq7eEPvBT
nyKLPJ5MXW5ClRz8ev3U/SylF1udiAUFHjyMsoteOjsfMKRW/qowyGZKD1W6tUVY
iqgxNe/GbTparVk8jgNx/+HG47M79FRPErWMs3AyRBt8POKUZeA9KM3K7nmWu6Bw
U34xP/W3FU1UqtmlgMYP
=eiZ8
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_14_42_58_+1100_51PLtnKt7_QU8KmN--
