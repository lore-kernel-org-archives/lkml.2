Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0C2IEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:04:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45040 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab0C2IEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:04:34 -0400
Date: Mon, 29 Mar 2010 19:04:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, therbert@google.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20100329190428.4a2c5626.sfr@canb.auug.org.au>
In-Reply-To: <20100329.010104.214233589.davem@davemloft.net>
References: <20100329174300.512d83a8.sfr@canb.auug.org.au>
	<1269845561.2164.1.camel@edumazet-laptop>
	<1269845970.2164.4.camel@edumazet-laptop>
	<20100329.010104.214233589.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Mar_2010_19_04_28_+1100_m.bBm45rV7cSKhDg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Mar_2010_19_04_28_+1100_m.bBm45rV7cSKhDg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 29 Mar 2010 01:01:04 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 29 Mar 2010 08:59:30 +0200
>=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
>  ...
> > Oops, a cleaner patch would be :
> >=20
> > [PATCH] rps: fix net-sysfs build for !CONFIG_RPS
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>=20
> Applied, thanks guys!

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Mar_2010_19_04_28_+1100_m.bBm45rV7cSKhDg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuwXwwACgkQjjKRsyhoI8xWegCeK3ZEemLXDkmd2zf+R6cz5Lmh
kl0AnRbPyIm7cOm1NM+SL8TmIi6ys16A
=mTm7
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Mar_2010_19_04_28_+1100_m.bBm45rV7cSKhDg--
