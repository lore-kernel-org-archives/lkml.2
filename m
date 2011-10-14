Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1JNAEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:04:39 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:50454 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1JNAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:04:37 -0400
Date: Fri, 14 Oct 2011 11:04:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please include const-sections into linux-next
Message-Id: <20111014110425.ce5b966f8f8882114028a23d@canb.auug.org.au>
In-Reply-To: <20111013233818.GB26654@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_11_04_25_+1100_BVWE1sgvs6u9IbVC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_11_04_25_+1100_BVWE1sgvs6u9IbVC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Fri, 14 Oct 2011 01:38:18 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
> Please include=20
> git://github.com/andikleen/linux-misc.git const-sections
> in linux-next. This has a tree sweep to fix all kind of constant=20
> section issues.
>=20
> I intend to send Linus a pull request next cycle and would like=20
> to get some testing in next first.

You picked a bad time unfortunately.  Today will amost certainly be the
last linux-next tree before the merge window opens (since I will be on
vacation until kernel summit) so if it breaks the tree, it will impact on
others testing (and there won't be a followup tree to correct the problem).

Also, the commit messages are still very terse (as a few people pointed
out) and I have seen no response to Thomas' remarks either.

> I got various acks last time it was posted and added them all.
> In general it falls more in the "trivial" category, but it's=20
> rather large and all over so I may have made a mistake.

It really isn't trivial because we have had various problems with init
and const in the past with various toolchains (and even different
problems on different architectures with the "same" toolchain).

Linus or Andrew may still want to take these, but I don't think I can add
it to linux-next right now, sorry.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_11_04_25_+1100_BVWE1sgvs6u9IbVC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl3yJAAoJEECxmPOUX5FE32QP/Rkc5yeAo1xT9uCuCdIsi2p4
PznXKlYgWs8bwlae+BeBOGU5avVih9zs2VS85NuM+1MKWV6Ec/dXQ2eH0O7S35oB
lTRz0N6M2INdX2MXqI1i59UmUhZT2fDqMUcwbnA8KoSwfShkcue2SkRFXlzJuJkH
1JxAaMWyyi4pP5teij2ARw/k1eIKFHKRs1wSxAK7a/nMVU4gC8WD+H35XByeTxcm
YVQXTkLIBLTousKKshQX6J4oTRN4f494AzD3DX34eX0NjTUQsZWWuNL6lefcPXk5
z8uUgj2B63QEoQkf1fK8q8/4oOhCvWN5FMd+rfIcaKeWziR6h25CRjbkbIn4eaSi
rWV6z3TIdXfu4dKkr4FRiRuK2A9odJ0zO6YxBW5MaqXY23olHfMC1eTCg7TBA2Yu
7hyvDFd07C7rtCEbiHcy1/eZt3M13+XOd2FC0l8gMuY37c/UHEOGBaYQ7ujbJIeP
5ifwUl3FDv21qUArevwOw6QxZMYwH7QWL8//cQWAfaNt0/w2JsPJG6LNraYFC+9v
gwFaD/CEkV3BxMp0W6nwgKQjD8pKbXR9gU8IVD/8gT749ifM8Vjt6XfmXkjrLYJR
uHAh9lS5FwU3joGYmvfLOGxlPI2d+lh4TPGxQk9CGSFFoO/RbU/4fEbNkMJQ3yKj
1g0emSYDVVdOopDmpOHB
=mdEI
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_11_04_25_+1100_BVWE1sgvs6u9IbVC--
