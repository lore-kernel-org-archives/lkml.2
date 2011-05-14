Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1ENWrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:47:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab1ENWrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:47:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.39-rc7-git7: Reported regressions 2.6.37 -> 2.6.38
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
Message-ID: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
Date: Sun, 15 May 2011 00:39:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE:
 This most likely is the last summary report of post-2.6.37 regressions
 introduced during the 2.6.38 development cycle.  Please let us know what
 the current status of those bugs is, if possible, and thanks for all of
 the reports, updates and fixes.]

This message contains a list of some post-2.6.37 regressions introduced before
2.6.38, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-2.6.37 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-05-15      107       23          20
  2011-04-30      105       29          28
  2011-04-17       98       28          28
  2011-03-27       88       26          26
  2011-03-06       70       27          26
  2011-02-21       51       18          17
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34992
Subject		: Regression with ath5k, cannot find any wireless network
Submitter	: Joshua Covington <joshuacov@googlemail.com>
Date		: 2011-05-12 11:24 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33982
Subject		: ath9k: regulatory: strange tx power limits
Submitter	: Richard Schütz <r.schtz@t-online.de>
Date		: 2011-04-26 18:37 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33882
Subject		: rt2800pci bad performance in 2.6.38
Submitter	: Ricardo Graça <r.jpg@iol.pt>
Date		: 2011-04-23 14:35 (22 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33852
Subject		: Regression of AR2413 802.11bg in 2.6.38.4
Submitter	: Boris Popov <popov.b@gmail.com>
Date		: 2011-04-23 12:12 (22 days old)
First-Bad-Commit: http://git.kernel.org/linus/42c025f3de9042d9c9abd9a6f6205d1a0f4bcadf


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33662
Subject		: System hangs during X startup (kwin compositing?)
Submitter	: Luke-Jr <luke-jr+linuxbugs@utopios.org>
Date		: 2011-04-19 04:26 (26 days old)
First-Bad-Commit: http://git.kernel.org/linus/e8616b6ced6137085e6657cc63bc2fe3900b8616


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32862
Subject		: acer_wmi partially crashes ACPI/EC (Aspire 8930G)
Submitter	: Hector Martin <hector@marcansoft.com>
Date		: 2011-04-07 17:44 (38 days old)
Handled-By	: Lee, Chun-Yi <jlee@novell.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32522
Subject		: drm:i915_hangcheck_ring_idle after suspend/resume cycle
Submitter	:  <fhimpe@telenet.be>
Date		: 2011-04-02 18:40 (43 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32202
Subject		: 2.6.38 hangs on boot until key is pressed
Submitter	: Tvrtko Ursulin <tvrtko@ursulin.net>
Date		: 2011-03-27 19:18 (49 days old)
Message-ID	: <1301253485.2500.2.camel@deuteros>
References	: http://marc.info/?l=linux-kernel&m=130125411116558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31922
Subject		: ath5k: Decreased throughput in IBSS or 802.11n mode
Submitter	: Jeff Cook <jeff@deserettechnology.com>
Date		: 2011-03-26 20:06 (50 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31782
Subject		: nouveau: lockdep spew
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2011-03-24 09:51 (52 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31572
Subject		: BUG in vb_alloc() - firewire crash at boot
Submitter	: Pavel Kysilka <goldenfish@linuxsoft.cz>
Date		: 2011-03-21 12:40 (55 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31402
Subject		: Diminished brightness at startup
Submitter	: Guilherme Salazar <guilhermesalazar@ymail.com>
Date		: 2011-03-18 16:29 (58 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
Subject		: 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2011-03-14 21:34 (62 days old)
Message-ID	: <4D7E89E7.3080505@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31012
Subject		: WARNING: Perf: bad frame pointer = (null), 2.6.38-rc8
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2011-03-12 19:08 (64 days old)
Message-ID	: <20110312140851.52420149@katamari>
References	: http://marc.info/?l=linux-kernel&m=129995721014931&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30992
Subject		: 2.6.38-rc7: Some strange soft-lockup
Submitter	: Dmitry Nezhevenko <dion@inhex.net>
Date		: 2011-03-06 14:01 (70 days old)
Message-ID	: <20110306140104.GA7700@laptop.local>
References	: http://marc.info/?l=linux-kernel&m=129942161205739&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29992
Subject		: boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
Submitter	: De Ganseman Amaury <amaury.deganseman@gmail.com>
Date		: 2011-02-27 10:38 (77 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-02-19 6:02 (85 days old)
Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (97 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (103 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (104 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34252
Subject		: Unexpected behaviour when switching video cards with vga_switcheroo
Submitter	: Igor Murzov <e-mail@date.by>
Date		: 2011-05-02 22:39 (13 days old)
Handled-By	: Florian Mickler <florian@mickler.org>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=57582


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32072
Subject		: 2.6.38 Regression: Nvidia GeForce8400 + i915 = Crash on Boot
Submitter	: simon@mungewell.org
Date		: 2011-03-24 15:20 (52 days old)
Message-ID	: <fe471c05897776b7c26b9fd2603e3b76.squirrel@host171.canaca.com>
References	: http://marc.info/?l=linux-kernel&m=130100955926434&w=2
Patch		: http://marc.info/?l=linux-xfs&m=130144519123809&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31522
Subject		: i915/kms regression after 2.6.38-rc8 (was: Re: Linux 2.6.38)
Submitter	: Melchior FRANZ <melchior.franz@gmail.com>
Date		: 2011-03-16 17:30 (60 days old)
Message-ID	: <201103161830.52231@rk-nord.at>
References	: http://marc.info/?l=linux-kernel&m=130029706416659&w=2
		  http://marc.info/?l=linux-kernel&m=130409270332174&w=2
Patch		: https://patchwork.kernel.org/patch/743162/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.37 and 2.6.38, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

