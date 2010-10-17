Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0JQUTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:19:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692Ab0JQUT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:19:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc8-git3: Reported regressions from 2.6.35
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
Message-ID: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
Date: Sun, 17 Oct 2010 22:15:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.35,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.35, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-10-17       70       27          27
  2010-10-10       56       16          15
  2010-10-03       52       16          14
  2010-09-26       46       15          13
  2010-09-20       38       15          15
  2010-09-12       28       14          13
  2010-08-30       21       16          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20472
Subject		: [2.6.35.5 -> .7] INFO: task rpcbind:14163 blocked for more than 120 seconds.
Submitter	: Pawel Sikora <pluto@agmk.net>
Date		: 2010-10-15 15:02 (3 days old)
Message-ID	: <201010151702.15675.pluto@agmk.net>
References	: http://marc.info/?l=linux-kernel&m=128715683507549&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20462
Subject		: 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
Submitter	: Nikola Ciprich <extmaillist@linuxbox.cz>
Date		: 2010-10-15 7:10 (3 days old)
Message-ID	: <20101015071008.GA8714@pcnci.linuxbox.cz>
References	: http://marc.info/?l=linux-kernel&m=128712984831303&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20352
Subject		: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2010-10-13 11:28 (5 days old)
First-Bad-Commit: http://git.kernel.org/linus/365b18189789bfa1acd9939e6312b8a4b4577b28
Message-ID	: <201010131328.06465.toralf.foerster@gmx.de>
References	: http://marc.info/?l=linux-kernel&m=128696930132503&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20342
Subject		: [LogFS] [2.6.36-rc7] Deadlock in logfs_get_wblocks, hold and wait on same lock super->s_write_mutex
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2010-10-13 9:49 (5 days old)
Message-ID	: <AANLkTinvsMxTxEbDEFmb5M-6fYjdRvErU==Zs7+qANkV@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128696335024718&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20332
Subject		: [LogFS] [2.6.36-rc7] Kernel BUG at lib/btree.c:465!
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2010-10-12 18:56 (6 days old)
Message-ID	: <AANLkTimAbCZNhLQ5nADUiAC+7JpAeJBEmjFwdxyZ-FxO@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128690910501830&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20322
Subject		: 2.6.36-rc7: inconsistent lock state: inconsistent {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2010-10-11 20:10 (7 days old)
Message-ID	: <20101011201007.GA29707@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=128682782828453&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20232
Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
Submitter	: Ozan Caglayan <ozan@pardus.org.tr>
Date		: 2010-10-13 06:13 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20182
Subject		: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
Submitter	: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date		: 2010-10-11 20:56 (7 days old)
Message-ID	: <tkrat.9f585ea47331a2a2@s5r6.in-berlin.de>
References	: http://marc.info/?l=linux-kernel&m=128683064431749&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20172
Subject		: Lenovo S12 2.6.36-rc7 lockup
Submitter	: Chris Vine <chris@cvine.freeserve.co.uk>
Date		: 2010-10-10 12:59 (8 days old)
Message-ID	: <20101010135912.76eb61b7@boulder.homenet>
References	: http://marc.info/?l=linux-kernel&m=128671620721712&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20162
Subject		: [LogFS][2.6.36.rc7+] Kernel BUG at readwrite.c:1193
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2010-10-10 17:44 (8 days old)
Message-ID	: <AANLkTi=JkcuWBPo+X-i+9o-BJFVqjea1J3e=Mr=HvAWF@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128673196203340&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20032
Subject		: 2.6.36-rc7 continuos kernel panics due to of cpu_idle (and cpu_intel_idle)
Submitter	: Patrizio Bassi <patrizio.bassi@gmail.com>
Date		: 2010-10-08 18:23 (10 days old)
Message-ID	: <AANLkTi=2irM5tM2rNC5wHVV=Nw4cs_CK59pvXDD+Y5Dz@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128656222919323&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20022
Subject		: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Submitter	: Dave Airlie <airlied@gmail.com>
Date		: 2010-10-07 8:55 (11 days old)
Message-ID	: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128644173420501&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19862
Subject		: [REGRESSION] no sound on T60 laptop (HDA Intel)
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2010-10-05 9:25 (13 days old)
Message-ID	: <E1P33mT-0003qa-Fv@pomaz-ex.szeredi.hu>
References	: http://marc.info/?l=linux-kernel&m=128627079921512&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19802
Subject		: [drm:init_ring_common] *ERROR* render ring head not reset to zero
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-10-04 20:31 (14 days old)
Message-ID	: <201010042231.20320.thomas@m3y3r.de>
References	: http://marc.info/?l=linux-kernel&m=128622441331199&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19782
Subject		: 2.6.36-rc6-git2 -- BUG dentry: Poison overwritten (after resume from hibernation)
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-10-03 3:54 (15 days old)
Message-ID	: <AANLkTimrqtzBHAZSuDhEs_3CKA6pCbM35b1BtKH=MvC_@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128607809314079&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19632
Subject		: 2.6.36-rc6: modprobe Not tainted warning
Submitter	: Heinz Diehl <htd@fritha.org>
Date		: 2010-09-30 18:25 (18 days old)
Message-ID	: <20100930182516.GA15089@fritha.org>
References	: http://marc.info/?l=linux-kernel&m=128587114004680&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19392
Subject		: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2010-09-28 22:30 (20 days old)
Message-ID	: <AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19372
Subject		: 2.6.36-rc6: WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:235 radeon_fence_wait+0x35a/0x3c0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2010-09-29 21:29 (19 days old)
Message-ID	: <20100929212923.GA5578@core2.telecom.by>
References	: http://marc.info/?l=linux-kernel&m=128579579400315&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19142
Subject		: Screen flickers when switching from the console to X
Submitter	: Andrey Rahmatullin <wrar@altlinux.org>
Date		: 2010-09-27 12:05 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19072
Subject		: [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2010-09-23 17:02 (25 days old)
Message-ID	: <<19611.34846.813757.309183@pilspetsen.it.uu.se>>
References	: http://marc.info/?l=linux-kernel&m=128526136531048&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19052
Subject		: 2.6.36-rc5-git1 -- [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-09-22 23:47 (26 days old)
Message-ID	: <AANLkTikWQjUQjFJU9MO1+XbSLAEE-GARz+S+Dz2Fgu4h@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128519926626322&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19002
Subject		: Radeon rv730 AGP/KMS/DRM kernel lockup
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2010-09-23 16:48 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17361
Subject		: Random kmemcheck errors and kernel freeze on 2.6.36-rc*
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-08-29 19:59 (50 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17121
Subject		: Two blank rectangles more than 10 cm long when booting
Submitter	: Eric Valette <eric.valette@free.fr>
Date		: 2010-08-26 17:24 (53 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17061
Subject		: 2.6.36-rc1 on zaurus: bluetooth regression
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-08-21 15:24 (58 days old)
Message-ID	: <20100821152445.GA1536@ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=128240433828087&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2010-08-19 21:03 (60 days old)
Message-ID	: <<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>
References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16951
Subject		: hackbench regression with 2.6.36-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2010-08-18 6:18 (61 days old)
Message-ID	: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=128211235904910&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.35,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=16444

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

