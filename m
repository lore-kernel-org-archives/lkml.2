Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2C1AEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:04:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34854 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2C1AEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:04:06 -0400
Date: Wed, 28 Mar 2012 11:03:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>, Bob Liu <lliubbo@gmail.com>
Subject: Blackfin link issue (Was: linux-next: triage for March 27, 2012)
Message-Id: <20120328110350.e2d44e1f66b6ac7f9fd82843@canb.auug.org.au>
In-Reply-To: <20120327213626.GA10022@windriver.com>
References: <20120327213626.GA10022@windriver.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Mar_2012_11_03_50_+1100_ayDTQFfciXQhULn8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Mar_2012_11_03_50_+1100_ayDTQFfciXQhULn8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 27 Mar 2012 17:36:27 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> The blackfin builds are no longer failing on vm_is_stack but instead
> are all failing with "L1 data A overflow!" at final link, which smells
> like some kind of binutils/toolchain issue.
>=20
>=20
> bfin:***all-builds***
> 	when:	Mar 26
> 	why:	bfin-uclinux-ld: L1 data A overflow!
> 	status:	unknown, binutils issue?
> 	fix:
> 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/

It actually looks like this comes from an ASSERT in the blackfin
vmlinux.lds.S ... looks like some sections overflowed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Mar_2012_11_03_50_+1100_ayDTQFfciXQhULn8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPclVmAAoJEECxmPOUX5FE31MP/0SidMrl68xVGnf5sIiB2HVO
K4/Gry5s3mX6ITnQzSHjdrHP8Za6+lSxwP9HA48g3gSGshC0V9CriwJY0eFGbhbr
j2auzt3C9bRAjEz+UGfAz51qq58mqRFUYIw7FIeIRETgWC/vwLjjKDbvMF4HxVTo
7QGjSoEP4YDKN0AwmVhHx0laO1ZBXM7QexiURNMNXJDD0SxOeVPvvSGBk2vGJ5M8
yOgIODxC97rVzbbcQWHBDq9Ts0NNjLy/uMSw5AXF9cXa/aCRPLxGLwNgRarWxjmI
vL0Ul7GvXNRIxFeYSVKPnsSXWOdZmyP6mCvRuEcqovk8vWh/zCPmr84CHwXqsQLU
YFIzqIkRpQiHFhwCbKViNaml8CEoEVf46SqFslRArmTlDSyjfdC0UMP1Hzf4llP8
VazwxH1INI1L1BpVgW4bSyN6lcilCD9b5Q3R6EpGvGe9nHLMZyNtboZpnLNoVkoF
0SKABceWIwM9TiFKqyP5ckNasdk0z3B+n6IuYdBNZneiWTchH8hiIvlnlrA6q4SL
YlDtK/fR3e9AusaLLaPgh36oAInu4SNcm4H8lweJjloA5XOfhe0D6tTqnACojGjm
n3qXT1jtPJxER+QY+5rGpzYo9oGyipTy02ELToQYqmsVVLBqMtdDmYJdUjm3atrP
Z4jkFTfdBpQbj71+HHmV
=4wXA
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Mar_2012_11_03_50_+1100_ayDTQFfciXQhULn8--
