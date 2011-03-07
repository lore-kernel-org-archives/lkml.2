Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1CGLiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:38:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1CGLiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:38:16 -0500
Date: Mon, 7 Mar 2011 22:38:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20110307223807.10e8686c.sfr@canb.auug.org.au>
In-Reply-To: <4D74BE7C.4050701@kernel.dk>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
	<20110307063618.GA10365@mtj.dyndns.org>
	<4D749A81.50809@kernel.dk>
	<AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
	<20110307104747.GH20499@htj.dyndns.org>
	<AANLkTinBx5Z9Gp7ZTcbbTMCZZ4Z68-vMBP9yOX-k15EA@mail.gmail.com>
	<4D74BE7C.4050701@kernel.dk>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Mar_2011_22_38_07_+1100_h_EmHebMdyquW_Kh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Mar_2011_22_38_07_+1100_h_EmHebMdyquW_Kh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Mon, 07 Mar 2011 12:16:12 +0100 Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2011-03-07 12:14, Sedat Dilek wrote:
> > On 3/7/11, Tejun Heo <tj@kernel.org> wrote:
> >> On Mon, Mar 07, 2011 at 11:41:23AM +0100, Sedat Dilek wrote:
> >>> $ git log -1 | cat
> >>> commit c45165cd2c77843f24ca18af54044303dc2a81ab
> >>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> >>> Date:   Mon Mar 7 17:38:41 2011 +1100
> >>>
> >>>     Add linux-next specific files for 20110307
> >>>
> >>>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >>>
> >>> $ git pull
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.g=
it
> >>> for-next
> >>> remote: Counting objects: 158, done.
> >>> remote: Compressing objects: 100% (89/89), done.
> >>> remote: Total 106 (delta 87), reused 21 (delta 17)
> >>> Receiving objects: 100% (106/106), 23.33 KiB, done.
> >>> Resolving deltas: 100% (87/87), completed with 34 local objects.
> >>> From git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-bl=
ock
> >>>  * branch            for-next   -> FETCH_HEAD
> >>> warning: too many files (created: 1120 deleted: 637), skipping inexact
> >>> rename detection
> >>> warning: too many files (created: 974 deleted: 462), skipping inexact
> >>> rename detection
> >>> Auto-merging block/blk-core.c
> >>> Auto-merging block/blk-flush.c
> >>> CONFLICT (content): Merge conflict in block/blk-flush.c
> >>> Auto-merging block/cfq-iosched.c
> >>> CONFLICT (content): Merge conflict in block/cfq-iosched.c
> >>> Automatic merge failed; fix conflicts and then commit the result.
> >>
> >> Ummm... don't those conflicts come from Stephen's commits?  You would
> >> need to revert the merge and fixup commits and then pull in the block
> >> branch.
> >=20
> > I have reverted the merge-fix from Stephen "[PATCH] block: update for
> > __blk_run_queue() API update" which changed block/blk-flush.c, this
> > remains:
> > ...
> > CONFLICT (content): Merge conflict in block/cfq-iosched.c

This is a different conflict that git resolved on its own.

> > As it is 12p.m. and sun shining, my decision and direction is clear:
> > Lunch + City.
>=20
> Just checked here, I can pull my for-next cleanly into Linus' master.
> What is the block tree for-next branch sha?

This the correct test, trying to remerge a tree into linux-next is bound
to have some conflicts.

I will let you know tomorrow, but I expect no problems.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Mar_2011_22_38_07_+1100_h_EmHebMdyquW_Kh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNdMOfAAoJEDMEi1NhKgbseUMH/A+pLMQd5lItGZMwq3+CrfW6
qs9MpKu/8HSZpNhfRyqltlub/2sCt6jXm6qw/2XWnzoc27EZ5v+fwXTS6eWiDt9P
LtiCkAzcn6WYbJWIBQTmQvAp2xL4+hMDcfpJoMNh/q7NV7B1xs66cablOvzg2vSc
ICmbUnxQoPdn7afZ6IYzIuwe3jQ1fzNA8GCf3FqQqRnxMHKhlHgumszqek2e4Myt
2T9sOEoVh09vwlKb5OxIy7QCD8phgMsRUHwJ/bgSilzvW6kNTNOrDx4agdf5MR3O
opmlQiEhw2O3XpUAHTKEKKyQk1gzuYNTDUvQtzkKQ83wSg8vfW6BzessVxmc1NU=
=WNe4
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Mar_2011_22_38_07_+1100_h_EmHebMdyquW_Kh--
