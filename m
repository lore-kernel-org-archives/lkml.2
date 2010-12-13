Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab0LMXVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:21:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55226 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab0LMXVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:21:43 -0500
Date: Tue, 14 Dec 2010 10:21:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-Id: <20101214102136.2f247814.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTim=XVg8fcbAbVJS1bu-Auw7i70AEEH+hoH7tUgS@mail.gmail.com>
References: <AANLkTim=XVg8fcbAbVJS1bu-Auw7i70AEEH+hoH7tUgS@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Dec_2010_10_21_36_+1100_JlDnZ1ynn.l+b9tb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Dec_2010_10_21_36_+1100_JlDnZ1ynn.l+b9tb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Mon, 13 Dec 2010 17:48:18 +0100 Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>
> I will give this new refreshed patchset a try (testing against
> systemd-v15, vfat problem I reported) with none-BKL-config of course.
>=20
> If linux-next will be the new base, then please rebase on it (see below).
> (Last time I solved the CONFLICTs manually).

Nothing released publicly should ever be based on linux-next (unless it
is a short term testing only tree like -mm) as it is rebuilt every day.
Thing should really only be based on other publicly released stable trees.

This is especially true of trees that will be included in linux-next
itself.

> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-np=
iggin.git
> vfs-scale-working:vfs-scale-working
> remote: Counting objects: 1196, done.
> remote: Compressing objects: 100% (80/80), done.
> remote: Total 931 (delta 866), reused 915 (delta 851)
> Receiving objects: 100% (931/931), 207.90 KiB | 376 KiB/s, done.
> Resolving deltas: 100% (866/866), completed with 258 local objects.
> From git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin
>  * [new branch]      vfs-scale-working -> vfs-scale-working
> CONFLICT (content): Merge conflict in fs/fuse/inode.c
> CONFLICT (content): Merge conflict in fs/super.c

Thanks for the heads up, though.  When I include Nick's tree in
linux-next, I will do these merge fixes if necessary (as will Linus when
it gets to him).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Dec_2010_10_21_36_+1100_JlDnZ1ynn.l+b9tb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBqqAAAoJEDMEi1NhKgbsktEH+QHg7WVj25idpn3pxaWrAGYg
UNygg7nxWwL6twSKYxXCK8QbnOtvUSu3n8s4Na+m6+y1h2Hjpwq4zQfZ6jNuM4bk
oHGZ5vCOAxFvl4P/ST8UjBn0TTUYHjbN2ZJlusOctPivDkIUUoRf84T6UEod8Q0Y
zxkbHPKZSKq2UtSvpMP1pgUBQ3I2dbkyZWToytXtwf9o320kezeWoX+5ZcPcrwLl
6wEs9TX+EaQr/S3h3AIaZiQ0vyiIqvYqAU+h6xj3yt/nMgyXaN2/40qU1y7A9sm8
UFER1AfR3bMKkRNaoSIbQ8zbfZy/pyr9cd8OT+LIgftTEJwuC/+/wJ1xPRzagCw=
=W1jM
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Dec_2010_10_21_36_+1100_JlDnZ1ynn.l+b9tb--
