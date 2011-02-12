Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1BLXBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:01:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab1BLXBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:01:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc4-git5: Reported regressions from 2.6.37
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
Message-ID: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
Date: Sat, 12 Feb 2011 23:57:33 +0100 (CET)
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
  2011-02-12       39       20          18
  2011-02-03       19       11           7


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28882
Subject		: Screen corruption and GPU hangs
Submitter	: Ko Mi <chaostya.test@hotmail.com>
Date		: 2011-02-11 18:17 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28852
Subject		: [KMS] radeon artifacts when switched to graphics during boot
Submitter	: Oldřich Jedlička <oldium.pro@seznam.cz>
Date		: 2011-02-10 21:11 (3 days old)
Handled-By	: Alex Deucher <alexdeucher@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28842
Subject		: 2.6.38-rc3 regression ipv6 TFTP download with curl failing in getpeername?
Submitter	: Eric W. Biederman <ebiederm@xmission.com>
Date		: 2011-02-08 9:41 (5 days old)
Message-ID	: <m1ei7iamnn.fsf@fess.ebiederm.org>
References	: http://marc.info/?l=linux-kernel&m=129715811421534&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28832
Subject		: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period of time tanks causing contant drops
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2011-02-07 3:54 (6 days old)
Message-ID	: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=129705125832718&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28642
Subject		: ACPI broken on DELL Latitude E6410 in 2.6.38-rc3
Submitter	: Adam Kovari <kovariadam@gmail.com>
Date		: 2011-02-08 22:22 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
Subject		: [BUG] usb problems in .38-rc3+
Submitter	: Ed Tomlinson <edt@aei.ca>
Date		: 2011-02-05 19:17 (8 days old)
Message-ID	: <201102051417.58953.edt@aei.ca>
References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28522
Subject		: Unable to mount FAT-formatted floppy on /dev/fd0, plus WARN_ON when using /dev/fd0u1440
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2011-02-07 17:21 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28452
Subject		: 2.6.38-rc3 regression on parisc: segfaults
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2011-02-01 22:00 (12 days old)
Message-ID	: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References	: http://marc.info/?l=linux-kernel&m=129659763426600&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28442
Subject		: 2.6.38-rc3: FUSE (sshfs) hangs under load
Submitter	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date		: 2011-02-01 17:54 (12 days old)
First-Bad-Commit: http://git.kernel.org/linus/4cd06a344db752f513437138953af191cbe9a691
Message-ID	: <20110201175452.GB518@core.coreip.homeip.net>
References	: http://marc.info/?l=linux-kernel&m=129658291703679&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28432
Subject		: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Submitter	: Jindřich Makovička <makovick@gmail.com>
Date		: 2011-01-31 19:28 (13 days old)
Message-ID	: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129650210516627&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28422
Subject		: kref and apparmor panic in 2.6.38-rc2.
Submitter	: Tao Ma <tm@tao.ma>
Date		: 2011-01-31 10:06 (13 days old)
Message-ID	: <4D46899B.80302@tao.ma>
References	: http://marc.info/?l=linux-kernel&m=129646840303149&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28262
Subject		: Slow resume from suspend/hibernate on Dell Inspiron M301Z
Submitter	: Luca Ferretti <lferrett@gnome.org>
Date		: 2011-02-05 12:37 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28232
Subject		: Kernel panics with 2.6.38 (rc1, rc2, rc3, rc4) and the lzo compression of btrfs
Submitter	: Juan Francisco Cantero Hurtado <iam@juanfra.info>
Date		: 2011-02-05 04:44 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28102
Subject		: New display errors in 2.6.38-rc2-00175-g6fb1b30
Submitter	: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Date		: 2011-01-28 20:29 (16 days old)
Message-ID	: <20110128202905.GB3395@schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=129624657425949&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28052
Subject		: [BUG] 2.6.38-rc2: Circular Locking Dependency
Submitter	: Knut Petersen <Knut_Petersen@t-online.de>
Date		: 2011-01-24 9:25 (20 days old)
Message-ID	: <4D3D45A3.7040809@t-online.de>
References	: http://marc.info/?l=linux-kernel&m=129586118515443&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27762
Subject		: Brightness Adjustment on Toshiba nb305 Netbooks is non-functional.
Submitter	: John Mesmon <jmesmon@gmail.com>
Date		: 2011-01-29 03:47 (15 days old)
First-Bad-Commit: http://git.kernel.org/linus/44834a67c0082e2cf74b16be91e49108b1432d65


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27382
Subject		: ath5k phy0: gain calibration timeout
Submitter	: Nicolas Stransky <Nico@stransky.cx>
Date		: 2011-01-23 00:18 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27022
Subject		: [REPORT] BUG: spinlock recursion on CPU#0, init/1
Submitter	: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date		: 2011-01-10 15:33 (34 days old)
Message-ID	: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129467294808655&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28802
Subject		: commit 5d1d0cc breaks resume from suspend on Thinkpad X201
Submitter	: Björn Schließmann <chronoss@gmx.de>
Date		: 2011-02-10 17:23 (3 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=47172


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27702
Subject		: regression 2.6.37 -> 2.6.38-rc1: after suspend backlight cannot be adjusted
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2011-01-21 1:55 (23 days old)
Message-ID	: <20110121015529.GD9796@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=129557717826819&w=2
Handled-By	: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Patch		: https://patchwork.kernel.org/patch/499221/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.37,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=27352

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

