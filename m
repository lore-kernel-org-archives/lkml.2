Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0FICps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:45:48 -0400
Received: from u15218177.onlinehome-server.com ([74.208.220.233]:48130 "EHLO
	olra.theworths.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0FICpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:45:45 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2010 22:45:45 EDT
From: Carl Worth <cworth@cworth.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venki@google.com>,
       Jens Axboe <jaxboe@fusionio.com>, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       David =?utf-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
In-Reply-To: <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org>
User-Agent: Notmuch/0.3.1-54-g42e146a (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Tue, 08 Jun 2010 19:38:11 -0700
Message-ID: <87hbldhqwc.fsf@yoom.home.cworth.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Jun 2010 18:53:55 -0700 (PDT), Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
> And some of them do seem to be bisected to likely culprits and/or have=20
> patches that are claimed to have fixed them.
>=20
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16163
> > Subject	: [2.6.35-rc1 Regression] i915: Commit cfecde causes VGA to sta=
y off
> > Submitter	: David John <davidjon@xenontk.org>
> > Date		: 2010-06-02 12:52 (7 days old)
> > Message-ID	: <4C065423.3000202@xenontk.org>
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D127548313828613&w=
=3D2
>=20
> That has a "reverting the commit fixes it", and a confirmation from Nick=
=20
> Bowler.
>=20
> Eric, Carl: should I just revert that commit? Or do you have a fix?

I'm not aware of any real fix here. That commit isn't supposed to change
much, but it clearly unmasks some broken driver code.

So reverting it for now to hide the broken code from poor users does
seem a good plan to me, (unless Eric has any updates or alternate
suggestions).

=2DCarl

=2D-=20
carl.d.worth@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMDv6T6JDdNq8qSWgRAm2CAJ9p30+Roeli4N7Gv4rKjfxQKvMIOgCeOZfE
GPPsJXno4b3GCgHuFmrqKk8=
=2APO
-----END PGP SIGNATURE-----
--=-=-=--
