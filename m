Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1KAEGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 00:06:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57460 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1KAEGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 00:06:45 -0400
Date: Tue, 1 Nov 2011 15:06:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
Message-Id: <20111101150634.11c236c851fbc7e4c8813220@canb.auug.org.au>
In-Reply-To: <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
References: <1319764761.23112.14.camel@edumazet-laptop>
	<20111028012521.GF25795@one.firstfloor.org>
	<CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
	<1319766293.6759.17.camel@deadeye>
	<1319770376.23112.58.camel@edumazet-laptop>
	<1319772566.6759.27.camel@deadeye>
	<1319777025.23112.67.camel@edumazet-laptop>
	<CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
	<1319803781.23112.113.camel@edumazet-laptop>
	<CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
	<CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
	<1319813252.23112.122.camel@edumazet-laptop>
	<CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com>
	<CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_15_06_34_+1100_9ynfJ7VuJyxVYV/0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_15_06_34_+1100_9ynfJ7VuJyxVYV/0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 29 Oct 2011 10:34:30 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> In particular, I worry that I'd need to add a "#include
> <linux/compiler.h>" to some header file, although I suspect it gets
> included some way regardless.

Its that assumption that I usually pull people up on ... See
Documentation/SubmitChecklist Rule 1.  It may work for you, but may well
break on some other config or architecture build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_15_06_34_+1100_9ynfJ7VuJyxVYV/0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr3BKAAoJEECxmPOUX5FEZF0P/RizZkX0I8V28P7ckac0NfNj
ow28kj4ItOjhsUkvXrYYhHCqZijDBAT1whaA8FxuynHTgw1Z2FQ8b7jklM9eeKmH
CVZjSJbXxrchN4YPz07vBSiIS2S311oPAsUeo0UcDrh3EUboUWKi2lHrEJpYSr6G
Oxi7vZ8E+OeZcbZ7EXT/af8gXREQgCZGXPUHi2QzYotdXPkF6sKjPokIL/j95T5E
flEtkXQSPh+lEm6Hj7MkIAjioJJBSZpkSZ4NHdU+gtCBPrFFbkKqpo4id3AaWV6l
SE9p2JPEG3UBkz/DfH0CuVFRbwFBhzd1TweJ/XvdNJr5xuEdJ5/34HvV2RZPzOjX
S0l81Ouz4SppxJ1yVjWakF2dyoYMpRZljSX+4zqYK1tzx51e5bdk9TmNsqSQYYz0
K49pxcv3bC6vF3XKcGSFdc/GKfB5IwAViBUSK+BHhtz28vwgCxblUkr6iFoYs5bi
exVthdBtCv3+Ld55pzkAPiJK9Zz5OQT8u9VUyieuuWn7RDfTU6laqhununkW1d0k
c0yGnxrARyN4TkAEnYBA93olU/5edHig38Opwm9FNfeR+WZ5TWT3BvLNCyh8/mEu
W1vtF4Qmm+/zrRXLScu3YNlmE1ckYJp/6eusUDrsU1KRpknMO+ywyORzxZBsz00j
A+pr+QqVv1dyJLFTFFvE
=fngi
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_15_06_34_+1100_9ynfJ7VuJyxVYV/0--
