Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0ESOgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:36:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56658 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0ESOgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:36:51 -0400
Date: Thu, 20 May 2010 00:36:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Luca Barbieri <luca@luca-barbieri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
Message-Id: <20100520003641.00618acb.sfr@canb.auug.org.au>
In-Reply-To: <4BF3F480.3000902@zytor.com>
References: <20100517224531.GA27400@elte.hu>
	<AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com>
	<4BF3F480.3000902@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_May_2010_00_36_41_+1000_5fnWl/5VCSgBoC7I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_May_2010_00_36_41_+1000_5fnWl/5VCSgBoC7I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 19 May 2010 07:24:00 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 05/19/2010 04:46 AM, Geert Uytterhoeven wrote:
> > <boilerplate>
> > It's a pity this wasn't raised/resolved between its detection in linux-=
next and
> > before it entered mainline...
> > </boilerplate>
>=20
> As far as your boilerplate is concerned, I think Linus made it clear at
> the Kernel Summit that is it not the obligation of x86/ARM/PowerPC to
> slow down to not break the smaller architectures; it's the
> responsibility of those architecture maintainers to keep up.  Sorry.

I don't think this reply has anything to do with the sentiments expressed
by Geert above.  My interpretation of his comments is just that it is a
pity noone noticed the problem while it was only in linux-next and
reported it widely (like on linux-arch) so something could have been done
before it all Linus' tree.  There was no suggestion of slowing the pace
of development.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_May_2010_00_36_41_+1000_5fnWl/5VCSgBoC7I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvz93kACgkQjjKRsyhoI8yO1ACgts31lG2qBEm6WOdIPCAX0avs
OYsAn224XYvw/hsM3NTgSpORRELF/bn4
=hzth
-----END PGP SIGNATURE-----

--Signature=_Thu__20_May_2010_00_36_41_+1000_5fnWl/5VCSgBoC7I--
