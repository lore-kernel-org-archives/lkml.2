Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1CGLm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:42:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59112 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1CGLmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:42:23 -0500
Date: Mon, 7 Mar 2011 22:42:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20110307224217.154735b4.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTi=9AUSv0rJtudgnEBERaCLpyHhVmcUY9mZUa8H-@mail.gmail.com>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
	<20110307063618.GA10365@mtj.dyndns.org>
	<4D749A81.50809@kernel.dk>
	<AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
	<20110307104747.GH20499@htj.dyndns.org>
	<AANLkTinBx5Z9Gp7ZTcbbTMCZZ4Z68-vMBP9yOX-k15EA@mail.gmail.com>
	<4D74BE7C.4050701@kernel.dk>
	<AANLkTi=9AUSv0rJtudgnEBERaCLpyHhVmcUY9mZUa8H-@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Mar_2011_22_42_17_+1100_O.slXhpNw.CkufU3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Mar_2011_22_42_17_+1100_O.slXhpNw.CkufU3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Mon, 7 Mar 2011 12:25:23 +0100 Sedat Dilek <sedat.dilek@googlemail.com> =
wrote:
>
> No, I tried to merge your for-next into linux-next (which will happen
> with tomorrows linux-next).

No, it won't.  Each day I start with Linus' tree and merge all the other
trees.  Doing it the other way would lead to a real mess.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Mar_2011_22_42_17_+1100_O.slXhpNw.CkufU3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNdMSZAAoJEDMEi1NhKgbsn+QH/jBpZ1R53lnDwO+2tXsnzPtQ
Lw9yItqDSJa9FTM5EFFalSIlS00kuYODTC3SzbhnvhtZRQR6XayjhA1J7lTIHw/P
A8vcAo9kKp4lr7zViIJt7YBqkjBQfNC0nQT9+rmPuiEZdh9hMKc3yiIro0EusePv
HK7CiuYH+XihCC03mzLZFodWuHXM/g5QE6X8PWmcy2YPuC4/nB+srwFQUJEQZHy3
24IKiYFXY1XZ4yrBoIm+WkwEhj1NjMCVtgJ0zWQ6x4G6JJdJJmHZklW9/IROrHts
g09enWubYelDNxbmLJQseZcFqUJzFcoVtGkbirqZMYN70bemMjaKw92JyMlkdpc=
=ngDq
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Mar_2011_22_42_17_+1100_O.slXhpNw.CkufU3--
