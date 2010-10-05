Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0JEGpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:45:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42737 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0JEGpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:45:34 -0400
Date: Tue, 5 Oct 2010 17:45:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
Message-Id: <20101005174524.b62d14a1.sfr@canb.auug.org.au>
In-Reply-To: <20101005063227.GB12267@elte.hu>
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
	<4CAABC0E.3030700@kernel.org>
	<20101005063227.GB12267@elte.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Oct_2010_17_45_24_+1100_rLbheQ532LyJXZk5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Oct_2010_17_45_24_+1100_rLbheQ532LyJXZk5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 5 Oct 2010 08:32:27 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> Please send irq merge requests to Thomas instead and wait for those=20
> genirq bits to show up upstream. (You did so in the past and the review=20
> process was ongoing AFAICS)
>=20
> Otherwise we would be dilluting linux-next testing with random side=20
> effects from a tree that wasnt yet (in that form) scheduled to go=20
> upstream by its respective maintainer at that time.
>=20
> We were lucky that this showed up as merge complications - what if=20
> instead it merged 'fine' on the textual and build/boot level but=20
> mis-merged on the functional level in subtle ways? Thomas would be=20
> sending something to Linus that was never really tested in linux-next in=
=20
> that form, caused problems upstream, and Linus would be rightfully upset=
=20
> about the situation.
>=20
> Stephen, you need to enforce such things ...

At the time that this tree was added to linux-next (in July), I responded
to Tejun like this:

------------------------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, Thomas Gleix=
ner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hp=
a@zytor.com>, Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vge=
r.kernel.org>
Subject: Re: linux-next: please pull in from lost-spurious-irq branch
Date: Thu, 29 Jul 2010 01:35:09 +1000

Hi Tejun,

On Wed, 28 Jul 2010 15:50:55 +0200 Tejun Heo <tj@kernel.org> wrote:
>
> If possible, can you please pull the following branch into linux-next?
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious=
-irq
>=20
> It's scheduled to go through tip/genirq, so once it shows up in tip,
> the above branch can be dropped from linux-next.  As the merge window
> is closing in, I'm hoping to get it tested enough in linux-next.  The
> branch is based on rc3 but merges without conflict into the current
> mainline.

OK, added from today.  I'll keep an eye out for it in the tip tree.

------------------------------------------------------------------------

Not sure what I can do beyond making sure that all relevant people are
informed about what trees are being merged.  There is a certain amount of
good faith involved in all our development processes.

In any case, it will be dropped tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Oct_2010_17_45_24_+1100_rLbheQ532LyJXZk5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMqsmEAAoJEDMEi1NhKgbsM/oH/3Rzd1MxvaeVVf+gKkwt1gO1
c9UszT8172QLlOmjJdViNlAga+EWUEflWcoJVTMsWvwDM1qGsg4xDpY6tnOxBIop
eN4qhhmApOvzE6dXS3OIOojBsAbcWVlAJU+qL/gObmhAOMtYV2E12Ma+T1Cjae36
ZqYW1u6I8WLs1U9EnrV5Jxi9bFd4/mqdHIvCkWhu/xTK0M9CkWodlaThPC544E3+
kEr3PxxgPZbVtzUwysMDf5N8FViotuzolEUBSR4ka4lyFV7uEjXufwUR6IxkQB8u
kC7lQt27CP+gPmy5/DfyeMRFvVBti2k6dTGg/dsqxobZrBx5lhtF/iVxHisHnSQ=
=fiIN
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Oct_2010_17_45_24_+1100_rLbheQ532LyJXZk5--
