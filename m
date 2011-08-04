Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1HDBe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:34:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47109 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab1HDBeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:34:20 -0400
Date: Thu, 4 Aug 2011 11:34:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] APEI patches for Linux 3.1
Message-Id: <20110804113411.87cb449bec31b15789175554@canb.auug.org.au>
In-Reply-To: <CAC=cRTMm8w-CQrj=GodPNxk=TbumuisLWzZh0i6x=x7_=C9ugg@mail.gmail.com>
References: <alpine.LFD.2.02.1108031137590.22067@x980>
	<CA+55aFxST2J+LDMB=1ctnw2WGxV+a-cm3FE-1AjwnXMNDkt32g@mail.gmail.com>
	<alpine.LFD.2.02.1108031523080.22067@x980>
	<CA+55aFxE6b=idv+fF5h1U3EnDqHSCK2b6+36sResmhJKvAZQ3A@mail.gmail.com>
	<CAC=cRTMm8w-CQrj=GodPNxk=TbumuisLWzZh0i6x=x7_=C9ugg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Aug_2011_11_34_11_+1000_YanQdPefrGMzDrlH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Aug_2011_11_34_11_+1000_YanQdPefrGMzDrlH
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Aug 2011 09:10:09 +0800 huang ying <huang.ying.caritas@gmail.com>=
 wrote:
>
> On Thu, Aug 4, 2011 at 8:52 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Aug 3, 2011 at 9:26 AM, Len Brown <lenb@kernel.org> wrote:
> >>
> >> Push went here:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git =
apei-release
> >
> > No it didn't.
> >
> > Apparently it went into linux-idle.
> >
> > Christ, Len. You send me *two* bogus pull requests, and all your pull
> > requests =C2=A0come in at the very end of the merge cycle, when I very
> > clearly asked people to try hard to avoid that since I'm supposed to
> > be on vacation.
> >
> > And several of those commits are from today, and cannot have had any te=
sting.
> >
> > In short: even though Tony told me where to look, I'm not seeing any
> > reason to pull this thing. The merge window is not for development,
> > and you're simply not making me get the warm and fuzzies about this
> > late pull request.
>=20
> Most APEI patches have been in
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git test
>=20
> since July 13th, and have been in linux-next since then.  I think Len
> just re-apply these patches in linux-idle tree.

The same sequence of commits appear in my acpi tree (the last 3 and the
origin merge since yesterday, the rest since July 16).

Linus, if you compare commit d7bdc8399c3c ("Merge branch 'apei' into
apei-release") from Len's acpi tree to the apei-release branch from the
idle tree, then you will see what I mean.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Aug_2011_11_34_11_+1000_YanQdPefrGMzDrlH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOfcTAAoJEDMEi1NhKgbswAYH/0Djq1Vkc6HLb8mBqR96eqhU
/bffw0Lr6c2p0E5MmAd6/T8Ln3Fp46T+/MBiMYNHhUjh3YOQH+B2nQjxhYfuQpFh
3LIwVtiftHWId4Z40noI261SX7A67QK5+8jjC6invXKGrV+P+2MwRaWOf/nrdAqU
4sKdNfuZucLr6RvT2PdU7Xsz1k+7FMPcYFr/e3sOcrPH2VxuLfqGTGquSWHGFLOi
WQ6TvGf4bdiNZXhn4lo1ljUHjIQ51BmeKPSlxS4RkJ6qeINdNPkHOnLBs7e2WHXN
E/ghn61zGl+M2UOQ6X+0xPAQQF9o7soJwKiZ/+le64bbtc9prubDpN5VsH56HiI=
=wCjm
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Aug_2011_11_34_11_+1000_YanQdPefrGMzDrlH--
