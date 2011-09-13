Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1IMLMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:12:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46699 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1IMLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:12:05 -0400
Date: Tue, 13 Sep 2011 21:11:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20110913211154.fe53ca8c1d608def77a69022@canb.auug.org.au>
In-Reply-To: <20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au>
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au>
	<4E5690C3.2050706@goop.org>
	<4E5693DD.2010307@zytor.com>
	<20110826090619.7588d424798f53a6f3621eb2@canb.auug.org.au>
	<4E56D6E1.6030405@zytor.com>
	<20110826125441.709aa423cdf072ce085fb91c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Sep_2011_21_11_54_+1000_SXNVjjU1Z9dcqLFp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Sep_2011_21_11_54_+1000_SXNVjjU1Z9dcqLFp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 26 Aug 2011 12:54:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 25 Aug 2011 16:12:33 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> > On 08/25/2011 04:06 PM, Stephen Rothwell wrote:
> > >>
> > >> Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
> > >> should be dropped.
> > >=20
> > > That's a bit tricky as I get a rolled up tip tree.  The best I could =
do
> > > is revert the commit that merges the x86/spinlocks branch into
> > > auto-latest ...  I'll do that for today (unless something happens to =
the
> > > tip tree in the next hour).
> > >=20
> >=20
> > OK, let me bother Ingo about it.
>=20
> For today, I have done "git revert -m 1 6f8fa39c81f1" after merging the
> tip tree.

I am still doing this in each linux-next, and it doesn't appear to have
been fixed up the the tree on tesla.tglx.de, yet, I think.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Sep_2011_21_11_54_+1000_SXNVjjU1Z9dcqLFp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJObzp6AAoJEDMEi1NhKgbsM0sH/j3HijOarIxiI5SiFbEOXd0w
/ca84Jd+zy69PVuwMUgna3Q6p31bgt28+URzvcdslvX7Ev9gJHyZsW+bLnAvlyci
BAB1+XVFiYDoRTirUTQ7GGpIqSQ2XQkj0lFXnjr284mpi6Xy0a6JQXtCUVcu58GR
Z/M4PgiCf5wdFLKDT/jrJ48B5XDR/nSfff8RX0CZKPXctqt4VmP5XrBVjBXGYwom
db8XWffLGDfBpC3NaSmSBioLcZguI1BJO6/ONhveVUIpy1m52SDtz2e1si7KvmFt
zxnHL+xVOyr/gsXmRODwXp+TqGM7MbB9PoDTEcZRp6Wd3q2ww4YmqIYtM4dYMq8=
=V0pR
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Sep_2011_21_11_54_+1000_SXNVjjU1Z9dcqLFp--
