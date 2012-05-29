Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2E2Civ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:38:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35725 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2E2Cit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:38:49 -0400
Date: Tue, 29 May 2012 12:38:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: manual merge of the l2-mtd tree with Linus' tree
Message-Id: <20120529123847.00dd0de190388e17a929b21f@canb.auug.org.au>
In-Reply-To: <20120529123301.b3f33396549e0762f26fa80b@canb.auug.org.au>
References: <20120529123301.b3f33396549e0762f26fa80b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_May_2012_12_38_47_+1000_d5tIQUirBJ8Amc4N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_May_2012_12_38_47_+1000_d5tIQUirBJ8Amc4N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2012 12:33:01 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the l2-mtd tree got a conflict in
> drivers/mtd/nand/mxc_nand.c between commit 97c3213fd9fc ("mtd mxc_nand:
> prepare/unprepare clock") from Linus' tree and commit 625bdd2a6bd0
> ("nand: mxc_nand: Use clk_prepare_enable/clk_disable_unprepare") from the
> l2-mtd tree.
>=20
> The former is a superset of the latter.

Actually they modify different functions, so I fixed it up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_May_2012_12_38_47_+1000_d5tIQUirBJ8Amc4N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxDa3AAoJEECxmPOUX5FED3UP/3VQpMQsBvwGw+9rrCXYLKug
tJsWfECxXIqtRbwlubTCDxLVdBV2R0/Imxq/AZHvEVvJPfgVjKYtt5C0F0vb+j98
nM4wF6WcV4GO/tnYvqAUOJHpBQhRlyTxyfmXjd+NgcOVewwrC9S6cPbNXTqe2SX3
vj9TDG3ybtVWcnrQ14ffmm0Zw4UI8PziXiXbiIamFlP3a9IudtIqbJlGO0yK0lcT
gYf2DPYw016sW/P3qNILd9binOjiJT7y+IuATalt0Lplqs2pPIZek6zh1fhIPe4K
XGZnlh/8pO6Lg4LYauGsNTu7caqExL/52XyP6T7ijd9rNQxpVXn4RbuioVw0JAR7
6hzOVYzSfrW+owLMG9nrUaJHVreqjdgkfESJ4kDbTbOdtSmBZ2cv3b0AA/92flab
nEGg1aPr0/aYUlkA/+N2f8AfnVkNuY4O/RmHsyrWJ0FL2iqaXjUWdiJJWlqH0Mjj
wAM5jV0bd7MuloSY0jZCfZkJ9/Q5sR1M55sGtoY/7OO1dswhbNXjNB6u1UCiLg1i
68iSmGJwvOYOiJtb/CdfHr0cZvlQoq7p3zA1QhJW8QVJzwBZHFd/lwTILfIAG01m
RqhcAn4n0IxxWCdgE56LYFh/1g8zS3BJd05U3pb9nq9VEYocTSsbmzlwu953qoup
CBtffyxXhQlDj52rISqh
=fNDi
-----END PGP SIGNATURE-----

--Signature=_Tue__29_May_2012_12_38_47_+1000_d5tIQUirBJ8Amc4N--
