Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2IUG7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:59:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37193 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2IUG7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:59:50 -0400
Date: Fri, 21 Sep 2012 16:59:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 and battery trees related)
Message-Id: <20120921165934.acbb39b1e4fcce7cc5e1513f@canb.auug.org.au>
In-Reply-To: <20120921164819.37906a76dc948e86f79cd875@canb.auug.org.au>
References: <20120921164819.37906a76dc948e86f79cd875@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_16_59_34_+1000_7BfyaTVFkBFIYF2p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_16_59_34_+1000_7BfyaTVFkBFIYF2p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 21 Sep 2012 16:48:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/mfd/88pm860x-core.c: In function 'device_power_init':
> drivers/mfd/88pm860x-core.c:982:11: error: too few arguments to function =
'mfd_add_devices'
> include/linux/mfd/core.h:100:12: note: declared here
>=20
> Caused by commit a830d28b48bf ("power_supply: Enable battery-charger for
> 88pm860x") from the battery tree interacting with commit 55692af5eb58
> ("mfd: core: Push irqdomain mapping out into devices") from the mfd tree.

This second patch is also in Linus' tree as of v3.6-rc6.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Sep_2012_16_59_34_+1000_7BfyaTVFkBFIYF2p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQXBBWAAoJEECxmPOUX5FEki8QAINcu/jDalyKgdrqv+9YK9lz
fEMvDMBybYxQe9a4DkKwjmVn37YvLQMwZackxjz6eCh0YwoF0oKJa2KV7RYneicV
eFTKnh8QQsmCHbE9YrEy03w0A1l8j8RCyfRn6mVnM7QOQvE8Yb7fjCuu/l8rzZxX
Ne6jx6I7JtoQpk1NL7uOht9SYyEVxI3sp3B3fCjxnkgWaacVkAPe0dtn/HsOyEII
b9YNRMY+fD+czvOf2uZ226vj38o5zn+w32A8evpM4s4kH9pHo8egioT6huik6ttQ
yOZvOL7x//pdxS/hcFe7b/Q0WB7nciZMfAfjYb7ZRVu6LWMgdr9PniS34t+XP9Yi
0HixwmIJq4E/p+KT+ygmWxYdS0h7g8koLGYyFatTBMtTj+YlDjLNXLsUJWqn3hIA
OCVVX2Gij+EfOJDU2AWJExaDMOlc3HtZzjWVmxiKzlqwtb5e9aaNmEaP0dz0tu8P
+X+wy9ILiuFgCNZzDXbYOtjmAzhlx+0aia5SA8cPrUswkm8GQ3r83qFr42S1+Wwo
ooP6Gg3oiUXGK4ZZkMM7KZaLcK+zdr2QHFzlMJj32uXPpO1aDnRna1rXpKZgZKF6
/zdJUGwprX5MrXAqo+6YTyW3GS1hXVJqQ5T8sGegi8x3aAC/JCdFRxkB1NmV7gGr
HZzYEojF++iWFmlgDXsJ
=WXSF
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_16_59_34_+1000_7BfyaTVFkBFIYF2p--
