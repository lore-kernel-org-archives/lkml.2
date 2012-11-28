Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2K1U1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:27:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab2K1U1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:27:11 -0500
Date: Thu, 29 Nov 2012 07:26:46 +1100
From: NeilBrown <neilb@suse.de>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Hang in md-raid1 with 3.7-rcX
Message-ID: <20121129072646.0bcb3a2a@notabene.brown>
In-Reply-To: <32242311.8QXFMOUYz5@deuteros>
References: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
	<20121127120528.637099aa@notabene.brown>
	<32242311.8QXFMOUYz5@deuteros>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OjFi6ylrld+To.v.ezrmcb3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OjFi6ylrld+To.v.ezrmcb3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Nov 2012 14:51:59 +0000 Tvrtko Ursulin
<tvrtko.ursulin@onelan.co.uk> wrote:

> On Tuesday 27 November 2012 12:05:28 NeilBrown wrote:
> > On Sat, 24 Nov 2012 10:18:44 +0100 Torsten Kaiser
> >=20
> > <just.for.lkml@googlemail.com> wrote:
> > > After my system got stuck with 3.7.0-rc2 as reported in
> > > http://marc.info/?l=3Dlinux-kernel&m=3D135142236520624 LOCKDEP seem to
> > > blame XFS, because it found 2 possible deadlocks. But after these
> > > locking issues where fixed, my system got stuck again with 3.7.0-rc6
> > > as reported in http://marc.info/?l=3Dlinux-kernel&m=3D135344072325490
> > > Dave Chinner thinks its an issue within md, that it gets stuck and
> > > that will then prevent any further xfs activity, and that I should
> > > report it to the raid mailing list.
> > >=20
> > > The issue seems to be that multiple processes (kswapd0, xfsaild/md4
> > > and flush-9:4) get stuck in md_super_wait() like this:
> > > [<ffffffff816b1224>] schedule+0x24/0x60
> > > [<ffffffff814f9dad>] md_super_wait+0x4d/0x80
> > > [<ffffffff8105ca30>] ? __init_waitqueue_head+0x60/0x60
> > > [<ffffffff81500753>] bitmap_unplug+0x173/0x180
> > > [<ffffffff810b6acf>] ? write_cache_pages+0x12f/0x420
> > > [<ffffffff810b6700>] ? set_page_dirty_lock+0x60/0x60
> > > [<ffffffff814e8eb8>] raid1_unplug+0x98/0x110
> > > [<ffffffff81278a6d>] blk_flush_plug_list+0xad/0x240
> > > [<ffffffff81278c13>] blk_finish_plug+0x13/0x50
> > >=20
> > > The full hung-tasks stack traces and the output from SysRq+W can be
> > > found at http://marc.info/?l=3Dlinux-kernel&m=3D135344072325490 or in=
 the
> > > LKML thread 'Hang in XFS reclaim on 3.7.0-rc3'.
> >=20
> > Yes, it does look like an md bug....
> > Can you test to see if this fixes it?
>=20
> Hi,
>=20
> Would this bug be present in 3.6 as well? Because I am hitting something =
which=20
> looks pretty much like this with 3.6.x. In which case it should go to -st=
able,=20
> however I am not able to test on the affected machine at the moment.
>=20
> Regards,
>=20
> Tvrtko

Yes it is in 3.6, and it will go to -stable.

Thanks,
NeilBrown

--Sig_/OjFi6ylrld+To.v.ezrmcb3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULZzjjnsnt1WYoG5AQIpTA//T0Dd0hj/j/zk75HizpvuvKz7B0sDotGM
xe98GmXVFDARRGRCnxtjGaT7db42TAKJH3llEkgJLX33PkNDeGqUIdb5EAFueqvN
laow9CEyakrYvXFo9KZGaQ0l84IGzjbbyVQHGhumqTlgK48ML1AqIksjoC4vlNrH
7yS5w+7Bwf4C3flZJyJBn7p3hA1Bry3wknrW1Npb564TUeTxYVjdRp7xfexO8Lag
eSsKO1V9KBHgnTf0dSKBjDnzf2Oh2HCsUBNkNhZgBRoiAxIRRXcuMZa0Qkpsl0pm
6yzAnrBQGsUC79PzvEH2DEnjXHMqpWqquwdxRsg5VXnxv+l7Lwbh5yKkPUKAsSkW
tI82D7X+0CR+cy4LY/Bjvut7eAds7tYqfgo0qk84Qn0LCVHScFexEJnZ/0JLEAtb
PNdExCjZTN0wao0/71XW7QI9R+7T85QBOEBncDF7b/l4M8dSciDQxwZ2Td+irE2v
mviRjRdU5HV/FSrGkd+DXS/GHQ3dkGU/4hQ4Xg7+FY3aoqdD9731n5z/m3JHNrrj
+m5AFvlaaocJXzjQSZKH/XbcenxWPtsKr+s6wVnkDApZFV6iTToYhuZ51XFxPyGk
iPOgLJFJLGp+vMLF9maAdXBGcRPDst6G9kaSXEASDaaif0lmtBSJoHr0nKpOHIdN
Z/36/xq95k8=
=kpYX
-----END PGP SIGNATURE-----

--Sig_/OjFi6ylrld+To.v.ezrmcb3--
