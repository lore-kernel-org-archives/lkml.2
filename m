Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1I2BPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:15:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:45048 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1I2BPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:15:24 -0400
Date: Thu, 29 Sep 2011 11:15:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110929111516.1fc21972dd78b4e38a17e1d7@canb.auug.org.au>
In-Reply-To: <CAP=VYLrHGYXpXaHn0GbE5ysRXkNhnqVimC01K3inwXq_KPBtYA@mail.gmail.com>
References: <20110928184150.0fcf097b7f9128f8639059f3@canb.auug.org.au>
	<4E83243A.7060408@windriver.com>
	<CAP=VYLrHGYXpXaHn0GbE5ysRXkNhnqVimC01K3inwXq_KPBtYA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Sep_2011_11_15_16_+1000_gXDNuF.ODsVWBSj5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Sep_2011_11_15_16_+1000_gXDNuF.ODsVWBSj5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hu Paul,

On Wed, 28 Sep 2011 20:15:45 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> I figured, given the footprint of the module.h stuff, that it is entirely
> unfair for you to have to carry all those changes that aren't in the
> merge-base of the module.h branch.  So I've created a post merge
> commit series that I'll maintain -- which will have the commits that
> can't be in the module.h split branch, but will be required, once all
> the linux-next content has been merged.
>=20
> If you clone:
>=20
>    git://openlinux.windriver.com/people/paulg/modsplit-post-merge
>=20
> you will get a repository of commits, and a series file (just like that u=
sed
> for longterm/stable queues) that you can deploy onto linux-next to get
> the changes you'd been carrying, plus new ones I found by testing on
> linux-next myself.
>=20
> I'm hoping that you can plug pulls of this post-merge queue into your
> infrastructure in a way that moves the burden off you and onto me.

OK, that is easy, I will just use your set of patches instead of my set
of merge fixups - it just drops in.

Thanks for that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Sep_2011_11_15_16_+1000_gXDNuF.ODsVWBSj5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOg8akAAoJEDMEi1NhKgbsa8cIAJeLRlolQMJQ/7RN3R0Fw11E
ZiNJgwlIZ9JstJkAN9yXgbbjoPxl0lR0YIJ/4PKVp9OsT/er1r78UEsJ+P5wZGXs
OfRGWZda6RARNppiBsV1GmOEWQ4unZAaSJFk0NiqDyWoDQ4Gpzcy41bPZQKvT1SZ
Uvr3iLbEqR4nJNyInRkksXMqnNvqMHdEEgHnEugioggDxJRG4iFSQunSuBjweqZk
VA6LD9ZOPPRqtsBB9z6hJ76wMPkHWrEqtuXgoc+GhVUSyIBJCqdqZs2c8UDC31k/
LUqfYFHCBP8coP0/GBrnETn2dzG4p+ySlPwNcqgO7KQV54v6uALXHpqYjOTi628=
=EomF
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Sep_2011_11_15_16_+1000_gXDNuF.ODsVWBSj5--
