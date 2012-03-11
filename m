Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2CKVqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:46:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2CKVp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:45:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.3-rc7: Reported regressions from 3.2
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WuYv90FoNpB.A.O8.ktRXPB@chimera>
Date: Sun, 11 Mar 2012 22:23:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 3.2,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 3.2, please let us
know either and we'll add them to the list.  Moreover, when you are
reporting a kernel regression, please send a CC of your report to the LKML
(or forward it to the LKML if you are not reporting the regression by e-mail)
with the word "regression" in the subject, as that will make it much
easier for us to find it.  Also, please let us know if any of the entries
below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2012-03-11       26       15          15
  2012-03-04       23       15          15
  2012-02-23       15       13          13


Unresolved regressions
----------------------

Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42907
Subject		: 3.3.0-rc5+git: WARNING: at drivers/gpu/drm/i915/i915_irq.c:652 ironlake_irq_handler+0x4ea/0x500()
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2012-03-05 23:59 (7 days old)
Message-ID	: <1330991976.9223.16.camel@no>
References	: http://marc.info/?l=linux-kernel&m=133099242810332&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42905
Subject		: sound regression in 3.2-rc3 (lenovo laptops)
Submitter	: Chris Mason <chris.mason@oracle.com>
Date		: 2012-03-05 21:11 (7 days old)
First-Bad-Commit: http://git.kernel.org/linus/29c5fbbcfefba5225a6783683c46c39e10877703
Message-ID	: <20120305211112.GA4191@shiny>
References	: http://marc.info/?l=linux-kernel&m=133098194106519&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42869
Subject		: [3.3-rc1 regression] [nouveau] Spurious TV-out detected
Submitter	: Andreas Schwab <schwab@linux-m68k.org>
Date		: 2012-03-05 14:21 (7 days old)


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42860
Subject		: 3.3.0-rc5: OOps in dql_completed (Broadcom tg3 driver)
Submitter	: Christoph Lameter <cl@gentwo.org>
Date		: 2012-03-01 21:13 (11 days old)
Message-ID	: <alpine.DEB.2.00.1203011505510.6685@router.home>
References	: http://marc.info/?l=linux-kernel&m=133063645224373&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42850
Subject		: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Submitter	: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Date		: 2012-02-24 10:53 (17 days old)
Message-ID	: <4F476959.2010400@linux.vnet.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=133008013332251&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42823
Subject		: WARNING: at block/genhd.c:1465
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2012-02-21 11:00 (20 days old)
Message-ID	: <alpine.DEB.2.01.1202210246400.4930@trent.utfs.org>
References	: http://marc.info/?l=linux-kernel&m=132982259213941&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42822
Subject		: [3.3.0-rc3][uvcvideo][regression] oops - uvc_video_clock_update
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2012-02-20 1:08 (21 days old)
Message-ID	: <5887142.ZMTDAjc4qf@segfault.sh0n.net>
References	: http://marc.info/?l=linux-kernel&m=132970057611642&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42821
Subject		: alpha: futex regression bisected
Submitter	: Michael Cree <mcree@orcon.net.nz>
Date		: 2012-02-20 8:20 (21 days old)
First-Bad-Commit: http://git.kernel.org/linus/8d7718aa082aaf30a0b4989e1f04858952f941bc
Message-ID	: <4F420256.2090600@orcon.net.nz>
References	: http://marc.info/?l=linux-kernel&m=132972606917069&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42776
Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2012-02-13 7:45 (28 days old)
Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2
		  http://marc.info/?l=linux-kernel&m=132993294018762&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42761
Subject		: Possible circular locking dependency (3.3-rc2)
Submitter	: Felipe Balbi <balbi@ti.com>
Date		: 2012-02-08 12:41 (33 days old)
Message-ID	: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
References	: http://marc.info/?l=linux-kernel&m=132870492311858&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42746
Subject		: 3.3-rc2 snd_pcm lockdep backtrace
Submitter	: Josh Boyer <jwboyer@redhat.com>
Date		: 2012-02-06 14:56 (35 days old)
Message-ID	: <20120206145621.GA4771@zod.bos.redhat.com>
References	: http://marc.info/?l=linux-kernel&m=132854040916172&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42733
Subject		: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET failed
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2012-02-02 5:12 (39 days old)
Message-ID	: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=132815978615112&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42713
Subject		: Regression in skge that started around acb42a3 (so past v3.3-rc1)
Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date		: 2012-01-30 15:58 (42 days old)
Message-ID	: <20120130155816.GA1400@phenom.dumpdata.com>
References	: http://marc.info/?l=linux-kernel&m=132793944220262&w=2
		  https://lkml.org/lkml/2012/2/6/486


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42686
Subject		: iwlagn is getting even worse with 3.3-rc1
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2012-01-24 1:36 (48 days old)
Message-ID	: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=132736918325378&w=2


Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42678
Subject		: [3.3-rc1] radeon stuck in kernel after lockup
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2012-01-21 19:03 (51 days old)
Message-ID	: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=132717279606670&w=2
Handled-By	: Jérôme Glisse <glisse@freedesktop.org>


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 3.2,
unresolved as well as resolved, at:

https://bugzilla.kernel.org/show_bug.cgi?id=42644

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

