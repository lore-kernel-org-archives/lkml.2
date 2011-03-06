Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1CFMSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:18:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55703 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab1CFMSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:18:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc7-git4: Reported regressions from 2.6.37
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
Message-ID: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
Date: Sun,  6 Mar 2011 13:08:06 +0100 (CET)
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
  2011-03-06       70       27          26
  2011-02-21       51       18          17
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30472
Subject		: 2.6.38-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Submitter	: Martin Steigerwald <Martin@lichtvoll.de>
Date		: 2011-03-05 15:10:24 (2 days old)
Message-ID	: <201103051510.35057.Martin@lichtvoll.de>
References	: http://marc.info/?l=linux-kernel&m=129933425306804&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30462
Subject		: High cpu usage when someone sends many ipv6 udp packages
Submitter	: Ernst Sjöstrand <ernstp@gmail.com>
Date		: 2011-03-05 01:10 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30142
Subject		: Kernel Oops after hibernation
Submitter	: Willi Mann <foss-ml@wm1.at>
Date		: 2011-03-01 08:12 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30072
Subject		: USB-to-serial problems in 2.6.37.1+ (pl2303)
Submitter	:  <akwatts@ymail.com>
Date		: 2011-02-28 12:39 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30062
Subject		: Huge amounts of "HDIO_GET_IDENTITY failed for /dev/sr0" messages during boot
Submitter	: Bernd Eggink <monoped@sudrala.de>
Date		: 2011-02-28 10:52 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30032
Subject		: r8169: 60 seconds delay when resuming from suspend
Submitter	: Guillaume Ayoub <xovni@wanadoo.fr>
Date		: 2011-02-27 16:52 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29992
Subject		: boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
Submitter	: De Ganseman Amaury <amaury.deganseman@gmail.com>
Date		: 2011-02-27 10:38 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29952
Subject		: btrfs as root filesystems hangs on mount after d863b50ab01333659314c2034890cb76d9fdc3c7
Submitter	: Asbjørn Sannes <ace@sannes.org>
Date		: 2011-02-26 15:59 (9 days old)
First-Bad-Commit: http://git.kernel.org/linus/d863b50ab01333659314c2034890cb76d9fdc3c7


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29902
Subject		: System suspend failed after 1-2 successful resumes
Submitter	: Alex Terekhov <a.terekhov@gmail.com>
Date		: 2011-02-25 22:24 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29852
Subject		: 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2011-02-21 20:33 (14 days old)
Message-ID	: <AANLkTi=14N_c_B7mLY0H8Dt8pte6C0mjFnVuC37e44Hs@mail.gmail.com>
References	: http://marc.info/?l=linux-netdev&m=129832042402668&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29812
Subject		: Brightness levels too low on Dell Inspiron 13" Intel HD 4 Series
Submitter	: Niklas Schnelle <niklas@komani.de>
Date		: 2011-02-24 10:24 (11 days old)
First-Bad-Commit: http://git.kernel.org/linus/951f3512dba5bd44cda3e5ee22b4b522e4bb09fb


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-02-19 6:02 (16 days old)
Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29312
Subject		: Unmounting fails even after the underlying device is long gone
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2011-02-17 19:20 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29252
Subject		: IPv6 doesn't work in a kvm guest.
Submitter	: Kusanagi Kouichi <slash@ac.auone-net.jp>
Date		: 2011-02-16 13:03 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29022
Subject		: [REGRESSION? 2.6.38-rc4] nouveau NV50/NVA8 screen freeze
Submitter	: Marc Koschewski <marc@osknowledge.org>
Date		: 2011-02-13 12:29 (22 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28882
Subject		: Screen corruption and GPU hangs
Submitter	: Ko Mi <chaostya.test@hotmail.com>
Date		: 2011-02-11 18:17 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2011-02-08 9:41 (27 days old)
Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28642
Subject		: ACPI broken on DELL Latitude E6410 in 2.6.38-rc3
Submitter	: Adam Kovari <kovariadam@gmail.com>
Date		: 2011-02-08 22:22 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
Subject		: [BUG] usb problems in .38-rc3+
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2011-02-05 19:17 (30 days old)
Message-ID	: <201102051417.58953.edt@aei.ca>
References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (34 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28432
Subject		: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Submitter	: Jindřich Makovička <makovick@gmail.com>
Date		: 2011-01-31 19:28 (35 days old)
Message-ID	: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129650210516627&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (35 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28262
Subject		: Slow resume from suspend/hibernate on Dell Inspiron M301Z
Submitter	: Luca Ferretti <lferrett@gnome.org>
Date		: 2011-02-05 12:37 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Date		: 2011-01-28 20:29 (38 days old)
Message-ID	: <20110128202905.GB3395@schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27022
Subject		: [REPORT] BUG: spinlock recursion on CPU#0, init/1
Submitter	: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date		: 2011-01-10 15:33 (56 days old)
Message-ID	: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129467294808655&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29402
Subject		: kernel panics while running ffsb scalability workloads on 2.6.38-rc1 through -rc5
Submitter	: Eric Whitney <eric.whitney@hp.com>
Date		: 2011-02-18 21:47 (17 days old)
Handled-By	: Lukas Czerner <lczerner@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=49642


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.37,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

