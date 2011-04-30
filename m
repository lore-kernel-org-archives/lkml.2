Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1D3UQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:16:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1D3UQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:16:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.39-rc5-git4: Reported regressions 2.6.37 -> 2.6.38
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
Message-ID: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera>
Date: Sat, 30 Apr 2011 22:13:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
  2011-04-30      105       29          28
  2011-04-17       98       28          28
  2011-03-27       88       26          26
  2011-03-06       70       27          26
  2011-02-21       51       18          17
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34022
Subject		: Kernel OOPS turning on Radeon on vgaswitcheroo enabled system
Submitter	:  <blazej.bucko@gmail.com>
Date		: 2011-04-27 19:39 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33982
Subject		: ath9k: regulatory: strange tx power limits
Submitter	: Richard Schütz <r.schtz@t-online.de>
Date		: 2011-04-26 18:37 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33892
Subject		: Kernel sometimes fails to find major/minor number of root device
Submitter	: Aaron Barany <akb825@gmail.com>
Date		: 2011-04-23 20:13 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33882
Subject		: rt2800pci bad performance in 2.6.38
Submitter	: Ricardo Graça <r.jpg@iol.pt>
Date		: 2011-04-23 14:35 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33852
Subject		: Regression of AR2413 802.11bg in 2.6.38.4
Submitter	: Boris Popov <popov.b@gmail.com>
Date		: 2011-04-23 12:12 (8 days old)
First-Bad-Commit: http://git.kernel.org/linus/42c025f3de9042d9c9abd9a6f6205d1a0f4bcadf


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33662
Subject		: System hangs during X startup (kwin compositing?)
Submitter	: Luke-Jr <luke-jr+linuxbugs@utopios.org>
Date		: 2011-04-19 04:26 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32762
Subject		: Booting with external monitor attached results in red flickering screen on the external monitor
Submitter	: Anton <anton.bugs@gmail.com>
Date		: 2011-04-06 04:50 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32522
Subject		: drm:i915_hangcheck_ring_idle after suspend/resume cycle
Submitter	:  <fhimpe@telenet.be>
Date		: 2011-04-02 18:40 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32202
Subject		: 2.6.38 hangs on boot until key is pressed
Submitter	: Tvrtko Ursulin <tvrtko@ursulin.net>
Date		: 2011-03-27 19:18 (35 days old)
Message-ID	: <1301253485.2500.2.camel@deuteros>
References	: http://marc.info/?l=linux-kernel&m=130125411116558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32112
Subject		: Writes to USB flash drives are extremely slow in 2.6.38
Submitter	: Delan Azabani <delan@azabani.com>
Date		: 2011-03-29 08:10 (33 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32072
Subject		: 2.6.38 Regression: Nvidia GeForce8400 + i915 = Crash on Boot
Submitter	: simon@mungewell.org
Date		: 2011-03-24 15:20 (38 days old)
Message-ID	: <fe471c05897776b7c26b9fd2603e3b76.squirrel@host171.canaca.com>
References	: http://marc.info/?l=linux-kernel&m=130100955926434&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31982
Subject		: XFS memory allocation deadlock in 2.6.38
Submitter	: Sean Noonan <Sean.Noonan@twosigma.com>
Date		: 2011-03-21 16:19 (41 days old)
Message-ID	: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
References	: http://marc.info/?l=linux-kernel&m=130072585111310&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31922
Subject		: ath5k: Decreased throughput in IBSS or 802.11n mode
Submitter	: Jeff Cook <jeff@deserettechnology.com>
Date		: 2011-03-26 20:06 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31782
Subject		: nouveau: lockdep spew
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2011-03-24 09:51 (38 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31702
Subject		: ath5k phy2: failed to wakeup the MAC Chip
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2011-03-22 19:15 (40 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31572
Subject		: BUG in vb_alloc() - firewire crash at boot
Submitter	: Pavel Kysilka <goldenfish@linuxsoft.cz>
Date		: 2011-03-21 12:40 (41 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31532
Subject		: 2.6.38: Quota over NFS4
Submitter	: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Date		: 2011-03-17 13:32 (45 days old)
Message-ID	: <20110317133247.GB6424@os.inf.tu-dresden.de>
References	: http://marc.info/?l=linux-kernel&m=130036878203485&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31522
Subject		: i915/kms regression after 2.6.38-rc8 (was: Re: Linux 2.6.38)
Submitter	: Melchior FRANZ <melchior.franz@gmail.com>
Date		: 2011-03-16 17:30 (46 days old)
Message-ID	: <201103161830.52231@rk-nord.at>
References	: http://marc.info/?l=linux-kernel&m=130029706416659&w=2
		  http://marc.info/?l=linux-kernel&m=130409270332174&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31402
Subject		: Diminished brightness at startup
Submitter	: Guilherme Salazar <guilhermesalazar@ymail.com>
Date		: 2011-03-18 16:29 (44 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
Subject		: 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2011-03-14 21:34 (48 days old)
Message-ID	: <4D7E89E7.3080505@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31012
Subject		: WARNING: Perf: bad frame pointer = (null), 2.6.38-rc8
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2011-03-12 19:08 (50 days old)
Message-ID	: <20110312140851.52420149@katamari>
References	: http://marc.info/?l=linux-kernel&m=129995721014931&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30992
Subject		: 2.6.38-rc7: Some strange soft-lockup
Submitter	: Dmitry Nezhevenko <dion@inhex.net>
Date		: 2011-03-06 14:01 (56 days old)
Message-ID	: <20110306140104.GA7700@laptop.local>
References	: http://marc.info/?l=linux-kernel&m=129942161205739&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2011-03-03 5:47 (59 days old)
Message-ID	: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29992
Subject		: boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
Submitter	: De Ganseman Amaury <amaury.deganseman@gmail.com>
Date		: 2011-02-27 10:38 (63 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-02-19 6:02 (71 days old)
Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (83 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (89 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (90 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32862
Subject		: acer_wmi partially crashes ACPI/EC (Aspire 8930G)
Submitter	: Hector Martin <hector@marcansoft.com>
Date		: 2011-04-07 17:44 (24 days old)
Handled-By	: Lee, Chun-Yi <jlee@novell.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=54492


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.37 and 2.6.38, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

