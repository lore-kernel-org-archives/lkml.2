Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2GZHDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:03:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33497 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2GZHDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:03:21 -0400
Date: Thu, 26 Jul 2012 17:03:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120726170308.1e18a9980baf8d5a62c1a95a@canb.auug.org.au>
In-Reply-To: <20120725073503.GB1112@cmpxchg.org>
References: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
	<20120725071044.GA27535@gmail.com>
	<20120725073503.GB1112@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__26_Jul_2012_17_03_08_+1000_eI3HPrKJPLCIOfvS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Jul_2012_17_03_08_+1000_eI3HPrKJPLCIOfvS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 25 Jul 2012 09:35:03 +0200 Johannes Weiner <hannes@cmpxchg.org> wro=
te:
>
> On Wed, Jul 25, 2012 at 09:10:44AM +0200, Ingo Molnar wrote:
> >=20
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > > Today's linux-next merge of the akpm tree got a conflict in=20
> > > mm/migrate.c between the tip tree and commit "mm: memcg: fix=20
> > > compaction/migration failing due to memcg limits" from the=20
> > > akpm tree.
> > >=20
> > > The commit 4783af477d3d ("mm: Migrate misplaced page") was=20
> > > removed (among several others) from the tip tree since=20
> > > yesterday (and thus linux-next) so the above akpm tree patch=20
> > > no longer applies.
> > >=20
> > > I have dropped this patch form the akpm tree (and the following patch=
es
> > > as well:
> > > mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpa=
tch-fixes
> > > mm: memcg: push down PageSwapCache check into uncharge entry functions
> > > mm: memcg: only check for PageSwapCache when uncharging anon
> > > mm: memcg: remove unneeded shmem charge type
> > > mm: memcg: remove needless !mm fixup to init_mm when charging
> > > )
> > >=20
> > > Hopefully this doesn't cause other problems.  I guess that=20
> > > they will need rebasing depending on what gets merged via the=20
> > > tip tree.
> >=20
> > Andrew, sorry about this last minute fallout: I felt that=20
> > sched/numa was still not fully cooked and did not want to hold=20
> > up the rest of the scheduler tree on that - nor did I want to=20
> > send an uncooked tree to Linus.
> >=20
> > PeterZ posted another series of sched/numa patches two days ago=20
> > - once that is ready (probably after the merge window) it will=20
> > all reappear again, in a slightly different form. I could stick=20
> > the mm/ bits into a separate tree to make it easier for you.
>=20
> As this is unlikely to reappear in this merge window, the conflict
> resolution is quite simple.  All that's needed is remove the 3 hunks
> from my patch that converted a user in Peter's patch to a new API.  I
> can resend the series if needed, but it's probably easier to just
> remove the hunks against mm/migrate.c::migrate_misplaced_page():

OK, so I have readded those patches to linux-next today with the
appropriate hunks removed.  Except for
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fi=
xes
which only touched the part of the file that no longer exists.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__26_Jul_2012_17_03_08_+1000_eI3HPrKJPLCIOfvS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQEOusAAoJEECxmPOUX5FEfnsP/2TnHCvHR8+xrZ9kSI+35WQ1
RDDmOFhEHb6cLPERAnRkDuM1RaJ74dqMrl9ozoXLzsvpKxN+uiozFqIikL5X1ua/
Q1vpeUhGf/+YNPtYtCXTII9La2baNppcDOFPygiZRxX1/j8XsmzaVf4HjL2878Em
H00nxajJrAgGK1ufsRvonWnq5e02j1gE77LnXnyYHbyuXFKLixRn62PIh/RlC0de
jLD9ohnKp1VaYzeqPXaVIZCmMzfYeVeEntVHb5kL52F+20Ns4RPTReQH6igFlp5+
A4XRp6O4Obi2tazex/G8bH5ZNm0gnSJYAPp39G+fzYUNfh8dQROlAo517DaN2vbV
fpyisgM/bMTVfthhlZpaRVk92s/X42FHH4QArqniiFdBbrWoFpRNurPAk4vxIVFH
4s9xEOz840J11fCr7IN3UcOwvayPls+UWdxHOzKBpzXWXzXPgxoWP+txnWIp7XbE
OntDIuEYUdHkAJpD/dI9JqVK16VF7OUyOht9jOQDsmintE7f0XnLvWQ6cmgCAF95
pfN59vRP754sdDcOGzFrTszwTactbHpEIwNgxIGsnjJRI304kT95/3vrGg6L+7et
uvzJVEyDImDKDVGyHD2ZRWEUgQER+qOUkHgafvZsbp+byvdAGoxy/Bzsyrihw7BK
NN135kXtMeXVaM/9JTe1
=S8y7
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Jul_2012_17_03_08_+1000_eI3HPrKJPLCIOfvS--
