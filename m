Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0E1A4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:56:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44436 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0E1A4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:56:19 -0400
Date: Fri, 28 May 2010 10:56:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20100528105613.fdf00a99.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_10_56_13_+1000_ousfok09jR.IxZ6/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_10_56_13_+1000_ousfok09jR.IxZ6/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/input/touchscreen/ads7846.c: In function 'ads7846_probe':
drivers/input/touchscreen/ads7846.c:1167: warning: format '%ld' expects typ=
e 'long int', but argument 4 has type 'int'

Introduced by commit 067fb2f648543894ce775082c5636f4c32b99e4f ("Input:
ads7846 - return error on regulator_get() failure").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_10_56_13_+1000_ousfok09jR.IxZ6/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv/FK0ACgkQjjKRsyhoI8zffgCgptQWR8cSUddgsWrMNBaYA+89
oEUAmgKr/huYkP5o30+n0Z3WAhQpm4F0
=AeCp
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_10_56_13_+1000_ousfok09jR.IxZ6/--
