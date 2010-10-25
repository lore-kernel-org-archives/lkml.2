Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0JYKNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:13:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34572 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0JYKNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:13:36 -0400
Date: Mon, 25 Oct 2010 21:13:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: error importing i2c quilt series
Message-Id: <20101025211327.9d40f4a1.sfr@canb.auug.org.au>
In-Reply-To: <20101025112519.5d932562@endymion.delvare>
References: <20101025105900.83472a69.sfr@canb.auug.org.au>
	<20101025103404.73c24f45@endymion.delvare>
	<20101025195349.f5ac62eb.sfr@canb.auug.org.au>
	<20101025112519.5d932562@endymion.delvare>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_21_13_27_+1100_Jnk2XjiancwuuT37"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_21_13_27_+1100_Jnk2XjiancwuuT37
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Mon, 25 Oct 2010 11:25:19 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> I thought it was NEXT_BASE, with an underscore not dash?

Ah, yes, sorry ... (but my scripts actually handle either)

> And I also expected the trees to be merged in the order shows in:
> http://git.kernel.org/?p=3Dlinux/kernel/git/sfr/linux-next.git;a=3Dblob;f=
=3DNext/Trees;hb=3DHEAD
>=20
> As pci is listed before i2c, I (wrongly) concluded that everything
> would be fine even without using NEXT_BASE. I stand corrected.

What actually happens is
	I fetch all the trees and quilt series
	I import the quilt series to git branches
	I merge the trees.

So you cannot depend on the merge order (which sometimes changes as
well).  This makes sense since I have no influence over the order that
the trees get merged by Linus ... If there are dependencies, they need to
be explicit, sorry, using NEXT_BASE in quilt series or merging (sub)
trees for git.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_21_13_27_+1100_Jnk2XjiancwuuT37
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxVhHAAoJEDMEi1NhKgbsev8H/1FBHmqfr+Ik8ZmBApEAupFH
5QFfZCAZiAWxpZiwd5VlCvqLoUsIrShUlQ5fuSZ+lhZq9Co1+iLQT5MlG7Ba3RQH
bkVmWdw4CI1UnrjEIwE6eM2bqy/inPk1OEH5zv6e4liKGaLIehgdRM32biFpIaDy
swQfp2gPKwNsCKdifPheJx1HNUuXnW5vGFpzobFqGqRHrUoLypvvYbaBwCKKUKXD
21ICLpAXAyYDcAJjtF1NlZBMZr6grPlyOhissYtsUwC8Fm0NVjAY3EiH9BKWRqCo
p9FjWPTr9nrEJNgkIw61by48syPsylqE9BqxczgXrQiJwVtsjnWHBpeqbzsq9xc=
=+BBc
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_21_13_27_+1100_Jnk2XjiancwuuT37--
