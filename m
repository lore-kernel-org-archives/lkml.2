Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0EMF7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:59:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52666 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab0EMF7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:59:44 -0400
Date: Thu, 13 May 2010 15:59:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the v4l-dvb tree
Message-Id: <20100513155939.c73f3747.sfr@canb.auug.org.au>
In-Reply-To: <4BEB8BA9.5070001@infradead.org>
References: <20100513130016.25b76c3f.sfr@canb.auug.org.au>
	<4BEB8BA9.5070001@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_May_2010_15_59_39_+1000_r=xAHjBByf4o./JO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_May_2010_15_59_39_+1000_r=xAHjBByf4o./JO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, 13 May 2010 02:18:33 -0300 Mauro Carvalho Chehab <mchehab@infradead=
.org> wrote:
>
> I'll be pulling from Linus on my tree. I did it yesterday, after my last =
changes,
> but it seems that I've made a huge mistake... Several conflicts that I've=
 already
> fixed reappeared. I suspect that I've merged it with an older temporary b=
ranch
> by mistake.

That explains it.

> Anyway, it is fixed, by simply going back to the last reflog before the e=
rror,
> and re-merging the new patches again. A pull from Linus didn't show any c=
onflict.
>=20
> So, it should be now OK for you to merge.

Excellent, thanks.

> > Please consider changing your work flow so that you don't rebase things
> > in your tree before sending them to Linus.
>=20
> I'm already in process of changing my procedure. The problem is that I di=
dn't find
> yet a perfect way to handle my tree. I'm getting some new ideas, and inte=
nd to implement
> them for 2.6.35 development cycle (linux-next for 2.6.36).

OK, good.  The process doesn't have to be perfect ... ;-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_May_2010_15_59_39_+1000_r=xAHjBByf4o./JO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvrlUsACgkQjjKRsyhoI8ymEgCeNrgoskK7HghN0x5AH0N4Ght8
HpcAoIHdREljHmDSOP3WXP7105G7ifFu
=5JVO
-----END PGP SIGNATURE-----

--Signature=_Thu__13_May_2010_15_59_39_+1000_r=xAHjBByf4o./JO--
