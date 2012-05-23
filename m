Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2EWFO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:14:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52740 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2EWFO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:14:28 -0400
Date: Wed, 23 May 2012 15:14:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] signals, the first series
Message-Id: <20120523151405.f264a88ca4edf8d22c08c86c@canb.auug.org.au>
In-Reply-To: <20120522180635.93ba83a63481b2364bd8f425@canb.auug.org.au>
References: <20120522043525.GI11775@ZenIV.linux.org.uk>
	<20120522180635.93ba83a63481b2364bd8f425@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_15_14_05_+1000_LFEKdtMYsdkeZlVb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_15_14_05_+1000_LFEKdtMYsdkeZlVb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Tue, 22 May 2012 18:06:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 22 May 2012 05:35:25 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrot=
e:
> >
> > 	This is just the first part of the queue (about a half of it);
> > assorted fixes all over the place in signals' handling.  This one ends
> > with all sigsuspend() implementations switched to generic one
> > (->saved_sigmask-based), a bunch of assorted old buglets fixed and most
> > of the missing bits of NOTIFY_RESUME hookup in place (two more sit in
> > arm and um trees resp. and there's a couple of broken ones that need
> > obvious fixes - parisc and avr32 check TIF_NOTIFY_RESUME only on one of
> > two codepaths; that'll go in the next series).  Please, pull from
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git for-linus
>=20
> I am pretty sure that none of this has been in linux-next ... I have no
> idea what sort of conflicts it will produce with the rest of the code in
> there or what issues that giving it some time in linux-next may discover.

OK, it seem that most of this has been in Andrew's tree for a while,
sorry about that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_15_14_05_+1000_LFEKdtMYsdkeZlVb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvHIdAAoJEECxmPOUX5FEkoIP/R1mYajJTzf7z4Z3gbsnGfOV
EdMOxU3jmNtz8YhvaImibln5zWf2wB7c9xVYvhiwMIrw8ikvwRkPY4B+qSAyiedt
bcmnL5QTnm+06k7BYn1C/Q5Go68/M5e2HijlOzUfrD2tzY5iGc/l8QMCM1rAhr64
QmZQf8x39YJpzIguvSn3Bs9mEDpc4UMKKS2j6BuemHOzIZQvGYy9bhjRVw3fVfFj
UNIl43JImHOYs4SbXngflNIKVOapA2NIYasTdGGPb9sPbOxyFyZ1miIBKBYfZ+Ik
M6l6PPgMRgiX+BywHULJTjR+ut6u8gWY6fe2cAOBtdToAi5Zm3ZRQHZqxEj7WVyq
MDlhvsVNknNE1dJsMcBvCKSS/OrhBUljQVJ3DxifmEtuA3+3wkkwK7E6p3yk7XPk
keFk3ZSmXyrp3OG+sqzXaLBkHQvx2LtlTTGVU9hMBWTlynCixBM8eQv/nr19uL5G
lJGwO+XgKZwJG8IqychgJhbyyGGVl5f4Y+Nyyz8mgV2bEaon4XE98KFR6Aok12ZA
riyAe3RMn2ETNDGW8LWEYIOvX02OSRmwUUNmvoT503uU6ABitun/Yq73PTPIUTOp
iuvm1USXIIntkjDD6hnTs6XWLMFxpUG9X7r8LAxa4JCKQFRywBtHjCKMaM020KCP
XQdFIkz4M3NK8YykPaj4
=GoYJ
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_15_14_05_+1000_LFEKdtMYsdkeZlVb--
