Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1JAJjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 05:39:40 -0400
Received: from swan.madduck.net ([80.68.90.58]:33053 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab1JAJje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 05:39:34 -0400
Date: Sat, 1 Oct 2011 11:39:31 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: I/O scheduler on its knees, pvmove hangs other tasks
Message-ID: <20111001093931.GA22428@albatross.gern.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20111001092858.GA12945@albatross.gern.madduck.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20111001092858.GA12945@albatross.gern.madduck.net>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux wheezy/sid kernel 3.1.0-rc4-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach martin f krafft <madduck@madduck.net> [2011.10.01.1128 +0200]:
> The problem is that the kernel seems not to care. The pvmove process
> happily chugs along at what seems to be maximum speed. At the same
> time, other processes, like /bin/ls simply block and remain in 'D'
> state *forever*. Even after the pvmove process exits, these
> processes do not recover.

Okay, I lied. In a test I just ran, the test process (ls) recovered
after about 10 minutes. It seems that this time increases
exponentially with the number of hung processes though.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"you don't sew with a fork, so I see no reason
 to eat with knitting needles."
                               -- miss piggy, on eating chinese food
=20
spamtraps: madduck.bogus@madduck.net

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOht/TwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xN/t
D/oDJ379qmsLtHT5xzOZl0JH+yDTuDA7HXzLsijuryizsO0FFyYBXzb5jws0/W/H
6iL5lGN2lCdcOrDT9gcNSEinsnoXzZHglVd70pjHCuDEuVyX5G7CJ76gCEnOYzMF
kEv1hyUY8PWpOkPm83wsc2g/KGkd8AMHyJFx1O8uiiIffJ7x+elAx+yNXeOYcr1G
V43RaIlV2XR0lpD7CQKO6U87glY3lw4fxcz89K+4JOasBlRyfhjdulPlBM00isNm
lAlBu47+W2+XbiTbtjFDh/Golg2XCmJhrVwDp9IWI80i0i9vdV1yLlCOTAHNOJ2o
CiTB0tuzpHjYdbH8LrH4qE1J6ASkQu/qnWPnnhxCNpCTTXG/ji0UcbtWQnxBytKA
Wj1gbTZ9D8X150TX+xoK0CFxvKERBv5O/z+iYmJHBYM3IZWVPL4Zxo7JKt25AgkP
+XdKXSXeavwuvPcNh5wRZcxdztuPcVWANe0iyuYlz0AYeEuKPECFpUtbnWofOTT4
NYA/CkS71wDKa3WhhBRashcLXtx0fGebY6GuwlQYi7hp2ByBShFF0WiLWuGFImzv
Gn0qlF14ye9XgftuxaW1llxziRRE7YDWinOCygZzGvGLbMNKPkVi1TCSL0QTjaYM
6PrQiLVMhj63IAJ9Rm7GzFgEdUQtPVmyvZvHo4viyCEM1w==
=MhSn
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

