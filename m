Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0IPWEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:04:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46833 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0IPWEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:04:46 -0400
Date: Fri, 17 Sep 2010 08:04:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: FW: next build fails
Message-Id: <20100917080439.7c35775a.sfr@canb.auug.org.au>
In-Reply-To: <1284674337.2411.53.camel@c-dwalke-linux.qualcomm.com>
References: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local>
	<20100916164442.df749cc1.sfr@canb.auug.org.au>
	<1284656407.2411.5.camel@c-dwalke-linux.qualcomm.com>
	<20100917075242.e0bc4b54.sfr@canb.auug.org.au>
	<1284674337.2411.53.camel@c-dwalke-linux.qualcomm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Sep_2010_08_04_39_+1000_u4TWIr1YvPK80vOP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Sep_2010_08_04_39_+1000_u4TWIr1YvPK80vOP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, 16 Sep 2010 14:58:57 -0700 Daniel Walker <dwalker@fifo99.com> wrote:
>
> Yeah, exactly .. This is what I did to update my patch .. Do you want to
> include this, or should I update my version and my tree.. Ultimately my
> version has to go into Russell's tree..

Well, you can't really update that in your tree until after your tree is
merged with Russell's, right (since ALT_UP etc are not defined in your
tree)?  In that case, I need to do the fix when I merge your tree into
linux-next (and so with Russell's tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Sep_2010_08_04_39_+1000_u4TWIr1YvPK80vOP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkpR3AAoJEDMEi1NhKgbsq6YH/juzoCGeG6Xbom/eC9gqNbjK
/QFYSj4Bf5l3/Lx65lsNn3PnuhiXONwTo8nodTx5VG2ELRor02eu5kNUPOPmSE5h
lvBpez3mAEaqzKayFp6ZFZWaYUn2fkhcSIvUWiTMRdF6VDywH4IQ1Uvpq3DS4u2J
bagDKRs31tpyavTxGsZ+G+NiWfZ6NQyoNsd8PxpMQMdXnig4C4VOKj8FaqXmUg7i
KZUDYDbgytDoLneIxSFCuKsRdYClEFkVz0lbM1pwA2wGGdvBbu2SPreWPBmD3Z8V
Ns0YMYmMSny0wSq1uKSqsClYcWOfkN+mAHZjVa88za8nb/AMkDTzZC33AJcZUSk=
=2HNn
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Sep_2010_08_04_39_+1000_u4TWIr1YvPK80vOP--
