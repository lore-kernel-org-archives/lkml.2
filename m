Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2HPGru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:47:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2HPGrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:47:49 -0400
Date: Thu, 16 Aug 2012 16:47:35 +1000
From: NeilBrown <neilb@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2.6.34-stable 035/165] md: Fix handling for devices from 2TB
 to 4TB in 0.90 metadata.
Message-ID: <20120816164735.6a0cdef0@notabene.brown>
In-Reply-To: <1345091073.824.244.camel@deadeye.wl.decadent.org.uk>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
	<1345060109-9187-36-git-send-email-paul.gortmaker@windriver.com>
	<20120816064631.61c7026d@notabene.brown>
	<1345091073.824.244.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TkPrAIys79JfLSLhFP74Fyl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TkPrAIys79JfLSLhFP74Fyl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Aug 2012 05:24:33 +0100 Ben Hutchings <ben@decadent.org.uk> wrot=
e:

> On Thu, 2012-08-16 at 06:46 +1000, NeilBrown wrote:
> > On Wed, 15 Aug 2012 15:46:19 -0400 Paul Gortmaker
> > <paul.gortmaker@windriver.com> wrote:
> >=20
> > > From: NeilBrown <neilb@suse.de>
> > >=20
> > >                    -------------------
> > >     This is a commit scheduled for the next v2.6.34 longterm release.
> > >     http://git.kernel.org/?p=3Dlinux/kernel/git/paulg/longterm-queue-=
2.6.34.git
> > >     If you see a problem with using this for longterm, please comment.
> >=20
> > This patch fixes one problem but unfortunately introduces another.
> > The patch for that 'other' should get sent to linus in the next day or =
so
> > after it has had a chance to sit in -next for a bit.
> >=20
> > It can be found at:
> >  http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D30b798a352052b07c=
924956dda4ce720b00af711
> >=20
> > you could either add that patch, or drop this patch until the next cycl=
e.
> [...]
>=20
> This was already backported to 2.6.32, 2.6.33 and 3.0.  So please change
> the last sentence of the commit message for your following fix; it will
> be needed for all active stable series.
>

I had been wondering about that.  You've convinced me.  It now reads:

    This bug was introduced in 3.1 and is suitable for any stable kernels
    from then onwards.
    As the offending commit was tagged for 'stable', any stable kernel
    that it was applied to should also get this patch.  That includes
    at least 2.6.32, 2.6.33 and 3.0. (Thanks to Ben Hutchings for
    providing that list).

Thanks,
NeilBrown


--Sig_/TkPrAIys79JfLSLhFP74Fyl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCyXhznsnt1WYoG5AQKdlA/+KsoBFVGo3l8zb50Z5dPuudLDnGfJUY/S
3ZXwhwq5od0IArJvMwMcnEaxY1+UBUyuhgzpW4k1w02/LwTULzVAYZdjbS1EMwRd
WvjEAqwc0v8JqC4OG44yabfPpgcSQ01waVd0xIy+wB9m8mFd2yVJNfVGZAvNby0U
3gfhzfLyxhQhu1z5uIOrdp3FVPP30QummthY+q/99FZCQN1DVrN4K9t9RbCKIbv2
f1JxAcFO02lAJbJo7R8KNO47+7XcuUZscXOVohEjoHUaVGEl+p6dJEt7tdSw2S0M
TBPNk5DfwQn98lk15n2pwIaUmLH8V4WKaSdShYuevyo2zRYZorpjC/sS0kjWLZE0
NPwDzT6Uyn7epZyLZYR/o7m6HH9c1oNuo+p4SXxuuVN59uM7kGB9J5v7fUj2tZmG
lPZyLlCHGor6YoYvSR4FKhuyGieVUgTP4AHUq7K0saujx9tEGXfAc8PiTfB9XsdG
xl9e0ry+RJtLPBOj6pbBsdxoTdsFylUSwBYhTONvUvtB18QmTjLL4q9ut1zT4EsQ
/KbstOJL0IO82L6SxfbPyd5sZB+AmpK+wHqWe1JdBNGptbWBlzKywNQ2j//JAChe
Lw76ZZxtyQ5PSyn+eE7Qan/BUkKHxkQ+OvAlk5FWUIIb5IQN3Awy3hygDPREB5QP
fK1DbtgodVo=
=yjep
-----END PGP SIGNATURE-----

--Sig_/TkPrAIys79JfLSLhFP74Fyl--
