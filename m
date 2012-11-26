Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2KZWsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:48:30 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59059 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2KZWs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:48:29 -0500
Date: Tue, 27 Nov 2012 09:48:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [RESEND] Request f2fs filesystem inclusion in linux-next
Message-Id: <20121127094818.c2fa217b785ba4cb386bfe16@canb.auug.org.au>
In-Reply-To: <1353929860.26584.63.camel@kjgkr>
References: <1353734925.26584.43.camel@kjgkr>
	<20121126101839.cdea3cebc6534722072e3fd0@canb.auug.org.au>
	<1353929860.26584.63.camel@kjgkr>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_09_48_18_+1100_TrvaaBoG6UW_SlpT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_09_48_18_+1100_TrvaaBoG6UW_SlpT
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 26 Nov 2012 20:37:40 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com> wr=
ote:
>
> 2012-11-26 (=EC=9B=94), 10:18 +1100, Stephen Rothwell:
> >=20
> > On Sat, 24 Nov 2012 14:28:45 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com=
> wrote:
> > >
> > > About two month ago, I submitted a new file system, namely
> > > flash-friendly file system (f2fs) to LKML.
> > >  http://en.wikipedia.org/wiki/F2FS
> > >  http://lkml.org/lkml/2012/10/5/205
> > >  http://lwn.net/Articles/518718/
> > >=20
> > > In the mean time, many folks have pointed out several essential issues
> > > on f2fs, and now I think most of them have been resolved moderately.
> > >=20
> > > So, I'd like to request a new branch being included in linux-next for
> > > the purpose of merging into the next mainline kernel.
> >=20
> > I have no problem adding this to linux-next (and noone has screamed aver
> > the past few days, so that is a good sign) except that the branch you
> > have submitted is actually based on linux-next itself.  You cannot base
> > anything on linux-next as it rebases every day.  You need to base your
> > tree in Linus' tree (or some other *stable* tree).
>=20
> I've done making a correct tree.
> Could you please merge the following f2fs patches?
>=20
> 1. tree
> git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
>=20
> 2. branch
> dev
>=20
> 3. Contact
> Jaegeuk Kim <jaegeuk.kim@samsung.com>

OK, that looks much better.  Added from today.  In case you are not
aware, I will attempt to refetch that branch every morning before I start
merging the bits of linux-next together.  So any changes you make to that
branch should be reflected in the next linux-next release.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Tue__27_Nov_2012_09_48_18_+1100_TrvaaBoG6UW_SlpT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs/GyAAoJEECxmPOUX5FEy04P/RIy1RfCt2RI2fjhhDgfgQd+
JHzKrygZcAiBLTbjxQuf9/QbRMyonqF2UXJdkUqr2nZWJT/Z4+SJnvgv7R6IaSv6
vJ0saEusuGjZZbri68AopIKadEWBzwQoXpXV0TPnOtAoD+I2HE1sh9/miHEGHc26
mY40ABtqp+abeMe2s/oBYLee9E1G3S6vAig6g13kqqUSyKNxNMV4dfQMLoz1d1Bk
ZPZXhOEm/fJsqsCvqmd6whfXwbRZ16rTESCWw1QOH+TzJnnqP5zcTEwQ57i6p6lK
Iciu477IYy+p8zGjp3Aphkozn5ex1/x8NcvuX7gN6McJdI3G56/nWJ1jLA0bwjlu
TY+7Xd/vnwISUGZH/WkkP6zHx2Y8NSOwOXDU9OebmHyTnT9Y6S83pDIM3jilHi9O
2vUir6AfOXUfuMZ3Hmpo3YvItgq4pHoIqx0WnqTQjOdNjLHgWOXfTF5qVtBXaOkA
Sjk75BQHV1FhNXGf2Z7ArDWQbNoe/giH2iHAW8LxnXjrChSU8GLQZrKmekqvKR9B
YZ0hTuYmN2gt54RCKNSD5PaXuLkvcw6XxDIANQeZizrHGBQ6tBGJHZCaObPCXNEf
JM/rbDV8Hs5JCtpS0zUtm47kMrlNCtsoAF6D/iRHAeytvd0IEpxJRJWdsUfeMVwn
oLUUq9GiT/NJdp0x6YJf
=/Fws
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_09_48_18_+1100_TrvaaBoG6UW_SlpT--
