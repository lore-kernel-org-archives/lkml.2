Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0ESPVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:21:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42923 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0ESPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:21:31 -0400
Date: Thu, 20 May 2010 01:21:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Luca Barbieri <luca@luca-barbieri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
Message-Id: <20100520012124.ec269c14.sfr@canb.auug.org.au>
In-Reply-To: <4BF3FD4F.1060108@zytor.com>
References: <20100517224531.GA27400@elte.hu>
	<AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com>
	<4BF3F480.3000902@zytor.com>
	<20100520003641.00618acb.sfr@canb.auug.org.au>
	<4BF3FD4F.1060108@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_May_2010_01_21_24_+1000_r/.OcK5MWBW3DLxP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_May_2010_01_21_24_+1000_r/.OcK5MWBW3DLxP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 19 May 2010 08:01:35 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> It was discussed on linux-kernel -- note that there is no breakage for
> smaller architectures unless you enable the test directly or via randconf=
ig.

or allmodconfig or allyesconfig.

> The other part is that generic atomic64_t has been available since
> middle of 2009, and was *also* discussed extensively on linux-kernel --
> in fact, several of the smaller architectures added support at that
> time.  That the breakage occurred because of an inconsequential test
> rather than real code is thus really nothing but fortunate.

I don't disagree with any of that (except that an m68k allmodconfig build
may well build fine without the test being built so maybe building the
test needs a dependency).

My point was that I keep hearing the "Linus said it is OK to break the
other architectures" argument brought up where it really is not even
relevant to the conversation.  If anything, I guess Geert was taking a
little dig at me because his problem should have been noticed among my
build results. Unfortunately even I don't check all the build results all
the time (I guess I hope that maintainers may have time to check them out
once in a while).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_May_2010_01_21_24_+1000_r/.OcK5MWBW3DLxP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv0AfQACgkQjjKRsyhoI8xhqgCfYZ37Z6psZjaRpOxaPOEKXFo5
ov4An3N+Kz/RCQWnz8kD66ismTvchAgK
=V021
-----END PGP SIGNATURE-----

--Signature=_Thu__20_May_2010_01_21_24_+1000_r/.OcK5MWBW3DLxP--
