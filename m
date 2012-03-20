Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab2CTIe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:34:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52539 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167Ab2CTIex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:34:53 -0400
Date: Tue, 20 Mar 2012 19:34:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the nfs tree
Message-Id: <20120320193443.ac26a6f22feacc00e59d3467@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Mar_2012_19_34_43_+1100_KqY0h9lEXn28Dwm7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Mar_2012_19_34_43_+1100_KqY0h9lEXn28Dwm7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (sparc32 defconfig)
produced this warning:

net/sunrpc/rpcb_clnt.c: In function 'rpcb_enc_mapping':
net/sunrpc/rpcb_clnt.c:820:19: warning: unused variable 'task' [-Wunused-va=
riable]
net/sunrpc/rpcb_clnt.c: In function 'rpcb_dec_getport':
net/sunrpc/rpcb_clnt.c:837:19: warning: unused variable 'task' [-Wunused-va=
riable]
net/sunrpc/rpcb_clnt.c: In function 'rpcb_dec_set':
net/sunrpc/rpcb_clnt.c:860:19: warning: unused variable 'task' [-Wunused-va=
riable]
net/sunrpc/rpcb_clnt.c: In function 'rpcb_enc_getaddr':
net/sunrpc/rpcb_clnt.c:892:19: warning: unused variable 'task' [-Wunused-va=
riable]
net/sunrpc/rpcb_clnt.c: In function 'rpcb_dec_getaddr':
net/sunrpc/rpcb_clnt.c:914:19: warning: unused variable 'task' [-Wunused-va=
riable]
fs/lockd/svclock.c:49:20: warning: 'nlmdbg_cookie2a' declared 'static' but =
never defined [-Wunused-function]


Probably caused by some debugging being turned off.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Mar_2012_19_34_43_+1100_KqY0h9lEXn28Dwm7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaEEjAAoJEECxmPOUX5FEBpsQAJnSTmj6cPYzRfEin5D/7TMA
dGoeVFXegrKtjX9DTrxlJ1uxCmJHyjlFjQ5qYqEBC8MEib2Xw0+NBDEQBeoG+QQH
zTZkMDbXThVYIS75U+0f8Vm1fyMnmapkCnX9lElOmfZV7q6RFSOOnB710UDiCtSt
pB1Y2A4Kqkha89arYvBn3eWgSzjZjL6uqV2cE/CbKvjwiz0Kl6Z8yYZBKdY1R2K3
/6DwDmiElmR73ynzBwDugXNTtbOLionz+22tFyjTdRwx+sc7lFxDPKsTk296gQOf
QnFKMfZMN7KTC2/WEHm8gtCgv7c7nwN3bIjPQPIJzRIuXidi+w1V3zLrMm7rIPDw
4W5hVdyrp9Rj7GUHmBpw4OEpSzbWiw/uYJZogEo9z1v8u1g1Vpw42PRaOXIAR62w
ohHkyqgjN9Q0k/FrOFM9on13ornkEmuHPdqU6zmF5FeutKTy7iMgC8KVRTKrF+fK
1jhydEJxopLQk3Vo4K1m1rqm8Gy2RHEy3hdEMk+WAD51z+hJJApS9EzCKVBQlj/T
TR8hu6W3JcpV0P+EQsLl+VtZmDheqHb9PX9HV2zYevaCux4quI9c/7rsG5Hj6poZ
hyReS8/Dj/YpsWGVjes3dz8CF/MbXv3o03J1WyZuSseJk5uKHIhpr9E4QemMCGCi
PzldA8zgD/i2TUGu9gWU
=JvJA
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Mar_2012_19_34_43_+1100_KqY0h9lEXn28Dwm7--
