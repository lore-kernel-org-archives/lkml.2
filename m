Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1C0UTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:19:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45727 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab1C0UTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:19:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-git18: Reported regressions from 2.6.37
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
Message-ID: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
Date: Sun, 27 Mar 2011 22:01:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.37,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.37, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-03-27       88       26          26
  2011-03-06       70       27          26
  2011-02-21       51       18          17
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31982
Subject		: XFS memory allocation deadlock in 2.6.38
Submitter	: Sean Noonan <Sean.Noonan@twosigma.com>
Date		: 2011-03-21 16:19 (7 days old)
Message-ID	: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
References	: http://marc.info/?l=linux-kernel&m=130072585111310&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31572
Subject		: firewire crash at boot
Submitter	: Pavel Kysilka <goldenfish@linuxsoft.cz>
Date		: 2011-03-21 12:40 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31532
Subject		: 2.6.38: Quota over NFS4
Submitter	: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Date		: 2011-03-17 13:32 (11 days old)
Message-ID	: <20110317133247.GB6424@os.inf.tu-dresden.de>
References	: http://marc.info/?l=linux-kernel&m=130036878203485&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31522
Subject		: i915/kms regression after 2.6.38-rc8 (was: Re: Linux 2.6.38)
Submitter	: Melchior FRANZ <melchior.franz@gmail.com>
Date		: 2011-03-16 17:30 (12 days old)
Message-ID	: <201103161830.52231@rk-nord.at>
References	: http://marc.info/?l=linux-kernel&m=130029706416659&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31452
Subject		: ath9k: throughput issue in 802.11n and also IBSS mode
Submitter	: Richard Schütz <r.schtz@t-online.de>
Date		: 2011-03-19 19:06 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31402
Subject		: Diminished brightness at startup
Submitter	: Guilherme Salazar <guilhermesalazar@ymail.com>
Date		: 2011-03-18 16:29 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
Subject		: 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2011-03-14 21:34 (14 days old)
Message-ID	: <4D7E89E7.3080505@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31102
Subject		: Corrupted display, unusable X-Server after using Chromium for some minutes.
Submitter	: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Date		: 2011-03-15 03:31 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31012
Subject		: WARNING: Perf: bad frame pointer = (null), 2.6.38-rc8
Submitter	: Chuck Ebbert <cebbert@redhat.com>
Date		: 2011-03-12 19:08 (16 days old)
Message-ID	: <20110312140851.52420149@katamari>
References	: http://marc.info/?l=linux-kernel&m=129995721014931&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31002
Subject		: acer-wmi: rfkill and bluetooth enabling doesn't work as in 2.6.37
Submitter	: Oldřich Jedlička <oldium.pro@seznam.cz>
Date		: 2011-03-10 18:37 (18 days old)
Message-ID	: <201103101937.01864.oldium.pro@seznam.cz>
References	: http://marc.info/?l=linux-acpi&m=129978235612140&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30992
Subject		: 2.6.38-rc7: Some strange soft-lockup
Submitter	: Dmitry Nezhevenko <dion@inhex.net>
Date		: 2011-03-06 14:01 (22 days old)
Message-ID	: <20110306140104.GA7700@laptop.local>
References	: http://marc.info/?l=linux-kernel&m=129942161205739&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30852
Subject		: Seldom errors after suspend/resume causing problems
Submitter	: Mehmet Giritli <mehmet@giritli.eu>
Date		: 2011-03-10 10:53 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30612
Subject		: 2.6.38-rc7, iwlagn crash
Submitter	: Mathias Burén <mathias.buren@gmail.com>
Date		: 2011-03-04 3:27 (24 days old)
Message-ID	: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129920925514892&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2011-03-03 5:47 (25 days old)
Message-ID	: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30572
Subject		: 2.6.38-rc7, OOM behaviour?
Submitter	: Mathias Burén <mathias.buren@gmail.com>
Date		: 2011-03-02 19:33 (26 days old)
Message-ID	: <AANLkTine5sru_JsK1LmRVa9fwxjPsaDdZUTFPCBi6A+c@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129909440018096&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30142
Subject		: Kernel Oops after hibernation - lenovo t500
Submitter	: Willi Mann <foss-ml@wm1.at>
Date		: 2011-03-01 08:12 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29992
Subject		: boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
Submitter	: De Ganseman Amaury <amaury.deganseman@gmail.com>
Date		: 2011-02-27 10:38 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29852
Subject		: 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2011-02-21 20:33 (35 days old)
Message-ID	: <AANLkTi=14N_c_B7mLY0H8Dt8pte6C0mjFnVuC37e44Hs@mail.gmail.com>
References	: http://marc.info/?l=linux-netdev&m=129832042402668&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-02-19 6:02 (37 days old)
Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2011-02-08 9:41 (48 days old)
Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28642
Subject		: ACPI broken on DELL Latitude E6410 in 2.6.38-rc3
Submitter	: Adam Kovari <kovariadam@gmail.com>
Date		: 2011-02-08 22:22 (48 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
Subject		: [BUG] usb problems in .38-rc3+
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2011-02-05 19:17 (51 days old)
Message-ID	: <201102051417.58953.edt@aei.ca>
References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (49 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (55 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (56 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Date		: 2011-01-28 20:29 (59 days old)
Message-ID	: <20110128202905.GB3395@schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.37,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

