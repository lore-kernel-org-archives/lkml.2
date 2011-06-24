Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1FXGKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:10:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56055 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761381Ab1FXGKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:10:37 -0400
Date: Fri, 24 Jun 2011 16:10:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-Id: <20110624161029.e8f96175.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTimoWrwPNNYrLFN-_gyPnvSCEa9ksA@mail.gmail.com>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
	<20110618183029.822f4d82.sfr@canb.auug.org.au>
	<20110623212736.74bea79a.sfr@canb.auug.org.au>
	<BANLkTimoWrwPNNYrLFN-_gyPnvSCEa9ksA@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jun_2011_16_10_29_+1000_R+vMMgLengO_G_fu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jun_2011_16_10_29_+1000_R+vMMgLengO_G_fu
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Fri, 24 Jun 2011 08:08:06 +0200 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> > I also made the mistake of fixing things so that the automatic "git
> > bisect for build failures" would work. =C2=A0That was taking much too m=
uch
> > time (over 4 hours for one build), so I have turned it off. =C2=A0Hopef=
ully,
> > the builds will now run in a more reasonable time frame.
>=20
> Yeah, I noticed it. There are still no results for 3.0-rc4...

3.0-rc4 should be complete in a few hours.  Hopefully rc5 will be faster.

> Probably you should only bisect for configs that where "green" recently.
> And hope people fix reported regressions the-next-day-as-we-speak :-)

Well, I will leave that for the author :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Jun_2011_16_10_29_+1000_R+vMMgLengO_G_fu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOBCpVAAoJEDMEi1NhKgbsOWUH/ikMeyBq+a/qipkPPb9xlg4M
kHePFopNPJrXBsYARsBROeSZRZpt21W7Jor6J1Hjwa/Yt5KVa2v42KDLaAJ6Ixxn
WxYgcu08rxTkUAZNdJPivMgxHGFUp05gh+0mT5KcZOemRzT/jIBdHDS22cOQfj/r
fT5S7eBFp3kX6fqYUCgM6/PSQCKszd/rTb3L/pQSIe90BNXs/3Ci4OWacCC+leBR
jlt9/DOjzYiwOEQ6iIy9fxJdQ6YdE7YmhenVjguan08iK5xBRIA+8jh6G+QZSm0E
kvm0lMPOov8O9LFQxsNI3ajpRZLznwPVyf4MLQDUDmA2Hpzb/3uX0fGLwwnJ02I=
=efV9
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jun_2011_16_10_29_+1000_R+vMMgLengO_G_fu--
