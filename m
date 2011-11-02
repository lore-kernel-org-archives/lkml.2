Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1KBCoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:44:18 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57776 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1KBCoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:44:17 -0400
Date: Wed, 2 Nov 2011 13:44:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, rusty@rustcorp.com.au,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] introduce export.h; reduce module.h usage
Message-Id: <20111102134403.ac0356474f31c16998ef5103@canb.auug.org.au>
In-Reply-To: <CA+55aFz7dRWdQy_39+sCMeuqkavg8gYYyH_4u-n66OFVYzAWTg@mail.gmail.com>
References: <20111101004542.GA18671@windriver.com>
	<CA+55aFz7dRWdQy_39+sCMeuqkavg8gYYyH_4u-n66OFVYzAWTg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Nov_2011_13_44_03_+1100_BiD2zDh+dUFJShmu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Nov_2011_13_44_03_+1100_BiD2zDh+dUFJShmu
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 1 Nov 2011 16:59:53 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On Mon, Oct 31, 2011 at 5:45 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> >
> > Please pull the below to get the module.h split content. =C2=A0It has b=
een
> > tested on v3.1-rc6, soaked in linux-next, and re-tested again lots more
> > today after rebasing it to allow most of the linux-next finds to be
> > blended in, where they could not be on the original v3.1-rc6 baseline.
>=20
> Does it bisect cleanly?
>=20
> Quite frankly, for something fairly trivial like this where the upside
> is mainly "slightly faster compile" (and hey, perhaps cleaner source
> tree), the downsides needs to be minimized.  And just looking at the
> shortlog makes me go: this will be a bisection disaster - people will
> look for bugs, bisect will go into this series, and things won't
> compile.
>=20
> But maybe it's ordered so that the actual module.h split comes last,
> exactly so that it would be safe and bisectable? I just don't know,
> and I'd like to know before I pull..

Well, from the commit comments, it looks like Paul has made some attempt
to make it bisectable (see e.g. commit de47725421ad ("include: replace
linux/module.h with "struct module" wherever possible") near the end).
And the actual split (even though it is right at the start) is not really
a problem becuase the new export.h is included in module.h anyway.  The
problems come when you remove module.h from a file or replace it with
export.h.

One the other hand, there are some commits near the end that are cleanrly
just fixing up problems caused by earlier commits.  They could probably
be included earlier in the series (most of them are trivial).

Anyway, Paul can speak for himself.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Nov_2011_13_44_03_+1100_BiD2zDh+dUFJShmu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsK5zAAoJEECxmPOUX5FEOfEP/Rx8GBz8g0J0p0lGe5Mvc4TU
OtLIGCM7QF6Edz0L0aBB3zgPRJwKncor/xIF0yHu+/zaL1TmpIg9bEnOreHEJgL4
EiqjDhuE7Ueq3iXhh9EujDZh55QOh29wAjtX4oJcnNQkx82ls6ebXAy6Fgv1lgKV
HJkVOnQ+iXnSDTpwyySB9tZ/n1as5/oeQrepBlR8VL/ArS02WTubDYIFOtzYxYp6
QywhwHwRNFdGfcalbhJZw8sB+K4RUDEXHUIhoHkbvVVI8uEopqpymGoVVO5QoXAg
5+sr4TeDeqTwBv9bPvADaN/tDdGy+anmTI9hafQFmtTqfYwf70XarrWEgWvHyd4x
swLSuTS/TN9y/kiNN6eXwn1jbEfDhB4vVyG+TzA2Q7NVYm5MpUDxMMf1Wippuy8l
unGgu8JZnXbFFYiM716Gt92y4WP+nvXoA85oYIRcmAIODYe6fL3Zv8ERL/Seh2Qh
whbVuIcVmIPDIsaozEOEMfbMZpv9z4/mtEPOyHROjVa6fbNL1BZpZyW3lRcVww9h
DlwFMNuNfaSwOuTnBaPlKiKdt0NI6Cj/w5DoxEKWrHn9qZNjaso8OPv4KdbEeSCW
v27SEZTJ/FOvp1FBVWOmiZaK8zSQBmLRG8FUWKabDo1tfiGqzQBnQW5oL6XcdfDR
AW7GNwUdZVVwzLhK2dR6
=b69+
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Nov_2011_13_44_03_+1100_BiD2zDh+dUFJShmu--
