Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0IFDCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 23:02:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56043 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab0IFDCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 23:02:19 -0400
Date: Mon, 6 Sep 2010 13:02:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the rcu tree
Message-Id: <20100906130210.67e0427b.sfr@canb.auug.org.au>
In-Reply-To: <20100906123255.3eef4311@notabene>
References: <20100906121408.33946fbe.sfr@canb.auug.org.au>
	<20100906123255.3eef4311@notabene>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Sep_2010_13_02_10_+1000_/TQ/Sz2jSstJDCJY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Sep_2010_13_02_10_+1000_/TQ/Sz2jSstJDCJY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,


On Mon, 6 Sep 2010 12:32:55 +1000 Neil Brown <neilb@suse.de> wrote:
>
>  There is a patch in linux-kernel
>     "PATCH] md: do not use ++ in rcu_dereference() argument"
>=20
>  that addresses this - it is a problem in md: I guess rcu as become more
>  helpful in finding these problems.
>=20
>  I'll probably fix it a little differently, but I'll have something in my
>  for-next for tomorrow.

Ah, ok.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Sep_2010_13_02_10_+1000_/TQ/Sz2jSstJDCJY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMhFmyAAoJEDMEi1NhKgbsUu8H/1ibetx5Y+E4t4FD7dG1vXVt
+UmfIj3BbPu7FYCee2v8lBeWom91/Hc4ATOCQaEmnIxI4BmocTUBKva+/qk53ElL
ZvtxM7O8w6ruh99weksX8BWBv5AsOs/5G8t72UgbR/gecHarv3dT9B+Kk1MPFHIK
6UyMayRQq3j1tAKJbcflVVe+cCXk4qhWjTzHdIESJuYFyC714c7bTotNPCz5V048
yebb3v4byFPa9bhAraRVl3Lfscj8eMP0Xs8rXQ9Vusne1Lgp2MMLMw8ueypE+ORC
EcxIR9JCBx+HTx+vy2GFojghHpU3zXZqOiGZY/HZ7VXPL/uiL+86BdEd0hSM7/o=
=yBlV
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Sep_2010_13_02_10_+1000_/TQ/Sz2jSstJDCJY--
