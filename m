Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0C2HBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:01:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36225 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0C2HBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:01:10 -0400
Date: Mon, 29 Mar 2010 18:01:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Herbert <therbert@google.com>
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20100329180104.0f558352.sfr@canb.auug.org.au>
In-Reply-To: <1269845561.2164.1.camel@edumazet-laptop>
References: <20100329174300.512d83a8.sfr@canb.auug.org.au>
	<1269845561.2164.1.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Mar_2010_18_01_04_+1100_Vkrz1Ay8b+rnCvVO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Mar_2010_18_01_04_+1100_Vkrz1Ay8b+rnCvVO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Mon, 29 Mar 2010 08:52:41 +0200 Eric Dumazet <eric.dumazet@gmail.com> wr=
ote:
>
> Thats right, this was on my first submission, but I forgot to add
> net/core/net-sysfs.c in my second commit, sorry.
>=20
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks for the confirmation.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Mar_2010_18_01_04_+1100_Vkrz1Ay8b+rnCvVO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuwUDAACgkQjjKRsyhoI8weYACfc5Lq9yZGVbzbLgQ81MeP/0Gg
24oAoL+djfSepBPriubOHbttxvZkE7hw
=7b7F
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Mar_2010_18_01_04_+1100_Vkrz1Ay8b+rnCvVO--
