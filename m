Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664Ab0JIXv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:51:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40962 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab0JIXv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:51:28 -0400
Date: Sun, 10 Oct 2010 10:51:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken on
 SGI UV
Message-Id: <20101010105121.9ebb64aa.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
	<AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_Oct_2010_10_51_21_+1100_4zc9hc=EDO=A2qSF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__10_Oct_2010_10_51_21_+1100_4zc9hc=EDO=A2qSF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 9 Oct 2010 16:24:59 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> Quite frankly, if somebody has something in "next" (and really meant
> for the _next_ merge window, not the current one) that is marked for
> stable, I think that shows uncommonly bad taste. And that, in turn,
> means that the "stable" tag is also very debatable. It clearly cannot
> be important enough to really be for stable if it's not even being
> aggressively pushed into the current -rc.

There are 22 trees that get merged into in linux-next that are "bug fixes
for the current release" trees ... that was the list I sent you after the
-rc7 announcement (most of which I think you have since merged.  In
fact, there are currently only 5 commits in those 22 trees that you have
not merged.

The other thing people do is to add such bug fixes to their -next trees
before asking you to take them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__10_Oct_2010_10_51_21_+1100_4zc9hc=EDO=A2qSF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMsP/5AAoJEDMEi1NhKgbsYtgH/3nz6cTuY7rfvQlQgBrnCVfz
OErBBj0wlSSlVwCVVAel+rNuam07wSShmb8A/YbDnx0fTbx4okwtV4Fw5tb+bf9N
JuisnVjZaky+x7MxOsKScywtbSuOmzmCE0wPLm9AK8RFBjFUAyGPbRsphWJruLyh
QozmzzXD7tFh3j3VHtP7D1RoRTRYUpX5qBZ/HnvKfCZoCXdEueJ7Z5nP5o5/PRYI
oIDgBC6C/EAXUIrFzLeiRGzRtwMzCaJjy1JgnfobM8iEfSj6RbqlX8L9fIsx/OFq
CxPxcFRNbSVfz19ZFJuE33xVRAKDb+YmmgZ9Ied5aU1DHiubLbJbqyf0sQafgSE=
=74zp
-----END PGP SIGNATURE-----

--Signature=_Sun__10_Oct_2010_10_51_21_+1100_4zc9hc=EDO=A2qSF--
