Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1FRIav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:30:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39178 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1FRIaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:30:39 -0400
Date: Sat, 18 Jun 2011 18:30:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-Id: <20110618183029.822f4d82.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__18_Jun_2011_18_30_29_+1000_fpSBzABPWJTUAyT7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__18_Jun_2011_18_30_29_+1000_fpSBzABPWJTUAyT7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Wed, 15 Jun 2011 11:19:48 +0200 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> Would it be possible to build with `make -k', so it continues in case
> of an error, and
> tries to build as much as possible?
> Yes, I know this may increase build time considerably, but in an ideal
> world, there
> are no compile errors and everything is built anyway ;-)

Done (I think - it required very simple changes to a Python script and I
only do "monkey see, monkey do" Python programming :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__18_Jun_2011_18_30_29_+1000_fpSBzABPWJTUAyT7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/GIlAAoJEDMEi1NhKgbsOM4IAKMzG0Wk4Jes83BIZsOTzQj/
NJjIGuU+Xy7pQoQ7oR2ftUxSnG681Lilad7o2rNMmEMr7AcetGkztqivT5TK1cg+
whxq7TdvzcquUz+MAAQ1hmtv6wTQAibQUAA9VnWHLMujHwCLQL3XnoOSy8JcxoB1
jl2OrnVT4l2w2Ka/eUPlms0+O+DNR7DbuY+I9gL8rHZRiQZFGcjRXPzPNcommWa1
jyLZ2kyIX3AFI2mbL6FlPsfytGelfM1klTB4F8Q6wvawWZNIiLTDs+tugtQofRiK
ADTL2nLckUZIREErDr0+FTb4+Zz82NOI/S1MkSFVXskEOhq/KAlDGGeHOhknlus=
=OVLi
-----END PGP SIGNATURE-----

--Signature=_Sat__18_Jun_2011_18_30_29_+1000_fpSBzABPWJTUAyT7--
