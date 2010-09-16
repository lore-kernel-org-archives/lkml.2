Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab0IPIvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:51:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0IPIvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:51:51 -0400
Date: Thu, 16 Sep 2010 18:51:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-Id: <20100916185141.4d471a23.sfr@canb.auug.org.au>
In-Reply-To: <20100916172322.4f37e912.sfr@canb.auug.org.au>
References: <20100914134321.5eee798a.sfr@canb.auug.org.au>
	<F45880696056844FA6A73F415B568C69532D96AC51@EXDCVYMBSTM006.EQ1STM.local>
	<20100916172322.4f37e912.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_18_51_41_+1000_UU.YaEEk3SNU278y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_18_51_41_+1000_UU.YaEEk3SNU278y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arun,

On Thu, 16 Sep 2010 17:23:22 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> > Please find the patch that fixes this build issue @=20
> > http://git.kernel.org/?p=3Dlinux/kernel/git/sameo/mfd-2.6.git;a=3Dcommi=
t;h=3Df33bd494862cdc519db1f5d9b3f8214a1dd4c1ff
>=20
> That patch was in the tree that produced the error above.  The patch you
> quote is a fix for a different build problem.

Oops, wrong error.  I need to read better.  Ignore this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_18_51_41_+1000_UU.YaEEk3SNU278y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkdqdAAoJEDMEi1NhKgbslaQH/0ffUkrT139BinpKo95+QlEZ
PyBMKREi5IQypxsHOdekCHBkB9qYtPX4P2H1qsFGy9PIiGws5AJNj5aFfh4ZfPjp
CHffbfnHEuwBv5Cvr1TWcCToEz4x0qCo64Jnrw+5U+GHGzWIF81us8ary/ayQW6l
tQnxb4oUUly+nTXuoVUy3+WWQXwM3KigHi3ax6kEzJarBxkRXG1pDy47Yq11Ny+H
pbkhLDD48F/Rmr6fVD7lIXviUnBoESoipcgO6iWK6jcvdTK2V8a/oWNbN4Fw+k9F
34nr9H1TfBcYseXcK9IPseQxoveyULeAtB7FAN/8Fj1FvTYWrDPYuVrC7IfDnuU=
=0yQD
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_18_51_41_+1000_UU.YaEEk3SNU278y--
