Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1DQNsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:48:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1DQNsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:48:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc3-git7: Reported regressions 2.6.37 -> 2.6.38
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
Message-ID: <sam8u5dLkaB.A.afE.53uqNB@chimera>
Date: Sun, 17 Apr 2011 15:48:28 +0200 (CEST)
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
  2011-04-17       98       28          28
  2011-03-27       88       26          26
  2011-03-06       70       27          26
  2011-02-21       51       18          17
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32862
Subject		: acer_wmi partially crashes ACPI/EC (Aspire 8930G)
Submitter	: Hector Martin <hector@marcansoft.com>
Date		: 2011-04-07 17:44 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32762
Subject		: Booting with external monitor attached results in red flickering screen on the external monitor
Submitter	: Anton <anton.bugs@gmail.com>
Date		: 2011-04-06 04:50 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32202
Subject		: 2.6.38 hangs on boot until key is pressed
Submitter	: Tvrtko Ursulin <tvrtko@ursulin.net>
Date		: 2011-03-27 19:18 (22 days old)
Message-ID	: <1301253485.2500.2.camel@deuteros>
References	: http://marc.info/?l=linux-kernel&m=130125411116558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32112
Subject		: Writes to USB flash drives are extremely slow in 2.6.38
Submitter	: Delan Azabani <delan@azabani.com>
Date		: 2011-03-29 08:10 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32072
Subject		: 2.6.38 Regression: Nvidia GeForce8400 + i915 = Crash on Boot
Submitter	: simon@mungewell.org
Date		: 2011-03-24 15:20 (25 days old)
Message-ID	: <fe471c05897776b7c26b9fd2603e3b76.squirrel@host171.canaca.com>
References	: http://marc.info/?l=linux-kernel&m=130100955926434&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31982
Subject		: XFS memory allocation deadlock in 2.6.38
Submitter	: Sean Noonan <Sean.Noonan@twosigma.com>
Date		: 2011-03-21 16:19 (28 days old)
Message-ID	: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
References	: http://marc.info/?l=linux-kernel&m=130072585111310&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31922
Subject		: ath5k: Decreased throughput in IBSS or 802.11n mode
Submitter	: Jeff Cook <jeff@deserettechnology.com>
Date		: 2011-03-26 20:06 (23 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31872
Subject		: boot panic unless acpi=off, Thread overran stack, or stack corrupted - Toshiba Satellite/mobile P4
Submitter	: Pascal Dormeau <pdormeau@free.fr>
Date		: 2011-03-25 20:17 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31782
Subject		: nouveau: lockdep spew
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2011-03-24 09:51 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31702
Subject		: ath5k phy2: failed to wakeup the MAC Chip
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2011-03-22 19:15 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31572
Subject		: BUG in vb_alloc() - firewire crash at boot
Submitter	: Pavel Kysilka <goldenfish@linuxsoft.cz>
Date		: 2011-03-21 12:40 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31532
Subject		: 2.6.38: Quota over NFS4
Submitter	: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Date		: 2011-03-17 13:32 (32 days old)
Message-ID	: <20110317133247.GB6424@os.inf.tu-dresden.de>
References	: http://marc.info/?l=linux-kernel&m=130036878203485&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31452
Subject		: ath9k: throughput issue in 802.11n and also IBSS mode
Submitter	: Richard Schütz <r.schtz@t-online.de>
Date		: 2011-03-19 19:06 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31402
Subject		: Diminished brightness at startup
Submitter	: Guilherme Salazar <guilhermesalazar@ymail.com>
Date		: 2011-03-18 16:29 (31 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
Subject		: 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2011-03-14 21:34 (35 days old)
Message-ID	: <4D7E89E7.3080505@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31012
Subject		: WARNING: Perf: bad frame pointer = (null), 2.6.38-rc8
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2011-03-12 19:08 (37 days old)
Message-ID	: <20110312140851.52420149@katamari>
References	: http://marc.info/?l=linux-kernel&m=129995721014931&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30992
Subject		: 2.6.38-rc7: Some strange soft-lockup
Submitter	: Dmitry Nezhevenko <dion@inhex.net>
Date		: 2011-03-06 14:01 (43 days old)
Message-ID	: <20110306140104.GA7700@laptop.local>
References	: http://marc.info/?l=linux-kernel&m=129942161205739&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30852
Subject		: Seldom errors after suspend/resume causing problems
Submitter	: Mehmet Giritli <mehmet@giritli.eu>
Date		: 2011-03-10 10:53 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2011-03-03 5:47 (46 days old)
Message-ID	: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29992
Subject		: boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
Submitter	: De Ganseman Amaury <amaury.deganseman@gmail.com>
Date		: 2011-02-27 10:38 (50 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29852
Subject		: 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2011-02-21 20:33 (56 days old)
Message-ID	: <AANLkTi=14N_c_B7mLY0H8Dt8pte6C0mjFnVuC37e44Hs@mail.gmail.com>
References	: http://marc.info/?l=linux-netdev&m=129832042402668&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-02-19 6:02 (58 days old)
Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28802
Subject		: commit 5d1d0cc breaks resume from suspend on Thinkpad X201
Submitter	: Björn Schließmann <chronoss@gmx.de>
Date		: 2011-02-10 17:23 (67 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28642
Subject		: ACPI broken on DELL Latitude E6410 in 2.6.38-rc3
Submitter	: Adam Kovari <kovariadam@gmail.com>
Date		: 2011-02-08 22:22 (69 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
Subject		: [BUG] usb problems in .38-rc3+
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2011-02-05 19:17 (72 days old)
Message-ID	: <201102051417.58953.edt@aei.ca>
References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (70 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (76 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (77 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Regressions with patches
------------------------

For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.37 and 2.6.38, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

