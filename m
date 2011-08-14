Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1HNTkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:40:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1HNTka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:40:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.1-rc1-git9: Reported regressions 2.6.39 -> 3.0
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
Message-ID: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
Date: Sun, 14 Aug 2011 21:02:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE:
 We already have a bug entry for tracking regressions from 3.0:

 http://bugzilla.kernel.org/show_bug.cgi?id=40982

 but there are no reports linked to it, mostly because Maciej is on vacation,
 but also because the frequency of reporting regressions has been low
 recently.  So, if you're seeing a regression from 3.0, please let us know.]

This message contains a list of some post-2.6.39 regressions introduced before
3.0, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-2.6.39 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-08-14       63       22          19


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40282
Subject		: IP forwarding regression since 3.0-rc6
Submitter	: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Date		: 2011-07-25 12:51 (21 days old)
Message-ID	: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
References	: http://marc.info/?l=linux-kernel&m=131159880004908&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40172
Subject		: lockdep trace from post 3.0.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2011-07-24 1:32 (22 days old)
Message-ID	: <20110724013257.GA6777@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=131147120206819&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40092
Subject		: RCU stall in linux-3.0.0
Submitter	: Philip Armstrong <phil@kantaka.co.uk>
Date		: 2011-07-25 21:44 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40072
Subject		: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400, unless iwlagn unloaded
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2011-07-23 19:27 (23 days old)
Message-ID	: <201107232127.34255.toralf.foerster@gmx.de>
References	: http://marc.info/?l=linux-kernel&m=131144928023465&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39972
Subject		: [regression] Radeon multi-screen
Submitter	: Robert Piasek <dagger@gentoo.org>
Date		: 2011-07-25 14:04 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39922
Subject		: WIFI becomes EXTREMELY slow ( ath9k ) making the connection unusable
Submitter	: Lukasz Olszewski <lcpak@epoczta.pl>
Date		: 2011-07-24 09:20 (22 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39912
Subject		: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2011-07-19 11:33 (27 days old)
Message-ID	: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=131107522914558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39902
Subject		: ath: Unable to reset channel (2412 MHz), reset status -5
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2011-07-19 6:13 (27 days old)
Message-ID	: <4E252076.1050309@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=131105603428323&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39832
Subject		: HDA ATI HDMI: no sound with 3.0 - 2.6.39.3 works
Submitter	: Andreas Steinmetz <ast@domdv.de>
Date		: 2011-07-23 01:36 (23 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39732
Subject		: JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr = 2512725). There's a risk of filesystem corruption in case of system crash.
Submitter	: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Date		: 2011-07-22 04:22 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39412
Subject		: Win Vista and Win2K8 guests' network breaks down
Submitter	: Jay Ren <yongjie.ren@intel.com>
Date		: 2011-07-15 15:31 (31 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39342
Subject		: [3.0.0-rc6-git7] possible recursive locking at cache_alloc_refill
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2011-07-11 12:37 (35 days old)
Message-ID	: <201107112137.FAD00545.SHtLOFOJOMFQFV@I-love.SAKURA.ne.jp>
References	: http://marc.info/?l=linux-kernel&m=131038788902151&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39192
Subject		: firmware_install fails with parallel make
Submitter	: Ambroz Bizjak <ambrop7@gmail.com>
Date		: 2011-07-12 09:35 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39132
Subject		: Starting with 3.0.0-rc6, masquerading seems to be broken.
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2011-07-10 19:45 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38922
Subject		: Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition writing and io errors on insert
Submitter	: Peter Vollmer <vollmerpeter@googlemail.com>
Date		: 2011-07-07 17:33 (39 days old)
First-Bad-Commit: http://git.kernel.org/linus/a3c7778f8153b9e4eceea6738973280b9e63c618


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38622
Subject		: [radeon cayman regresion] artefacts on screen
Submitter	: Marek Hobler, &apos;neutrinus&apos; <kernellist@neutrinus.com>
Date		: 2011-07-01 09:35 (45 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38612
Subject		: Boot time warnings in APIC
Submitter	: Bill Huey <bill.huey@gmail.com>
Date		: 2011-07-01 06:44 (45 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38582
Subject		: T510 43495KG won't resume with 32bit installation
Submitter	: Marc Koschewski <marc@osknowledge.org>
Date		: 2011-06-30 22:39 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37432
Subject		: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
Submitter	: Oliver Hartkopp <socketcan@hartkopp.net>
Date		: 2011-06-07 20:06 (69 days old)
First-Bad-Commit: http://git.kernel.org/linus/da7822e5ad71ec9b745b412639f1e5e0ba795a20
References	: http://article.gmane.org/gmane.linux.kernel.mmc/8442
		  https://lkml.org/lkml/2011/6/23/660


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40062
Subject		: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2011-07-22 19:27 (24 days old)
Message-ID	: <20110722192722.GA9369@x61.home>
References	: http://marc.info/?l=linux-kernel&m=131136334621623&w=2
Patch		: https://lkml.org/lkml/2011/8/2/174


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39882
Subject		: Kernel oops when turning bluetooth mouse on
Submitter	: Lamarque V. Souza <lamarque@gmail.com>
Date		: 2011-07-24 02:09 (22 days old)
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=66632


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37872
Subject		: CPU lockup during boot
Submitter	: Bruno Wolff III <bruno@wolff.to>
Date		: 2011-06-19 15:00 (57 days old)
Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=37872#c16


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.39 and 3.0, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=36912

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

