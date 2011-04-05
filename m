Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1DEI0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:26:48 -0400
Received: from smtp207.alice.it ([82.57.200.103]:57454 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1DEI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:26:46 -0400
Date: Tue, 5 Apr 2011 10:25:40 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH 7/8] Documentation: consolidate leds files to leds/
 subdir
Message-Id: <20110405102540.091ec116.ospite@studenti.unina.it>
In-Reply-To: <BANLkTikSbTgsH1zHm+mEu6C3R5dEsw2ogA@mail.gmail.com>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
	<20110404150846.54034f1b.rdunlap@xenotime.net>
	<BANLkTikSbTgsH1zHm+mEu6C3R5dEsw2ogA@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Apr_2011_10_25_40_+0200_6V2RNsEkJyK_UDEw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Apr_2011_10_25_40_+0200_6V2RNsEkJyK_UDEw
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Apr 2011 17:54:04 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Apr 4, 2011 at 3:08 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > Changes since v1:
> > =A0- don't use git renames
>=20
> Actually, I think it would make it much easier to validate the patches
> if you used git rename patches for things like this.
>

I agree, and I did that for the first review round.

Initially the patch was meant to be handled by Andrew Morton, maybe I
misunderstood one of his comments from
http://www.spinics.net/lists/linux-doc/msg02562.html :

	"hm, these look like funky git renames.  patch(1) doesn't
	handle those."

and though he wanted me to change that.

> As a traditional patch, it's impossible to see that "yes, it's a
> rename". There might be tons of changes hiding in the add/remove pair.
>=20
>                           Linus
>=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__5_Apr_2011_10_25_40_+0200_6V2RNsEkJyK_UDEw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2a0gQACgkQ5xr2akVTsAFAgQCgsjMZpopPCOtTn2OyEWVEvrnc
xRMAnRQn1WFYI/htZU00w0vjF9fC9X6M
=QUxr
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Apr_2011_10_25_40_+0200_6V2RNsEkJyK_UDEw--
