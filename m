Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1CUXdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:33:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49623 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab1CUXdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:33:09 -0400
Date: Tue, 22 Mar 2011 10:33:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <david.woodhouse@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20110322103300.c934a540.sfr@canb.auug.org.au>
In-Reply-To: <4D81E64F.2020909@kernel.dk>
References: <20110314161919.15e6d983.sfr@canb.auug.org.au>
	<20110317103218.ca7f63bf.sfr@canb.auug.org.au>
	<4D81E010.1090808@kernel.dk>
	<1300358170.2589.50.camel@macbook.infradead.org>
	<4D81E64F.2020909@kernel.dk>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Mar_2011_10_33_00_+1100_zB1BGkGCxpF5TIBL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Mar_2011_10_33_00_+1100_zB1BGkGCxpF5TIBL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

On Thu, 17 Mar 2011 11:45:35 +0100 Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2011-03-17 11:36, David Woodhouse wrote:
> > On Thu, 2011-03-17 at 10:18 +0000, Jens Axboe wrote:
> >>
> >> Can you point me at the commit in question? Generally,
> >> elv_queue_empty()
> >> can be replaced by blk_peek_request().=20
> >=20
> > The interesting commit is this one:
> > http://git.infradead.org/mtd-2.6.git/commitdiff/c7519dbf6
> >=20
> > The point of it is to enable this
> > http://git.infradead.org/mtd-2.6.git/commitdiff/a32159024
>=20
> OK, can you commit a change just changing that to blk_peek_request()?
> That'll avoid the conflict.

I am still reverting those three commits from the mtd tree ...  David, I
assume that you are going to want to ask Linus to merge the mtd tree at
some point soon?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Mar_2011_10_33_00_+1100_zB1BGkGCxpF5TIBL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNh+AsAAoJEDMEi1NhKgbsgj8H/j8xgt9/yaPKWbY8Zvqqa9/M
WyII1zfhoI0lIXj6pRhac3AbiQgrumUnk+7Cc7fBpvatwVRvhWgXEJKIVNE84gqD
tYmIj06ase+h58zcg9Ma4w/kiA0/Id+tNu8KkR6IeAkn/lnYz1XGowt2HcG2pp+V
qtf9FTLDYa6B7dHzm1vRhjqu5qA0LAQMHmm8XirgUrwJMiU944IUWuc7GeK6t5Cp
cvPJWzE32TIWEDxsojfFLU0AKrkcb8TYD2i1HT3lzPSEuOaY4bH7lXWsV9h4ITS3
mEmRlshJiAyC1zf4goIzDBA/9o8VgtPTrj8AVhqgbiKjTvDN5S9wMZx1XBLt/Vg=
=YyJk
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Mar_2011_10_33_00_+1100_zB1BGkGCxpF5TIBL--
