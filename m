Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1H1TlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:41:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab1H1Tkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:40:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.1-rc3-git6: Reported regressions 2.6.39 -> 3.0
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
Message-ID: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
Date: Sun, 28 Aug 2011 20:58:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
  2011-08-28       71       21          17
  2011-08-14       63       22          19
  2011-07-10       38       16          13
  2011-06-26       22       14          12
  2011-06-12        8        7           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41562
Subject		: acer-wmi: acer aspire 721 bluetooth control doesn't work with kernel 3.0.0
Submitter	: sbraz <hi.sbraz@gmail.com>
Date		: 2011-08-22 18:32 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41102
Subject		: BUG dentry: Poison overwritten / BUG buffer_head: Poison overwritten
Submitter	: Paul Bolle <pebolle@tiscali.nl>
Date		: 2011-08-13 22:29 (16 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41092
Subject		: INFO: trying to register non-static key (sync_inodes_sb)
Submitter	: Paul Bolle <pebolle@tiscali.nl>
Date		: 2011-08-13 22:07 (16 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40442
Subject		: cpuinfo_max_freq lost 500MHz
Submitter	: Harald Dunkel <harri@afaics.de>
Date		: 2011-08-02 20:31 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40282
Subject		: IP forwarding regression since 3.0-rc6
Submitter	: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Date		: 2011-07-25 12:51 (35 days old)
Message-ID	: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
References	: http://marc.info/?l=linux-kernel&m=131159880004908&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40262
Subject		: PROBLEM: I/O storm from hell on kernel 3.0.0 when touch swap (swapfile or partition)
Submitter	: g0re <g0re@null.net>
Date		: 2011-07-28 12:40 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40092
Subject		: RCU stall in linux-3.0.0
Submitter	: Philip Armstrong <phil@kantaka.co.uk>
Date		: 2011-07-25 21:44 (35 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40072
Subject		: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400, unless iwlagn unloaded
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2011-07-23 19:27 (37 days old)
Message-ID	: <201107232127.34255.toralf.foerster@gmx.de>
References	: http://marc.info/?l=linux-kernel&m=131144928023465&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39922
Subject		: WIFI becomes EXTREMELY slow ( ath9k ) making the connection unusable
Submitter	: Lukasz Olszewski <lcpak@epoczta.pl>
Date		: 2011-07-24 09:20 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39912
Subject		: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2011-07-19 11:33 (41 days old)
Message-ID	: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=131107522914558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39832
Subject		: HDA ATI HDMI: no sound with 3.0 - 2.6.39.3 works
Submitter	: Andreas Steinmetz <ast@domdv.de>
Date		: 2011-07-23 01:36 (37 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39732
Subject		: JBD: Spotted dirty metadata buffer (dev = dm-2, blocknr = 2512725). There's a risk of filesystem corruption in case of system crash.
Submitter	: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Date		: 2011-07-22 04:22 (38 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39412
Subject		: Win Vista and Win2K8 guests' network breaks down
Submitter	: Jay Ren <yongjie.ren@intel.com>
Date		: 2011-07-15 15:31 (45 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39192
Subject		: firmware_install fails with parallel make
Submitter	: Ambroz Bizjak <ambrop7@gmail.com>
Date		: 2011-07-12 09:35 (48 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38922
Subject		: Lenovo T420 (Sandy Bridge) Crashes on SD Card gpt partition writing and io errors on insert
Submitter	: Peter Vollmer <vollmerpeter@googlemail.com>
Date		: 2011-07-07 17:33 (53 days old)
First-Bad-Commit: http://git.kernel.org/linus/a3c7778f8153b9e4eceea6738973280b9e63c618


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38622
Subject		: [radeon cayman regresion] artefacts on screen
Submitter	: Marek Hobler, &apos;neutrinus&apos; <kernellist@neutrinus.com>
Date		: 2011-07-01 09:35 (59 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38582
Subject		: T510 43495KG won't resume with 32bit installation
Submitter	: Marc Koschewski <marc@osknowledge.org>
Date		: 2011-06-30 22:39 (60 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41262
Subject		: Terracted T5 does no more work
Submitter	: Eric Valette <eric.valette@free.fr>
Date		: 2011-08-16 20:45 (13 days old)
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=69382
		  https://bugzilla.kernel.org/attachment.cgi?id=69392
		  https://bugzilla.kernel.org/attachment.cgi?id=69402


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41232
Subject		: Channel switching on Hauppauge Nova-T stick fails randomly
Submitter	:  <q222@gmx.com>
Date		: 2011-08-16 11:33 (13 days old)
Patch		: http://git.linuxtv.org/pb/media_tree.git/commitdiff/aeb2d456b746164a4bd19e53de0a6678ca63fcad
		  http://git.linuxtv.org/pb/media_tree.git/commitdiff/45cbff13693d645fa5dcbba964e802e1746b2e57
		  http://git.linuxtv.org/pb/media_tree.git/commitdiff/45cbff13693d645fa5dcbba964e802e1746b2e57


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40062
Subject		: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2011-07-22 19:27 (38 days old)
Message-ID	: <20110722192722.GA9369@x61.home>
References	: http://marc.info/?l=linux-kernel&m=131136334621623&w=2
Patch		: https://lkml.org/lkml/2011/8/2/174


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39882
Subject		: Kernel oops when turning bluetooth mouse on
Submitter	: Lamarque V. Souza <lamarque@gmail.com>
Date		: 2011-07-24 02:09 (36 days old)
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=70342


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.39 and 3.0, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=36912

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

